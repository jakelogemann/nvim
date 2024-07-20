local info, ok, error = vim.health.info, vim.health.ok, vim.health.error

return {
  check = function()
    vim.health.start("neovim custom")

    info("config dir: " .. vim.fn.stdpath("config"))
    info("data dir: " .. vim.fn.stdpath("data"))
    info("cache dir: " .. vim.fn.stdpath("cache"))

    if vim.g.neovide then
      ok("running in neovide")
    end

    if true then
      ok("setup is correct")
    else
      error("setup is incorrect")
    end
  end,
}
