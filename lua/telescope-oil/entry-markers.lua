local M = {}

--- @param opts table
---   opts.icon_hl  (string) highlight group for the icon
function M.gen_from_directory(opts)
  return function(entry)
    local full_path = entry
    local name      = vim.fn.fnamemodify(full_path, ":t")

    -- 1) pick icon + hl
    local icon, icon_hl = "", opts.icon_hl or "Directory"
    if _G.MiniIcons and type(_G.MiniIcons.get) == "function" then
      local info = _G.MiniIcons.get("directory", name)
      if info then
        icon    = info.icon or icon
        icon_hl = info.hl   or icon_hl
      end
    end

    -- 2) build chunked display: { {text, hl}, {text}, {text, hl} }
    local display = {
      { icon,    icon_hl   },
      { "  "               },
      { name,    "Normal"  },
    }

    return {
      value   = full_path,   -- returned by actions.get_selected_entry().value
      display = display,     -- your chunked text + hl
      ordinal = name,        -- used for filtering
      -- any extra metadata you like:
      path    = full_path,
      name    = name,
      is_dir  = true,
      icon    = icon,
      icon_hl = icon_hl,
    }
  end
end

return M
