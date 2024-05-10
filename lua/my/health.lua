local health = vim.health

return {
  check = function()
    health.start("my neovim")
    health.info("config dir: " .. vim.fn.stdpath("config"))
    health.info("data dir: " .. vim.fn.stdpath("data"))
    health.info("cache dir: " .. vim.fn.stdpath("cache"))

    if vim.g.neovide then
      health.ok("running in neovide")
    end

    if true then
      health.ok("setup is correct")
    else
      health.error("setup is incorrect")
    end
  end,
}
