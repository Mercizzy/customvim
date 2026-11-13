-- 搜索与项目感知：picker（模糊查找）、flygrep（全文搜索）、mru（最近文件）、rooter（自动 cd 到项目根）、altf（头文件/源文件互跳）
return {
  -- 很多插件依赖异步 job
  { 'wsdjeg/job.nvim', lazy = true },

  -- 模糊查找：:Picker files / buffers / mru ...
  {
    'wsdjeg/picker.nvim',
    event = 'VeryLazy',
    dependencies = { 'wsdjeg/job.nvim' },
    config = function()
      require('picker').setup()
    end,
  },

  -- 异步 ripgrep：:FlyGrep
  {
    'wsdjeg/flygrep.nvim',
    cmd = { 'FlyGrep' },
    dependencies = { 'wsdjeg/job.nvim' },
    config = function()
      require('flygrep').setup()
    end,
  },

  -- 历史文件
  {
    'wsdjeg/mru.nvim',
    event = 'VeryLazy',
    config = function()
      require('mru').setup()
    end,
  },

  -- 自动把工作目录切到项目根（有 .git / package.json 等标记）
  {
    'wsdjeg/rooter.nvim',
    event = 'BufReadPre',
    config = function()
      require('rooter').setup()
    end,
  },

  -- :A 在头文件与源文件之间跳转
  { 'wsdjeg/altf.nvim', event = 'VeryLazy' },
}
