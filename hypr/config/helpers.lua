local M = {}

local seen_binds = {}
local written_debug_files = {}

function M.combine_keys(...)
    local parts = {}
    for i = 1, select("#", ...) do
        local part = tostring(select(i, ...))
        parts[i] = part
    end
    return table.concat(parts, " + ")
end

---@param config_dir string
---@return HyprColors
function M.load_colors(config_dir)
    local ok, colors = pcall(dofile, config_dir .. "colors.lua")
    if ok and type(colors) == "table" then
        return colors
    end

    ok, colors = pcall(dofile, config_dir .. "colors-default.lua")
    if ok and type(colors) == "table" then
        return colors
    end

    error("failed to load " .. config_dir .. "colors-default.lua")
end

local function get_bind_conflicts_path(ctx)
    return ctx.dirs.hypr .. "bind-conflicts.log"
end

local function append_bind_conflict(ctx, key, first_source, source)
    local path = get_bind_conflicts_path(ctx)
    local mode = written_debug_files[path] and "a" or "w"
    local file = io.open(path, mode)
    if not file then
        return
    end

    written_debug_files[path] = true
    file:write(key, "\n")
    file:write("  first: ", first_source, "\n")
    file:write("  again: ", source, "\n\n")
    file:close()
end

function M.debug_bind(ctx, source, scope)
    return function(key, ...)
        local debug_key = M.combine_keys(scope or "global", key)
        local first_source = seen_binds[debug_key]
        if first_source then
            append_bind_conflict(ctx, key, first_source, source)
        else
            seen_binds[debug_key] = source
        end

        return hl.bind(key, ...)
    end
end

---@alias Layout
---| "hy3"
---| "dwindle"
---| "scrolling"
---| "default"
---@param bind_table table<Layout, string>
function M.layout_bind(bind_table)
    return function ()
        local workspace = hl.get_active_special_workspace() or
                          hl.get_active_workspace()

        if not workspace then
            return
        end

        local layout = workspace.tiled_layout

        local cmd = bind_table[layout] or bind_table[layout]
        if cmd then
            hl.dispatch(cmd)
        end
    end
end

return M
