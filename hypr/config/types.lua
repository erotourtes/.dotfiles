---@meta

---@class HyprColors
---@field accent string
---@field accent_alt string
---@field bg string
---@field fg string

---@class HyprConfigContext
---@field terminal string
---@field file_manager string
---@field menu string
---@field colors HyprColors
---@field dirs { hypr: string, config: string, scripts: string }
---@field plugins { hy3?: HL.PluginNamespace.hy3 }
---@field monitors { primary: string, secondary: string }
---@field tags { no_screen_share: string }
---@field keys { mod: string }
