require 'config.options'

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
  spec = {
    { import = 'plugins' },
  },
  install = { colorscheme = { 'terafox' } },
  checker = { enabled = true, notify = false },
  ui = {
    border = 'rounded',
  },
}

vim.api.nvim_create_autocmd('User', {
 pattern = 'VeryLazy',
 callback = function()
   require 'config.autocmds'
   require 'config.keymaps'
   require 'config.user_commands'
 end,
})

vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"

-- indent spacing
vim.opt.shiftwidth = 2 -- Size of indent
vim.opt.tabstop = 2 -- Number of spaces a <tab> counts for
vim.opt.expandtab = true -- Use spaces instead of tabs
