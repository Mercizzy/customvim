-- 自动命令：一些"小动作"的开关
local augroup = vim.api.nvim_create_augroup('CustomConfig', { clear = true })

-- 复制时短暂高亮，知道自己选中了什么
vim.api.nvim_create_autocmd('TextYankPost', {
  group = augroup,
  callback = function()
    vim.hl.on_yank({ timeout = 200 })
  end,
})

-- 无参数启动时自动打开左侧文件树（dashboard 在右侧）
vim.api.nvim_create_autocmd('VimEnter', {
  group = augroup,
  callback = function()
    if vim.fn.argc() == 0 and vim.fn.exists(':NvimTreeOpen') == 2 then
      vim.schedule(function()
        if pcall(vim.cmd, 'NvimTreeOpen') then
          pcall(vim.cmd, 'wincmd p') -- 光标留在右侧（dashboard / 编辑区）
        end
      end)
    end
  end,
})

-- 打开文件后把光标放回上次位置
vim.api.nvim_create_autocmd('BufReadPost', {
  group = augroup,
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

