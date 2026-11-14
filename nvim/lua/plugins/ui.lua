-- 界面：配色、状态栏、标签栏、启动页、文件树、滚动条、通知
return {
  -- 配色：Catppuccin Mocha（与 tmux 状态栏、Windows Terminal 一致）
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000,
    config = function()
      require('catppuccin').setup({
        flavour = 'mocha',
        transparent_background = false,
        integrations = {
          nvimtree = true,
          dashboard = true,
          bufferline = true,
          treesitter = true,
          gitsigns = true,
          lsp_trouble = false,
          native_lsp = { enabled = true },
        },
      })
      vim.cmd.colorscheme('catppuccin')

      -- 侧边栏 / 状态栏背景跟随编辑区，整屏只有一个底色
      local function unify_bg()
        local bg = vim.api.nvim_get_hl(0, { name = 'Normal' }).bg
        for _, g in ipairs({
          'NvimTreeNormal', 'NvimTreeNormalNC', 'NvimTreeEndOfBuffer',
          'StatusLine', 'StatusLineNC', 'DashboardNormal',
        }) do
          local hl = vim.api.nvim_get_hl(0, { name = g })
          vim.api.nvim_set_hl(0, g, { bg = bg, fg = hl.fg })
        end
        vim.api.nvim_set_hl(0, 'NvimTreeWinSeparator', { bg = bg, fg = '#45475a' })
      end
      vim.api.nvim_create_autocmd('ColorScheme', { callback = unify_bg, desc = '统一侧边栏背景' })
      unify_bg()
    end,
  },
  { 'nvim-tree/nvim-web-devicons', lazy = true },

  -- 左侧文件树
  {
    'nvim-tree/nvim-tree.lua',
    cmd = { 'NvimTreeToggle', 'NvimTreeFindFile', 'NvimTreeOpen' },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      view = { width = 30 },
      renderer = {
        group_empty = true,
        highlight_git = true,
        root_folder_label = false,
        indent_markers = { enable = true, inline_arrows = true },
        icons = {
          show = { file = true, folder = true, folder_arrow = true, git = true },
          glyphs = {
            git = {
              unstaged = '✗', staged = '✓', unmerged = '', renamed = '➜',
              untracked = '★', deleted = '✖', ignored = '◌',
            },
          },
        },
      },
      update_focused_file = { enable = true, update_root = false },
      filters = { dotfiles = true, git_ignored = true },
      git = { enable = true, ignore = true },
      actions = { open_file = { quit_on_open = false } },
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
        theme = 'auto', -- 实际主题在下面的 config 里用 catppuccin 的调色板覆盖
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
    config = function(_, opts)
      -- 官方 catppuccin 调色板生成 lualine 主题，保证和编辑器一个色系
      opts.options.theme = require('catppuccin.utils.lualine')()
      require('lualine').setup(opts)
    end,
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
  -- 快捷键提示：按 <Space> 停顿一下自动弹菜单，<Space>? 手动打开完整列表
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
      local wk = require('which-key')
      wk.setup({
        preset = "classic",
        delay = 400,
        win = {
          border = 'rounded',
          padding = { 0, 1 },
          width = { min = 48, max = 92 },
        },
        layout = { spacing = 4, align = 'center' },
        icons = {
          breadcrumb = '»',
          separator = '→',
          group = '▸',
          mappings = false, -- 不显示每个按键的插件图标，只保留文字说明
          keys = { CR = 'Enter ', Esc = 'Esc ', BS = 'Bksp ', Tab = 'Tab ' },
        },
      })
      wk.add({
        { '<leader>?', function() wk.show({ global = false }) end, desc = '显示所有快捷键' },
        { '<leader>f', group = '查找' },
        { '<leader>g', group = 'Git' },
        { '<leader>s', group = '分屏' },
        { '<leader>l', group = '代码 / 运行' },
        { '<leader>t', group = '工具' },
        { '<leader>r', group = '重载' },
      })
    end,
  },
  -- SpaceVim 的键位引导插件（保留，按前缀触发老式指南）
  { 'wsdjeg/keymap-guide.nvim', event = 'VeryLazy' },
}
