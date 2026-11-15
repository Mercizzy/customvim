-- Git：git.nvim（:Git 子命令）+ gitsigns（行内 diff 标记）
return {
  {
    'wsdjeg/git.nvim',
    cmd = { 'Git' },
    config = function()
      pcall(function()
        require('git').setup()
      end)
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    event = 'BufReadPre',
    opts = {
      signs = {
        add = { text = '┃' },
        change = { text = '┃' },
        delete = { text = '▁' },
      },
    },
    config = function(_, opts)
      require('gitsigns').setup(opts)
      local map = vim.keymap.set
      map('n', ']c', function() require('gitsigns').nav_hunk('next') end, { desc = '下一个改动' })
      map('n', '[c', function() require('gitsigns').nav_hunk('prev') end, { desc = '上一个改动' })
      map('n', '<leader>hp', function() require('gitsigns').preview_hunk() end, { desc = '预览改动' })
      map('n', '<leader>hr', function() require('gitsigns').reset_hunk() end, { desc = '撤销改动' })
    end,
  },
  {
    'kdheepak/lazygit.nvim',
    cmd = { 'LazyGit', 'LazyGitConfig', 'LazyGitCurrentFile', 'LazyGitFilter', 'LazyGitFilterCurrentFile' },
    keys = {
      { '<leader>gg', '<cmd>LazyGit<cr>', desc = 'LazyGit（浮窗）' },
      { '<leader>gG', '<cmd>tabnew | terminal lazygit<cr>', desc = 'LazyGit（全屏标签）' },
    },
    config = function()
      vim.g.lazygit_floating_window_winblend = 0
      vim.g.lazygit_floating_window_scaling_factor = 0.9
      vim.g.lazygit_floating_window_border_chars = { '\u{256d}', '\u{2500}', '\u{256e}', '\u{2502}', '\u{256f}', '\u{2500}', '\u{2570}', '\u{2502}' }
    end,
  },
}
