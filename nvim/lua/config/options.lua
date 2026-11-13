-- 编辑器基础选项（相当于 Vim 里的 set / 一堆 set）
local opt = vim.opt

-- 行号与光标
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = 'yes'
opt.scrolloff = 8
opt.sidescrolloff = 8

-- 颜色：必须开，否则很多插件配色失效
opt.termguicolors = true
opt.background = 'dark'

-- 缩进：4 空格，前端/脚本通用；Go 等由 ftplugin 自己覆盖
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true

-- 搜索
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- 分屏习惯
opt.splitright = true
opt.splitbelow = true

-- 保存 / 撤销
opt.undofile = true
opt.swapfile = false
opt.backup = false
opt.updatetime = 300
opt.timeoutlen = 400

-- 鼠标、真彩、系统剪贴板
opt.mouse = 'a'
opt.clipboard = 'unnamedplus'

-- WSL 下用 win32yank 打通 Windows 剪贴板（没装就退化，不报错）
if vim.fn.executable('win32yank.exe') == 1 then
  vim.g.clipboard = {
    name = 'win32yank',
    copy = {
      ['+'] = { 'win32yank.exe', '-i', '--crlf' },
      ['*'] = { 'win32yank.exe', '-i', '--crlf' },
    },
    paste = {
      ['+'] = { 'win32yank.exe', '-o', '--crlf' },
      ['*'] = { 'win32yank.exe', '-o', '--crlf' },
    },
    cache_enabled = 0,
  }
end

-- 关闭内置的 netrw 文件浏览（用 nvim-tree 替代）
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
