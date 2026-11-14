-- ============================================================================
-- init.lua —— 整个 Neovim 配置的入口
-- 只做三件事：基础设置 → 键位 → 加载插件。具体功能都在 lua/ 下分文件。
--
--   lua/config/options.lua    编辑器基础选项
--   lua/config/keymaps.lua    全局快捷键
--   lua/config/autocmds.lua   自动命令（保存、yank 高亮等）
--   lua/config/lazy.lua       插件管理器 lazy.nvim 的引导
--   lua/plugins/*.lua         每类功能一个文件，一眼看清哪个文件管什么
-- ============================================================================

require('config.options')
require('config.keymaps')
require('config.autocmds')
require('config.lazy')

-- :Keys 快捷键总览（按插件分组），首次调用时才渲染窗口
vim.api.nvim_create_user_command('Keys', function()
  require('config.keysdoc').show()
end, { desc = '快捷键总览' })
