-- 界面：配色、状态栏、标签栏、启动页、文件树、滚动条、通知
return {
  -- 配色（和之前 Vim 一致的 onedark）
  {
    'navarasu/onedark.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('onedark').setup({ style = 'dark' })
      require('onedark').load()
    end,
  },
  { 'nvim-tree/nvim-web-devicons', lazy = true },

  -- 左侧文件树
  {
    'nvim-tree/nvim-tree.lua',
    cmd = { 'NvimTreeToggle', 'NvimTreeFindFile', 'NvimTreeOpen' },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      view = { width = 32 },
      renderer = { group_empty = true, highlight_git = true },
      filters = { dotfiles = false },
      git = { enable = true, ignore = false },
    },
  },

  -- 启动页（wsdjeg 的 dashboard-nvim）
  {
    'wsdjeg/dashboard-nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('dashboard').setup({ theme = 'hyper' })
    end,
  },

  -- 状态栏 / 标签栏 / 滚动条 / 通知 / 按键提示
  {
    'wsdjeg/statusline.nvim',
    event = 'VimEnter',
    config = function()
      require('statusline').setup({ separator = 'arrow', iseparator = 'arrow' })
    end,
  },
  {
    'wsdjeg/tabline.nvim',
    event = 'VeryLazy',
    config = function()
      require('tabline').setup()
    end,
  },
  {
    'wsdjeg/scrollbar.nvim',
    event = 'VeryLazy',
    config = function()
      require('scrollbar').setup()
    end,
  },
  {
    'wsdjeg/notify.nvim',
    event = 'VeryLazy',
    config = function()
      require('notify').setup({})
    end,
  },
  { 'wsdjeg/keymap-guide.nvim', event = 'VeryLazy' },
}
