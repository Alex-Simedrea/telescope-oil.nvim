local M = {}

--- Generate an entry_maker for directory entries that uses MiniIcons.get
-- opts.icon_hl    – (optional) override highlight group for icon
function M.gen_from_directory(opts)
  return function(entry)
    local full_path = entry
    local name      = vim.fn.fnamemodify(full_path, ":t")

    -- Default fallback values
    local icon      = ""
    local icon_hl   = opts.icon_hl or "Directory"

    -- If user enabled mini.icons, grab the directory icon for this name
    if _G.MiniIcons and type(_G.MiniIcons.get) == "function" then
      local info = _G.MiniIcons.get("directory", name)
      if info then
        icon    = info.icon or icon
        icon_hl = info.hl or icon_hl
      end
    end

    -- Build a display table: {icon, spacer, name}
    local display = {
      icon,
      "  ",
      name,
    }

    return {
      value          = full_path,   -- returned by actions.get_selected_entry().value
      display        = display,     -- what you see in Telescope
      ordinal        = name,        -- for filtering/sorting
      icon           = icon,        -- raw icon glyph
      icon_highlight = icon_hl,     -- highlight group
      path           = full_path,   -- full path of directory
      name           = name,        -- basename only
      is_dir         = true,        -- flag for “is directory”
    }
  end
end

return M
