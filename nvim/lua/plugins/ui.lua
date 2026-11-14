-- 界面：配色、状态栏、标签栏、启动页、文件树、滚动条、通知
return {
  -- 配色（和之前 Vim 一致的 onedark）
  {
    'navarasu/onedark.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('onedark').setup({ style = 'dark', transparent = false })
      require('onedark').load()

      -- 侧边栏/浮窗背景和编辑器保持一致，避免左右两块颜色不同产生割裂感
      local blend = function()
        local bg = vim.api.nvim_get_hl(0, { name = 'Normal' }).bg
        vim.api.nvim_set_hl(0, 'NvimTreeNormal', { bg = bg })
        vim.api.nvim_set_hl(0, 'NvimTreeNormalNC', { bg = bg })
        vim.api.nvim_set_hl(0, 'NvimTreeEndOfBuffer', { bg = bg })
        vim.api.nvim_set_hl(0, 'NvimTreeWinSeparator', { bg = bg, fg = '#3E4451' })
        vim.api.nvim_set_hl(0, 'DashboardNormal', { bg = bg })
      end
      vim.api.nvim_create_autocmd('ColorScheme', { callback = blend, desc = '侧边栏背景跟随编辑器' })
      blend()
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

  -- 状态栏 / 缓冲区标签栏（lualine + bufferline，稳定且好看）
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      options = {
        theme = 'onedark',
        globalstatus = true,
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff' },
        lualine_c = { { 'filename', path = 1 } },
        lualine_x = { 'diagnostics', 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
    },
  },
  {
    'akinsho/bufferline.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      options = {
        mode = 'buffers',
        separator_style = 'slant',
        show_buffer_close_icons = true,
        show_close_icon = false,
        always_show_bufferline = true,
      },
    },
    config = function(_, opts)
      require('bufferline').setup(opts)
      vim.opt.showtabline = 2
      for i = 1, 9 do
        vim.keymap.set('n', '<leader>' .. i, '<cmd>BufferLineGoToBuffer ' .. i .. '<cr>', { desc = '第 ' .. i .. ' 个 buffer' })
      end
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
