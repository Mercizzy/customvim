-- 工具类：浮动终端、运行代码、格式化、任务、TODO、ctags
return {
  {
    'wsdjeg/terminal.nvim',
    cmd = { 'Terminal' },
    config = function()
      require('terminal').setup()
    end,
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
