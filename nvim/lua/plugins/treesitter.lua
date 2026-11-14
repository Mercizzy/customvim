-- 语法树高亮（treesitter main 分支，需要 tree-sitter CLI）
return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      local ok, ts = pcall(require, 'nvim-treesitter')
      if not ok then
        return
      end

      local parsers = {
        'lua', 'vim', 'vimdoc', 'query',
        'python', 'javascript', 'typescript', 'tsx',
        'c', 'cpp', 'bash', 'json', 'yaml', 'toml',
        'markdown', 'markdown_inline', 'html', 'css', 'diff', 'gitcommit',
      }

      -- 首次启动时装，装过的会跳过
      pcall(ts.install, parsers)

      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })
    end,
  },
}
