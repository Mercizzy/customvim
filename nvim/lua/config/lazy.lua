-- 插件管理器：lazy.nvim
-- 第一次启动会自动把 lazy.nvim 本身下载到 ~/.local/share/nvim/lazy/
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({
    'git', 'clone', '--filter=blob:none', '--branch=stable',
    'https://github.com/folke/lazy.nvim.git', lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'lazy.nvim 下载失败：\n' .. out, 'ErrorMsg' },
    }, true, {})
    return
  end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  spec = {
    { import = 'plugins' },   -- lua/plugins/ 下的每个文件就是一类插件
  },
  install = { colorscheme = { 'catppuccin', 'habamax' } },
  checker = { enabled = false },          -- 不自动检查更新，避免启动卡网络
  change_detection = { notify = false },  -- 改配置后不弹提示
  ui = { border = 'rounded' },
  performance = {
    rtp = {
      disabled_plugins = { 'gzip', 'tarPlugin', 'tohtml', 'tutor', 'zipPlugin' },
    },
  },
})
