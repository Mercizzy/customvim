-- 全局快捷键。leader 设为空格，和之前 Vim 的习惯保持一致。
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

local map = vim.keymap.set

-- 保存 / 退出
map('n', '<leader>w', '<cmd>w<cr>', { desc = '保存' })
map('n', '<leader>q', '<cmd>q<cr>', { desc = '退出当前窗口' })
map('n', '<leader>Q', '<cmd>qa!<cr>', { desc = '不保存全部退出' })
map('n', '<leader>rc', '<cmd>source $MYVIMRC<cr>', { desc = '重载配置' })

-- 分屏
map('n', '<leader>sv', '<cmd>vsplit<cr>', { desc = '垂直分屏' })
map('n', '<leader>sh', '<cmd>split<cr>', { desc = '水平分屏' })

-- 文件树
map('n', '<leader>e', '<cmd>NvimTreeToggle<cr>', { desc = '文件树' })
map('n', '<leader>o', '<cmd>NvimTreeFindFile<cr>', { desc = '在树中定位当前文件' })

-- 模糊搜索（picker.nvim）
map('n', '<leader>ff', '<cmd>Picker files<cr>', { desc = '找文件' })
map('n', '<leader>fb', '<cmd>Picker buffers<cr>', { desc = '切 buffer' })
map('n', '<leader>fr', '<cmd>Picker mru<cr>', { desc = '最近文件' })
map('n', '<leader>fg', '<cmd>FlyGrep<cr>', { desc = '项目内搜索' })

-- Git
map('n', '<leader>gs', '<cmd>Git status<cr>', { desc = 'git status' })
map('n', '<leader>gc', '<cmd>Git commit<cr>', { desc = 'git commit' })
map('n', '<leader>gp', '<cmd>Git push<cr>', { desc = 'git push' })
map('n', '<leader>gP', '<cmd>Git pull<cr>', { desc = 'git pull' })
map('n', '<leader>gd', '<cmd>Git diff<cr>', { desc = 'git diff' })
map('n', '<leader>gl', '<cmd>Git log<cr>', { desc = 'git log' })
map('n', '<leader>gb', '<cmd>Git blame<cr>', { desc = 'git blame' })

-- 窗口间移动（配合 tmux 的 C-h/j/k/l 时，Neovim 这边用 Alt 方向）
map('n', '<A-h>', '<cmd>wincmd h<cr>', { desc = '左窗口' })
map('n', '<A-j>', '<cmd>wincmd j<cr>', { desc = '下窗口' })
map('n', '<A-k>', '<cmd>wincmd k<cr>', { desc = '上窗口' })
map('n', '<A-l>', '<cmd>wincmd l<cr>', { desc = '右窗口' })

-- 终端
map('n', '<leader>tt', '<cmd>Terminal<cr>', { desc = '浮动终端' })

-- 格式化 / 运行
map('n', '<leader>lf', function() require('format').format() end, { desc = '格式化当前文件' })
map('n', '<leader>lr', '<cmd>RunCode<cr>', { desc = '运行当前文件' })
