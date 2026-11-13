-- 中文友好：输入法自动切换（Esc 后回英文）+ 中英文混排检查
return {
  -- 插入模式自动切中文输入法、普通模式切回英文（无需 im-select 外部工具）
  {
    'wsdjeg/smart-ime.nvim',
    event = { 'InsertEnter' },
    config = function()
      pcall(function()
        require('smart-ime').setup({})
      end)
    end,
  },

  -- 中文文档里中英文间距、标点问题检查
  {
    'wsdjeg/chineselinter.nvim',
    ft = { 'markdown', 'text', 'gitcommit' },
    config = function()
      pcall(function()
        require('chineselinter').setup()
      end)
    end,
  },
}
