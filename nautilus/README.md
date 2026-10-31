# Nautilus file chooser

From the dotfiles directory, run:

```fish
fish nautilus/setup.fish
```

Requires Nautilus 47 or newer, xdg-desktop-portal 1.20 or newer (for user
portal definitions), xdg-desktop-portal-hyprland, and xdg-desktop-portal-gtk.
On Fedora:

```fish
sudo dnf install nautilus xdg-desktop-portal xdg-desktop-portal-hyprland xdg-desktop-portal-gtk
```

The script links `hyprland-portals.conf` into
`$XDG_CONFIG_HOME/xdg-desktop-portal/` and `nautilus.portal` into
`$XDG_DATA_HOME/xdg-desktop-portal/portals/`. These default to `~/.config`
and `~/.local/share`. It sets Nautilus as the default folder opener with
`xdg-mime` and restarts the user desktop portal. Run it when no file dialog
or screen-sharing session is open. Existing configuration files are never
overwritten; move conflicting files aside before running it again.

Only the FileChooser interface uses Nautilus. Hyprland and GTK retain the
other portal interfaces. The descriptor connects directly to Nautilus over
D-Bus because xdg-desktop-portal-gnome requires a compatible display server
and can expose only Settings under Hyprland. Nautilus starts on demand.

This applies to file/folder selection and save dialogs in applications that
use the desktop portal. Restart applications after setup. If Firefox still
uses its GTK dialog, set `widget.use-xdg-desktop-portal.file-picker` to `1`
in `about:config`. Applications with their own built-in chooser cannot be
switched globally.

References: [portal configuration](https://flatpak.github.io/xdg-desktop-portal/docs/configuration-file.html),
[user portal definitions](https://github.com/flatpak/xdg-desktop-portal/pull/1665),
[GNOME file chooser delegation](https://github.com/GNOME/xdg-desktop-portal-gnome/blob/main/src/filechooser.c).
