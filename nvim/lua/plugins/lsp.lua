-- LSP：mason 负责装 server，nvim-lspconfig 负责启动，blink.cmp 负责补全
return {
  {
    'williamboman/mason.nvim',
    cmd = 'Mason',
    opts = {
      ui = { border = 'rounded' },
    },
  },

  -- 按需自动安装 LSP / 工具（装到 ~/.local/share/nvim/mason，不需要 root）
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    opts = {
      ensure_installed = {
        'lua-language-server',
        'pyright',
        'typescript-language-server',
        'clangd',
        'bash-language-server',
        'vscode-langservers-extracted', -- json / css / html
        'yaml-language-server',
        'stylua', -- lua 格式化
      },
      run_on_start = false, -- 用 :MasonToolsInstall 手动装，避免首次启动卡在下载
    },
  },

  -- 补全：用 Neovim 0.12 内置的 LSP 补全（不依赖 blink.cmp/原生库，离线可用）
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
      for _, server in ipairs({ 'lua_ls', 'pyright', 'ts_ls', 'clangd', 'bashls', 'jsonls', 'cssls', 'html', 'yamlls' }) do
        pcall(vim.lsp.enable, server)
      end

      vim.diagnostic.config({
        virtual_text = true,
        severity_sort = true,
        float = { border = 'rounded' },
      })

      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = args.buf, desc = desc })
          end
          map('n', 'gd', vim.lsp.buf.definition, '跳转定义')
          map('n', 'gD', vim.lsp.buf.declaration, '跳转声明')
          map('n', 'gr', vim.lsp.buf.references, '查找引用')
          map('n', 'gI', vim.lsp.buf.implementation, '跳转实现')
          map('n', 'K', vim.lsp.buf.hover, '悬停文档')
          map('n', '<C-k>', vim.lsp.buf.signature_help, '函数签名')
          map('n', '<leader>rn', vim.lsp.buf.rename, '重命名符号')
          map('n', '<leader>ca', vim.lsp.buf.code_action, '代码操作')
          map('n', '<leader>d', vim.diagnostic.open_float, '查看诊断')
          map('n', '[d', function() vim.diagnostic.jump({ count = -1 }) end, '上一个诊断')
          map('n', ']d', function() vim.diagnostic.jump({ count = 1 }) end, '下一个诊断')

          -- 打开当前 buffer 的 LSP 补全（内置，无需额外插件）
          vim.lsp.completion.enable(true, args.data.client_id, args.buf, { autotrigger = true })
        end,
      })
    end,
  },
  -- 补全：Neovim 0.12 内置 LSP 补全，在 LspAttach 里按 buffer 开启
}
