local M = {}

local function shell_quote(value)
    return "'" .. tostring(value):gsub("'", "'\\''") .. "'"
end

local function trim(value)
    return value:match("^%s*(.-)%s*$")
end

local function valid_name(name)
    return name:match("^[%w][%w _%.:_%-]*$") ~= nil
end

local function read_lines(path)
    local lines = {}
    local file = io.open(path, "r")
    if not file then
        return lines
    end

    for line in file:lines() do
        if line ~= "" then
            lines[#lines + 1] = line
        end
    end
    file:close()
    return lines
end

local function write_lines(path, lines)
    local tmp_path = path .. ".tmp"
    local file = io.open(tmp_path, "w")
    if not file then
        return false
    end

    for _, line in ipairs(lines) do
        file:write(line, "\n")
    end
    file:close()

    if not os.rename(tmp_path, path) then
        os.remove(tmp_path)
        return false
    end
    return true
end

local active_pickers = {}

local function choose(items, prompt, case_insensitive, callback)
    local args = { "rofi", "-dmenu", "-p", shell_quote(prompt) }
    if case_insensitive then
        table.insert(args, 3, "-i")
    end

    local quoted_items = {}
    for _, item in ipairs(items) do
        quoted_items[#quoted_items + 1] = shell_quote(item)
    end

    local input
    if #quoted_items > 0 then
        input = "printf '%s\\n' " .. table.concat(quoted_items, " ")
    else
        input = "printf '%s' ''"
    end

    local result_path = os.tmpname()
    os.remove(result_path)
    local pending_path = result_path .. ".pending"
    local command = string.format(
        "%s | %s > %s; mv -- %s %s",
        input,
        table.concat(args, " "),
        shell_quote(pending_path),
        shell_quote(pending_path),
        shell_quote(result_path)
    )

    -- A blocking io.popen would freeze Hyprland while rofi is open. Let rofi
    -- write its result asynchronously and poll for the completed file instead.
    local timer
    timer = hl.timer(function()
        local file = io.open(result_path, "r")
        if not file then
            return
        end

        local selection = file:read("*a")
        file:close()
        os.remove(result_path)
        timer:set_enabled(false)
        active_pickers[timer] = nil

        selection = selection:gsub("[\r\n]+$", "")
        callback(selection ~= "" and selection or nil)
    end, {
        timeout = 100,
        type = "repeat",
    })
    active_pickers[timer] = true
    hl.exec_cmd(command)
end

---@param ctx HyprConfigContext
function M.new(ctx)
    local state_home = os.getenv("XDG_STATE_HOME")
    if not state_home or state_home == "" then
        state_home = os.getenv("HOME") .. "/.local/state"
    end

    local state_dir = state_home .. "/hypr"
    local state_file = state_dir .. "/named-workspaces"
    local harpoon_dir = state_dir .. "/workspace-harpoons"

    local function ensure_dir(path)
        return os.execute("mkdir -p -- " .. shell_quote(path)) == true
    end

    local function notify(message)
        hl.notification.create({
            text = "Named workspaces: " .. message,
            timeout = 4000,
        })
    end

    local function save_name(name)
        local names = read_lines(state_file)
        for _, saved_name in ipairs(names) do
            if saved_name == name then
                return true
            end
        end

        if not ensure_dir(state_dir) then
            return false
        end

        local file = io.open(state_file, "a")
        if not file then
            return false
        end
        file:write(name, "\n")
        file:close()
        return true
    end

    local function workspace_names()
        local names = read_lines(state_file)
        for _, workspace in ipairs(hl.get_workspaces()) do
            if not workspace.name:match("^%d+$") then
                names[#names + 1] = workspace.name
            end
        end

        table.sort(names, function(a, b)
            return a:lower() < b:lower()
        end)

        local unique = {}
        local last_name
        for _, name in ipairs(names) do
            local normalized = name:lower()
            if normalized ~= last_name then
                unique[#unique + 1] = name
                last_name = normalized
            end
        end
        return unique
    end

    local function choose_workspace(prompt, callback)
        choose(workspace_names(), prompt, true, callback)
    end

    local function read_harpoon(slot)
        local names = read_lines(harpoon_dir .. "/" .. slot)
        return names[1]
    end

    local function write_harpoon(slot, name)
        if not ensure_dir(harpoon_dir) then
            return false
        end
        return write_lines(harpoon_dir .. "/" .. slot, { name })
    end

    local function assign_next_harpoon(name)
        for slot = 1, 4 do
            if not read_harpoon(slot) then
                if write_harpoon(slot, name) then
                    return slot
                end
                return nil
            end
        end
        return nil
    end

    local function validate_selection(name)
        if valid_name(name) then
            return true
        end
        notify("That workspace name contains unsupported characters.")
        return false
    end

    local manager = {}

    function manager.create()
        choose({}, "New workspace", false, function(name)
            if not name then
                return
            end

            name = trim(name)
            if name == "" then
                return
            end
            if not valid_name(name) then
                notify("Use letters, digits, spaces, dots, colons, underscores, or hyphens.")
                return
            end

            local already_saved = false
            for _, saved_name in ipairs(read_lines(state_file)) do
                if saved_name == name then
                    already_saved = true
                    break
                end
            end

            if not save_name(name) then
                notify("Could not save \"" .. name .. "\".")
                return
            end

            if already_saved then
                notify("\"" .. name .. "\" is already saved.")
                return
            end

            local slot = assign_next_harpoon(name)
            if slot then
                notify("Saved \"" .. name .. "\" to harpoon " .. slot .. ". Move a window there when ready.")
            else
                notify("Saved \"" .. name .. "\". All harpoon slots are occupied.")
            end
        end)
    end

    function manager.move()
        choose_workspace("Move window to", function(name)
            if not name or not validate_selection(name) then
                return
            end

            if not save_name(name) then
                notify("Could not save \"" .. name .. "\".")
                return
            end
            hl.dispatch(hl.dsp.window.move({
                workspace = "name:" .. name,
                follow = false,
            }))
        end)
    end

    function manager.go()
        choose_workspace("Go to workspace", function(name)
            if not name or not validate_selection(name) then
                return
            end

            if not save_name(name) then
                notify("Could not save \"" .. name .. "\".")
                return
            end
            hl.dispatch(hl.dsp.focus({ workspace = "name:" .. name }))
        end)
    end

    function manager.forget()
        choose_workspace("Forget saved workspace", function(name)
            if not name then
                return
            end

            local kept_names = {}
            for _, saved_name in ipairs(read_lines(state_file)) do
                if saved_name ~= name then
                    kept_names[#kept_names + 1] = saved_name
                end
            end

            if ensure_dir(state_dir) then
                write_lines(state_file, kept_names)
            end

            for slot = 1, 4 do
                if read_harpoon(slot) == name then
                    write_lines(harpoon_dir .. "/" .. slot, {})
                end
            end
        end)
    end

    function manager.set_harpoon()
        local slots = {}
        for slot = 1, 4 do
            slots[#slots + 1] = string.format("%d  %s", slot, read_harpoon(slot) or "")
        end

        choose(slots, "Harpoon slot", true, function(selection)
            local slot = selection and tonumber(selection:match("^(%d)"))
            if not slot or slot < 1 or slot > 4 then
                return
            end

            choose_workspace("Workspace for harpoon " .. slot, function(name)
                if not name or not validate_selection(name) then
                    return
                end

                if not write_harpoon(slot, name) or not save_name(name) then
                    notify("Could not save harpoon " .. slot .. ".")
                    return
                end
                notify("Harpoon " .. slot .. " set to \"" .. name .. "\".")
            end)
        end)
    end

    function manager.go_to_harpoon(slot)
        local name = read_harpoon(slot)
        if not name then
            notify("Harpoon " .. slot .. " is not set.")
            return
        end
        if not valid_name(name) then
            notify("Harpoon " .. slot .. " has an invalid workspace name.")
            return
        end

        hl.dispatch(hl.dsp.focus({ workspace = "name:" .. name }))
    end

    function manager.move_to_harpoon(slot)
        local name = read_harpoon(slot)
        if not name then
            notify("Harpoon " .. slot .. " is not set.")
            return
        end
        if not valid_name(name) then
            notify("Harpoon " .. slot .. " has an invalid workspace name.")
            return
        end

        if ctx.plugins.hy3 then
            hl.dispatch(ctx.plugins.hy3.move_to_workspace("name:" .. name))
        else
            hl.dispatch(hl.dsp.window.move({ workspace = "name:" .. name }))
        end
    end

    function manager.menu()
        local actions = {
            ["Create workspace"] = manager.create,
            ["Move active window"] = manager.move,
            ["Go to workspace"] = manager.go,
            ["Forget saved workspace"] = manager.forget,
            ["Set workspace harpoon"] = manager.set_harpoon,
        }
        local names = {
            "Create workspace",
            "Move active window",
            "Go to workspace",
            "Forget saved workspace",
            "Set workspace harpoon",
        }

        choose(names, "Workspaces", true, function(selection)
            local action = actions[selection]
            if action then
                action()
            end
        end)
    end

    return manager
end

return M
