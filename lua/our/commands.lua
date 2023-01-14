vim.api.nvim_create_user_command('EchoFoo', function() 
  vim.pretty_print 'foo' 
end, { desc = 'Echo foo' })
