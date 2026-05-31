#define _GNU_SOURCE

#include <errno.h>
#include <fcntl.h>
#include <linux/input.h>
#include <linux/uinput.h>
#include <poll.h>
#include <signal.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

#ifndef REL_WHEEL_HI_RES
#define REL_WHEEL_HI_RES 0x0b
#endif

#ifndef REL_HWHEEL_HI_RES
#define REL_HWHEEL_HI_RES 0x0c
#endif

static volatile sig_atomic_t running = 1;

static void on_signal(int sig)
{
    (void)sig;
    running = 0;
}

static int set_bit(int fd, unsigned long request, int code)
{
    if (ioctl(fd, request, code) < 0) {
        fprintf(stderr, "ioctl failed for code %d: %s\n", code, strerror(errno));
        return -1;
    }
    return 0;
}

static int open_uinput(const char *name)
{
    int fd = open("/dev/uinput", O_WRONLY | O_NONBLOCK);
    if (fd < 0) {
        fprintf(stderr, "failed to open /dev/uinput: %s\n", strerror(errno));
        return -1;
    }

    if (set_bit(fd, UI_SET_EVBIT, EV_KEY) < 0 ||
        set_bit(fd, UI_SET_EVBIT, EV_REL) < 0 ||
        set_bit(fd, UI_SET_EVBIT, EV_MSC) < 0 ||
        set_bit(fd, UI_SET_EVBIT, EV_SYN) < 0) {
        close(fd);
        return -1;
    }

    for (int code = 1; code < KEY_MAX; code++) {
        if (set_bit(fd, UI_SET_KEYBIT, code) < 0) {
            close(fd);
            return -1;
        }
    }

    const int rel_codes[] = {
        REL_X,
        REL_Y,
        REL_WHEEL,
        REL_HWHEEL,
        REL_WHEEL_HI_RES,
        REL_HWHEEL_HI_RES,
    };
    for (size_t i = 0; i < sizeof(rel_codes) / sizeof(rel_codes[0]); i++) {
        if (set_bit(fd, UI_SET_RELBIT, rel_codes[i]) < 0) {
            close(fd);
            return -1;
        }
    }

    if (set_bit(fd, UI_SET_MSCBIT, MSC_SCAN) < 0) {
        close(fd);
        return -1;
    }

    struct uinput_setup setup;
    memset(&setup, 0, sizeof(setup));
    setup.id.bustype = BUS_USB;
    setup.id.vendor = 0x1234;
    setup.id.product = 0x5680;
    setup.id.version = 1;
    snprintf(setup.name, UINPUT_MAX_NAME_SIZE, "%s", name);

    if (ioctl(fd, UI_DEV_SETUP, &setup) < 0) {
        fprintf(stderr, "UI_DEV_SETUP failed: %s\n", strerror(errno));
        close(fd);
        return -1;
    }

    if (ioctl(fd, UI_DEV_CREATE) < 0) {
        fprintf(stderr, "UI_DEV_CREATE failed: %s\n", strerror(errno));
        close(fd);
        return -1;
    }

    return fd;
}

static int emit_event(int fd, unsigned short type, unsigned short code, int value)
{
    struct input_event ev;
    memset(&ev, 0, sizeof(ev));
    ev.type = type;
    ev.code = code;
    ev.value = value;

    ssize_t written = write(fd, &ev, sizeof(ev));
    if (written != (ssize_t)sizeof(ev)) {
        fprintf(stderr, "failed to emit event: %s\n", strerror(errno));
        return -1;
    }
    return 0;
}

static int emit_input_event(int fd, const struct input_event *ev)
{
    if (ev->type != EV_SYN && ev->type != EV_KEY && ev->type != EV_REL &&
        !(ev->type == EV_MSC && ev->code == MSC_SCAN)) {
        return 0;
    }

    ssize_t written = write(fd, ev, sizeof(*ev));
    if (written != (ssize_t)sizeof(*ev)) {
        fprintf(stderr, "failed to forward event: %s\n", strerror(errno));
        return -1;
    }
    return 0;
}

static char *read_device_name(const char *event_path)
{
    const char *base = strrchr(event_path, '/');
    base = base ? base + 1 : event_path;

    char sysfs_path[256];
    snprintf(sysfs_path, sizeof(sysfs_path), "/sys/class/input/%s/device/name", base);

    FILE *fp = fopen(sysfs_path, "r");
    if (!fp) {
        return NULL;
    }

    char *line = NULL;
    size_t len = 0;
    ssize_t read = getline(&line, &len, fp);
    fclose(fp);

    if (read <= 0) {
        free(line);
        return NULL;
    }

    if (line[read - 1] == '\n') {
        line[read - 1] = '\0';
    }
    return line;
}

