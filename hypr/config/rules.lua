---@type fun(ctx: HyprConfigContext): nil
local function run(ctx)
    hl.workspace_rule({ workspace = "1", monitor = ctx.monitors.secondary })
    hl.workspace_rule({ workspace = "2", monitor = ctx.monitors.secondary })
    hl.workspace_rule({ workspace = "3", monitor = ctx.monitors.secondary })
    hl.workspace_rule({ workspace = "4", monitor = ctx.monitors.secondary })
    hl.workspace_rule({ workspace = "5", monitor = ctx.monitors.secondary })
    hl.workspace_rule({ workspace = "6", monitor = ctx.monitors.primary })
    hl.workspace_rule({ workspace = "7", monitor = ctx.monitors.primary })
    hl.workspace_rule({ workspace = "8", monitor = ctx.monitors.primary })
    hl.workspace_rule({ workspace = "9", monitor = ctx.monitors.primary })
    hl.workspace_rule({ workspace = "10", monitor = ctx.monitors.primary })


    hl.window_rule({ match = { workspace = "w[tv1]" }, border_size = 0 })


    -- 1 (IDEs)
    hl.window_rule({ match = { class = "^(jetbrains-.*)$" }, workspace = "1 silent" })
    hl.window_rule({ match = { class = "^(cursor)$" }, workspace = "1 silent" })
    -- 2 (browsing)
    hl.window_rule({ match = { class = "^([Ff]irefox|org.mozilla.firefox|[Ff]irefox-esr)$" }, workspace = "2 silent" })
    -- 3 (duplicated purposes)
    -- 4 (hobbies)
    hl.window_rule({ match = { class = "^(krita)$" }, workspace = "4 silent" })
    hl.window_rule({ match = { class = "^(com.github.xournalpp.xournalpp)$" }, workspace = "4 silent" })
    hl.window_rule({ match = { class = "^(steam)$" }, workspace = "4 silent" })
    hl.window_rule({ match = { class = "^(steam_app_.*)$" }, workspace = "4 silent" })
    -- 5 (general tools)
    hl.window_rule({ match = { class = "^(chrome-www.desmos.com__scientific-Default)$" }, workspace = "5 silent" })
    hl.window_rule({ match = { class = "^(chrome-translate.google.com__-Default)$" }, workspace = "5 silent" })
    hl.window_rule({ match = { class = "^(DBeaver)$" }, workspace = "5 silent" })
    -- 6 (stuff)
    -- 7 (productivity tools)
    hl.window_rule({ match = { class = "^(obsidian)$" }, workspace = "7 silent" })
    hl.window_rule({ match = { class = "^(chrome-calendar.google.com__-Default)$" }, workspace = "7 silent" })
    hl.window_rule({ match = { class = "^(chrome-kjbdgfilnfhdoflbpgamdcdgpehopbep-Default)$" }, workspace = "7 silent" })
    hl.window_rule({ match = { class = "^(chrome-glhjejmflhdjpaimbkdnhfpbbgdgjkoh-Default)$" }, workspace = "7 silent" })
    -- 8 (media)
    hl.window_rule({ match = { class = "^(com.obsproject.Studio)$" }, workspace = "8 silent" })
    -- 9 (music & secondary browser)
    hl.window_rule({ match = { class = "^(chrome-cinhimbnkkaeohfgghhklpknlkffjgod-Default)$" }, workspace = "9 silent" })
    hl.window_rule({ match = { class = "^(google-chrome)$" }, workspace = "9 silent" })
    -- 10 (social)
    hl.window_rule({ match = { class = "^(org.telegram.desktop)$" }, workspace = "10 silent" })
    hl.window_rule({ match = { class = "^(chrome-mdpkiolbdkhdjpekfbkbmhigcaggjagi-Default)$" }, workspace = "10 silent" })
    hl.window_rule({ match = { class = "^(Slack)$" }, workspace = "10 silent" })

    -- Special:misc
    hl.window_rule({ match = { class = "^(org.pulseaudio.pavucontrol)$" }, workspace = "special:misc silent" })
    hl.window_rule({ match = { class = "^(huiontablet)$" }, workspace = "special:misc silent" })
    hl.window_rule({ match = { class = "^(jetbrains-toolbox)$" }, workspace = "special:misc silent" })
    hl.window_rule({ match = { class = "^(Zoho Mail - Desktop)$" }, workspace = "special:misc silent" })


    hl.window_rule({
        name = "Hide window from sharing",
        match = { tag = ctx.tags.no_screen_share },
        no_screen_share = true,
        border_color = "rgb(ff0000) rgb(ff0000)",
    })
end

local M = {
    run = run,
}
return M
