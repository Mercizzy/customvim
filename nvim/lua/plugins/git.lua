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
}
