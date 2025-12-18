-- lua/custom/keymap_overlap.lua
-- Simple overlap checker for keymaps: reports when one mapping's lhs is a prefix of others.

local M = {}

local function collect_maps(mode)
  local maps = {}
  local list = vim.api.nvim_get_keymap(mode)
  for _, m in ipairs(list) do
    -- Only consider user/plugin maps (skip empty lhs)
    if m.lhs and #m.lhs > 0 then
      table.insert(maps, { lhs = m.lhs, desc = m.desc or m.rhs or "" })
    end
  end
  -- also include buffer-local maps for current buffer (if any)
  local ok, bufmaps = pcall(vim.api.nvim_buf_get_keymap, 0, mode)
  if ok then
    for _, m in ipairs(bufmaps) do
      if m.lhs and #m.lhs > 0 then
        table.insert(maps, { lhs = m.lhs, desc = m.desc or m.rhs or "" })
      end
    end
  end
  return maps
end

local function find_overlaps(maps)
  -- Build quick lookup
  table.sort(maps, function(a, b) return a.lhs < b.lhs end)
  local overlaps = {}
  for i = 1, #maps do
    local a = maps[i]
    for j = 1, #maps do
      if i ~= j then
        local b = maps[j]
        if #b.lhs > #a.lhs and vim.startswith(b.lhs, a.lhs) then
          overlaps[a.lhs] = overlaps[a.lhs] or { base = a, conflicts = {} }
          table.insert(overlaps[a.lhs].conflicts, b)
        end
      end
    end
  end
  return overlaps
end

local function fmt_lhs(lhs)
  if lhs:sub(1, 1) == " " then
    -- show leading space (leader) explicitly
    return "<Space>" .. lhs:sub(2)
  end
  return lhs
end

local function print_section(title)
  print(title)
end

function M.run()
  local modes = {
    n = "normal",
    v = "visual",
    x = "visual-select",
    i = "insert",
    o = "operator",
    t = "terminal",
  }
  print("checking for overlapping keymaps ~")
  local any = false
  for mode, _ in pairs(modes) do
    local maps = collect_maps(mode)
    local overlaps = find_overlaps(maps)
    for base, data in pairs(overlaps) do
      any = true
      local conflict_keys = {}
      for _, m in ipairs(data.conflicts) do
        table.insert(conflict_keys, string.format("<%s>", fmt_lhs(m.lhs)))
      end
      print(string.format("- ⚠️ WARNING In mode `%s`, <%s> overlaps with %s:", mode, fmt_lhs(base), table.concat(conflict_keys, ", ")))
      -- base line
      local desc_base = data.base.desc ~= "" and (": " .. data.base.desc) or ""
      print(string.format("  - <%s>%s", fmt_lhs(base), desc_base))
      for _, m in ipairs(data.conflicts) do
        local desc = m.desc ~= "" and (": " .. m.desc) or ""
        print(string.format("  - <%s>%s", fmt_lhs(m.lhs), desc))
      end
    end
  end
  if not any then
    print("- ✅ No overlapping keymap prefixes detected.")
  else
    print("- ✅ OK Overlapping keymaps are only reported for informational purposes.")
    print("  This doesn't necessarily mean there is a problem with your config.")
  end
end

return M
