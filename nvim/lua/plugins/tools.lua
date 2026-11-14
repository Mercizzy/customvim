-- 工具类：浮动终端、运行代码、格式化、任务、TODO、ctags
return {
  {
    -- 浮动/分屏终端：:ToggleTerm；Space t t 浮动，Space t h 下方，Space t v 右侧
    'akinsho/toggleterm.nvim',
    version = '*',
    keys = {
      { '<leader>tt', '<cmd>ToggleTerm<cr>', desc = '终端（浮动）' },
      { '<leader>th', '<cmd>ToggleTerm direction=horizontal size=15<cr>', desc = '终端（下方）' },
      { '<leader>tv', '<cmd>ToggleTerm direction=vertical size=60<cr>', desc = '终端（右侧）' },
    },
    opts = {
      size = 20,
      open_mapping = false, -- 不占用 <C-\>
      direction = 'float',
      start_in_insert = true,
      persist_size = true,
      persist_mode = true,
      shade_terminals = false, -- 不压暗背景，和 Catppuccin 保持一致
      float_opts = { border = 'rounded', winblend = 0 },
    },
  },
  {
    'wsdjeg/code-runner.nvim',
    cmd = { 'RunCode' },
    config = function()
      require('code-runner').setup({})
    end,
  },
  {
    'wsdjeg/format.nvim',
    event = 'VeryLazy',
    config = function()
      require('format').setup({})
    end,
  },
  {
    'wsdjeg/todo.nvim',
    event = 'VeryLazy',
    config = function()
      require('todo').setup()
    end,
  },
  {
    'wsdjeg/ctags.nvim',
    event = 'VeryLazy',
    config = function()
      pcall(function()
        require('ctags').setup()
      end)
    end,
  },
}