static char *find_event_by_name(const char *device_name)
{
    for (int i = 0; i < 256; i++) {
        char path[64];
        snprintf(path, sizeof(path), "/dev/input/event%d", i);

        char *name = read_device_name(path);
        if (!name) {
            continue;
        }

        bool match = strcmp(name, device_name) == 0;
        free(name);
        if (match) {
            return strdup(path);
        }
    }
    return NULL;
}

static int open_input(const char *device_name)
{
    while (running) {
        char *path = find_event_by_name(device_name);
        if (!path) {
            fprintf(stderr, "waiting for input device '%s'\n", device_name);
            sleep(1);
            continue;
        }

        int fd = open(path, O_RDONLY | O_NONBLOCK);
        if (fd < 0) {
            fprintf(stderr, "failed to open %s: %s\n", path, strerror(errno));
            free(path);
            sleep(1);
            continue;
        }

        if (ioctl(fd, EVIOCGRAB, 1) < 0) {
            fprintf(stderr, "failed to grab %s: %s\n", path, strerror(errno));
            close(fd);
            free(path);
            sleep(1);
            continue;
        }

        fprintf(stderr, "reading from %s (%s)\n", path, device_name);
        free(path);
        return fd;
    }
    return -1;
}

static int handle_rel_scroll(int out_fd, const struct input_event *ev, int *wheel_accum, int *hwheel_accum)
{
    const int scale = 5;

    if (ev->code == REL_Y) {
        int hi_res = -ev->value * scale;
        *wheel_accum += hi_res;
        if (hi_res != 0 && emit_event(out_fd, EV_REL, REL_WHEEL_HI_RES, hi_res) < 0) {
            return -1;
        }
        while (*wheel_accum >= 120) {
            if (emit_event(out_fd, EV_REL, REL_WHEEL, 1) < 0) {
                return -1;
            }
            *wheel_accum -= 120;
        }
        while (*wheel_accum <= -120) {
            if (emit_event(out_fd, EV_REL, REL_WHEEL, -1) < 0) {
                return -1;
            }
            *wheel_accum += 120;
        }
        return 0;
    }

    if (ev->code == REL_X) {
        int hi_res = ev->value * scale;
        *hwheel_accum += hi_res;
        if (hi_res != 0 && emit_event(out_fd, EV_REL, REL_HWHEEL_HI_RES, hi_res) < 0) {
            return -1;
        }
        while (*hwheel_accum >= 120) {
            if (emit_event(out_fd, EV_REL, REL_HWHEEL, 1) < 0) {
                return -1;
            }
            *hwheel_accum -= 120;
        }
        while (*hwheel_accum <= -120) {
            if (emit_event(out_fd, EV_REL, REL_HWHEEL, -1) < 0) {
                return -1;
            }
            *hwheel_accum += 120;
        }
        return 0;
    }

    return emit_input_event(out_fd, ev);
}

int main(int argc, char **argv)
{
    const char *input_name = argc > 1 ? argv[1] : "xremap-scroll";
    const char *output_name = argc > 2 ? argv[2] : "trackball-scroll";

    signal(SIGINT, on_signal);
    signal(SIGTERM, on_signal);

    int in_fd = open_input(input_name);
    if (in_fd < 0) {
        return 1;
    }

    int out_fd = open_uinput(output_name);
    if (out_fd < 0) {
        close(in_fd);
        return 1;
    }

    bool side_down = false;
    int wheel_accum = 0;
    int hwheel_accum = 0;

    while (running) {
        struct pollfd pfd = { .fd = in_fd, .events = POLLIN };
        int ready = poll(&pfd, 1, 500);
        if (ready < 0) {
            if (errno == EINTR) {
                continue;
            }
            fprintf(stderr, "poll failed: %s\n", strerror(errno));
            break;
        }
        if (ready == 0) {
            continue;
        }

        struct input_event ev;
        ssize_t bytes;
        while ((bytes = read(in_fd, &ev, sizeof(ev))) == (ssize_t)sizeof(ev)) {
            if (ev.type == EV_KEY && ev.code == BTN_SIDE) {
                side_down = ev.value != 0;
                continue;
            }

            if (side_down && ev.type == EV_REL && (ev.code == REL_X || ev.code == REL_Y)) {
                if (handle_rel_scroll(out_fd, &ev, &wheel_accum, &hwheel_accum) < 0) {
                    running = 0;
                    break;
                }
                continue;
            }

            if (emit_input_event(out_fd, &ev) < 0) {
                running = 0;
                break;
            }
        }

        if (bytes < 0 && errno != EAGAIN && errno != EWOULDBLOCK) {
            fprintf(stderr, "read failed: %s\n", strerror(errno));
            break;
        }
    }

    ioctl(in_fd, EVIOCGRAB, 0);
    ioctl(out_fd, UI_DEV_DESTROY);
    close(out_fd);
    close(in_fd);
    return 0;
}
