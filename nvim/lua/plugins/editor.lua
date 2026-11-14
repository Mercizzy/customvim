-- 编辑增强：跳转、多光标、buffer 管理、书签、quickfix
return {
  -- hop：输入两个字符跳到屏幕任意位置，替代 f/t 的低效
  {
    'wsdjeg/hop.nvim',
    event = 'VeryLazy',
    config = function()
      require('hop').setup()
    end,
  },

  -- iedit：多光标同时编辑所有匹配
  {
    'wsdjeg/iedit.nvim',
    event = 'VeryLazy',
    config = function()
      require('iedit').setup()
    end,
  },

  -- 删除 buffer 但不打乱窗口布局
  { 'wsdjeg/bufdel.nvim', event = 'VeryLazy' },

  -- 临时便签 buffer
  {
    'wsdjeg/scratch.nvim',
    event = 'VeryLazy',
    config = function()
      require('scratch').setup()
    end,
  },

  -- 书签（可加备注，quickfix 里看）
  {
    'wsdjeg/bookmarks.nvim',
    event = 'VeryLazy',
    config = function()
      require('bookmarks').setup()
    end,
  },

  -- quickfix 美化
  { 'wsdjeg/quickfix.nvim', event = 'VeryLazy' },

  -- tmux 与 Neovim 窗口无缝切换：在 nvim 边缘窗口按 C-h/j/k/l 会切到相邻 tmux 面板
  {
    'christoomey/vim-tmux-navigator',
    event = 'VeryLazy',
    init = function()
      vim.g.tmux_navigator_no_mappings = 0
      vim.g.tmux_navigator_preserve_zoom = 1
    end,
  },
}
