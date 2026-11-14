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

      -- 统一入口：打开后补上 Ctrl-C 关闭 + 快捷键提示
      _G.CustomPicker = function(name)
        vim.cmd('Picker ' .. name)
        vim.schedule(function()
          local buf = vim.api.nvim_get_current_buf()
          if vim.bo[buf].filetype == 'picker-prompt' then
            vim.keymap.set('i', '<C-c>', '<Esc>', { buffer = buf, remap = true })
            -- 上下方向键：映射到 picker 自己的 Tab / S-Tab
            vim.keymap.set('i', '<Down>', '<Tab>', { buffer = buf, remap = true })
            vim.keymap.set('i', '<Up>', '<S-Tab>', { buffer = buf, remap = true })
            -- Ctrl-j / Ctrl-k 当上下选择用（j/k 本身要留给模糊搜索输入）
            vim.keymap.set('i', '<C-j>', '<Tab>', { buffer = buf, remap = true })
            vim.keymap.set('i', '<C-k>', '<S-Tab>', { buffer = buf, remap = true })
            vim.api.nvim_echo({
              { '  Esc / Ctrl-C 关闭   ', 'Comment' },
              { 'Enter 打开   ', 'Comment' },
              { 'Tab / Shift-Tab / Ctrl-j / Ctrl-k 选择   ', 'Comment' },
              { 'Ctrl-P 预览', 'Comment' },
            }, false, {})
          end
        end)
      end
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
