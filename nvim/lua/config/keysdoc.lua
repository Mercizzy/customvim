-- :Keys —— 按「功能 / 插件」分组的快捷键总览
-- 这里只列真实存在的映射；分组标题里写清楚是哪一层提供的。
local M = {}

local SECTIONS = {
  {
    title = '基础操作 · Neovim 自带',
    rows = {
      { 'Space w', '保存当前文件' },
      { 'Space q', '关闭当前窗口' },
      { 'Space Q', '强制退出 Neovim（不保存）' },
      { 'Space rc', '重新加载配置' },
      { 'Space sv', '垂直分屏' },
      { 'Space sh', '水平分屏' },
      { 'Alt-h/j/k/l', '在 Neovim 窗口之间移动（跨到 tmux 面板用 Ctrl-h/j/k/l）' },
      { 'Ctrl-w h/j/k/l', '原生窗口切换（等价于上面的 Alt 方向）' },
      { '/ ?', '向下 / 向上搜索；n / N 跳下一个 / 上一个' },
      { ':q  :wq  ZZ', '退出 / 保存退出 / 保存退出' },
    },
  },
  {
    title = '缓冲区（buffer） · bufferline / bufdel',
    rows = {
      { '', 'buffer = Neovim 在内存里打开的一份文件。顶部每个标签就是一个 buffer；' },
      { '', '关掉窗口不等于关掉 buffer，用 Space fb 或数字键可以切回来。' },
      { 'Space 1…9', '跳到第 N 个标签（buffer）' },
      { 'Space fb', '列出所有 buffer，可搜索' },
      { 'Space bd', '关闭当前 buffer（文件还在磁盘上，只是不再占用标签）' },
    },
  },
  {
    title = '文件树 · nvim-tree',
    rows = {
      { 'Ctrl-b', '打开 / 关闭文件树（唯一的开关）' },
      { 'Space o', '在树里定位并展开当前文件' },
      { '', '树里常用键：a 新建  d 删除  r 重命名  x 剪切  c 复制  p 粘贴' },
      { '', '             y 复制文件名  g? 帮助  q 关闭树' },
    },
  },
  {
    title = '搜索 · picker / flygrep / mru',
    rows = {
      { 'Space ff', '找文件（Picker files）' },
      { 'Space fb', '切 buffer' },
      { 'Space fr', '最近打开的文件' },
      { 'Space fg', '全项目搜索（FlyGrep，输入即搜）' },
      { '', 'Picker 弹窗里：打字过滤  ↓/Tab 下一项  ↑/Shift-Tab 上一项' },
      { '', '                Enter 打开  Esc/Ctrl-C 关闭  Ctrl-P 预览' },
      { ':grep 词', 'ripgrep 搜全项目，结果进 quickfix，:cnext / :cprev 跳' },
    },
  },
  {
    title = 'Git · git.nvim + gitsigns',
    rows = {
      { 'Space gs', ':Git status' },
      { 'Space gc', ':Git commit' },
      { 'Space gp', ':Git push' },
      { 'Space gP', ':Git pull' },
      { 'Space gd', ':Git diff' },
      { 'Space gl', ':Git log' },
      { 'Space gb', ':Git blame' },
      { ']c / [c', '跳到下一个 / 上一个改动块' },
      { 'Space hp', '预览当前改动（gitsigns）' },
      { 'Space hr', '撤销当前改动（gitsigns）' },
    },
  },
  {
    title = '代码智能 · 内置 LSP + 补全',
    rows = {
      { 'gd / gD', '跳转定义 / 声明' },
      { 'gr / gI', '查找引用 / 跳转实现' },
      { 'K / Ctrl-k', '悬浮文档 / 函数签名' },
      { 'Space rn', '重命名符号（跨文件）' },
      { 'Space ca', '代码操作（自动导入、快速修复）' },
      { 'Space d', '查看当前行诊断' },
      { ']d / [d', '下一个 / 上一个诊断' },
      { '', '插入模式里 Ctrl-n / Ctrl-p 选择补全项' },
    },
  },
  {
    title = '运行与工具 · format / code-runner / terminal',
    rows = {
      { 'Space lf', '格式化当前文件（stylua / black 等）' },
      { 'Space lr', '运行当前文件' },
      { 'Space tt', '打开浮动终端' },
      { ':Todo', '列出 TODO / FIXME 注释' },
      { ':Bookmarks', '书签列表' },
      { ':Scratch', '临时便签 buffer' },
    },
  },
  {
    title = 'tmux 协作（这些是 tmux 的键，不是 Neovim 的）',
    rows = {
      { 'Ctrl-a', 'tmux 前缀键' },
      { 'Ctrl-a ?', '快捷键速查弹窗' },
      { 'Ctrl-a f', '会话 / 项目选择器（sessionx）' },
      { 'Ctrl-h/j/k/l', '在 Neovim 窗口和 tmux 面板之间直接移动' },
    },
  },
}

local function pad(str, width)
  local w = vim.fn.strdisplaywidth(str)
  return str .. string.rep(' ', math.max(0, width - w))
end

local function build()
  local out = {
    '  Neovim 快捷键总览                      q / Esc 关闭 · j / k 滚动',
    '  ' .. string.rep('─', 62),
    '',
  }
  for _, sec in ipairs(SECTIONS) do
    table.insert(out, '▌ ' .. sec.title)
    local kw = 0
    for _, r in ipairs(sec.rows) do
      kw = math.max(kw, vim.fn.strdisplaywidth(r[1]))
    end
    for _, r in ipairs(sec.rows) do
      if r[1] == '' then
        table.insert(out, '    ' .. r[2])
      else
        table.insert(out, '    ' .. pad(r[1], kw + 3) .. r[2])
      end
    end
    table.insert(out, '')
  end
  return out
end

function M.show()
  local lines = build()
  local width = math.min(100, math.max(64, math.floor(vim.o.columns * 0.8)))
  local height = math.min(#lines, math.floor(vim.o.lines * 0.85))
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = 'wipe'
  vim.bo[buf].filetype = 'keysdoc'

  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = math.max(1, math.floor((vim.o.lines - height) / 2) - 1),
    col = math.max(0, math.floor((vim.o.columns - width) / 2)),
    style = 'minimal',
    border = 'rounded',
    title = ' 快捷键总览 ',
    title_pos = 'center',
  })
  vim.wo[win].winhighlight = 'Normal:NormalFloat,FloatBorder:FloatBorder,FloatTitle:Title'
  vim.wo[win].wrap = false
  vim.wo[win].cursorline = false
  vim.wo[win].number = false
  vim.wo[win].signcolumn = 'no'

  local function close()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end
  vim.keymap.set('n', 'q', close, { buffer = buf, desc = '关闭' })
  vim.keymap.set('n', '<Esc>', close, { buffer = buf, desc = '关闭' })
end

if vim.fn.exists(':Keys') == 0 then
  vim.api.nvim_create_user_command('Keys', function()
    M.show()
  end, { desc = '快捷键总览（按插件分组）' })
end

return M
