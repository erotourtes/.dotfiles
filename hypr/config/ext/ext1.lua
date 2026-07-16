---@type fun(ctx: HyprConfigContext): nil
local function run(ctx)
    hl.env("SSH_AUTH_SOCK", "/run/user/1000/keyring/ssh")
    hl.env("_JAVA_AWT_WM_NONREPARENTING", "1")

    hl.on("hyprland.start", function()
        hl.exec_cmd("gnome-keyring-daemon --start --components=secrets,ssh")
        hl.exec_cmd("slack")
        hl.exec_cmd("google-chrome-stable")
        hl.exec_cmd("/opt/google/chrome/google-chrome --profile-directory=Default --app-id=mdpkiolbdkhdjpekfbkbmhigcaggjagi")
        hl.exec_cmd("/opt/google/chrome/google-chrome --profile-directory=Default --app-id=kjbdgfilnfhdoflbpgamdcdgpehopbep")
        hl.exec_cmd(ctx.terminal .. " fish -c \"~/Documents/work/wingtra/scripts/tmux.fish\"")
    end)


    hl.window_rule({ match = { class = "^scrcpy$" }, workspace = "5 silent" })
end

local M = {
    run = run,
}
return M
