-- Lightweight Go commands replacing vim-go usage
-- Provides: :GoTest, :GoTestFile, :GoTestFunc, :GoBuild, :GoInstall
local api, fn = vim.api, vim.fn

local ok_u, utils = pcall(require, "custom.utils")
local run_in_term = (ok_u and utils.run_in_term)
  or function(cmd, opts) vim.cmd((opts and opts.cwd and ("lcd " .. fn.fnameescape(opts.cwd) .. " | ") or "") .. "!" .. cmd) end

local function file_dir() return fn.expand "%:p:h" end

local function find_test_func()
  -- Find nearest 'func TestXxx(' or 'func ExampleXxx(' above cursor
  local cur = fn.line "."
  for l = cur, 1, -1 do
    local line = fn.getline(l)
    local name = line:match "^%s*func%s+(Test[%w_]+)%s*%(" or line:match "^%s*func%s+(Example[%w_]+)%s*%("
    if name then return name end
  end
  return nil
end

api.nvim_create_user_command(
  "GoTest",
  function() run_in_term("go test ./...", { cwd = file_dir() }) end,
  { desc = "Run all tests in module" }
)

api.nvim_create_user_command(
  "GoTestFile",
  function() run_in_term("go test -v .", { cwd = file_dir() }) end,
  { desc = "Run tests in current package" }
)

api.nvim_create_user_command("GoTestFunc", function()
  local name = find_test_func()
  if not name then
    vim.notify("No Test*/Example* found; running package tests", vim.log.levels.WARN)
    run_in_term("go test -v .", { cwd = file_dir() })
    return
  end
  run_in_term("go test -v -run '^" .. name .. "$' .", { cwd = file_dir() })
end, { desc = "Run nearest test function" })

api.nvim_create_user_command("GoBuild", function() run_in_term("go build ./...", { cwd = file_dir() }) end, { desc = "Build packages" })

api.nvim_create_user_command(
  "GoInstall",
  function() run_in_term("go install ./...", { cwd = file_dir() }) end,
  { desc = "Install module binaries" }
)
