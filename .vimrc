" =============================================================================
"  .vimrc —— 经典 Vim 9 开发环境
"  设计目标：在 tmux 中同时开多个项目，配置完全可读、可改、可进 git
"  阅读顺序：基础 → 显示 → 编辑 → 搜索 → 文件 → 快捷键 → 插件 → LSP → 自动化
"  维护方式：改完执行 :source $MYVIMRC，或按 <leader>rc 重载
" =============================================================================

" -----------------------------------------------------------------------------
" 0. 基础环境
" -----------------------------------------------------------------------------
set nocompatible
scriptencoding utf-8
set encoding=utf-8
set fileencoding=utf-8
" 兼容 Windows 存过来的 GBK 文件（中文项目常见）
set fileencodings=ucs-bom,utf-8,gb18030,gbk,latin1

" leader 必须在插件加载前定义，否则部分插件会读到默认的反斜杠
let mapleader      = " "
let maplocalleader = ","

" -----------------------------------------------------------------------------
" 1. 显示与美化
" -----------------------------------------------------------------------------
syntax enable
filetype plugin indent on

" 24 位真彩色（色值全部来自 onedark，需要 tmux 侧开启 RGB，见 .tmux.conf）
if has('termguicolors')
  try
    set termguicolors
  catch /^Vim\%((\a\+)\)\=:E954/
    " 终端不支持 24 位色：静默降级，不影响其他配置
  endtry
endif

set background=dark
set number            " 绝对行号
set relativenumber    " 相对行号，配合 5j / 12k 快速跳转
set cursorline        " 高亮当前行
set signcolumn=yes    " 常驻符号列，避免 git 标记出现时整屏抖动
set colorcolumn=100   " 100 列参考线
set laststatus=2      " 永远显示状态栏（airline 需要）
set noshowmode        " 模式已由 airline 显示，避免重复
set showcmd           " 右下角显示未完成的命令
set display=lastline
set scrolloff=8       " 光标上下留 8 行
set sidescrolloff=8
set splitright        " 竖分屏开在右边
set splitbelow        " 横分屏开在下面
set pumheight=12      " 补全菜单最多 12 行

" 不可见字符可视化（空格、Tab、行尾）
set list
set listchars=tab:»·,trail:·,nbsp:␣,extends:›,precedes:‹
set fillchars=vert:│,fold:·
set showbreak=↪

" 光标形状：普通模式方块，插入模式竖线（tmux 需 terminal-features 支持）
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
let &t_SR = "\e[4 q"

" -----------------------------------------------------------------------------
" 2. 编辑体验
" -----------------------------------------------------------------------------
set expandtab          " Tab 转空格
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround
set autoindent
set smartindent
set backspace=indent,eol,start
set whichwrap+=<,>,h,l
set formatoptions-=t   " 不要自动折行
set textwidth=100
set virtualedit=block
set mouse=a            " 鼠标（Windows Terminal 里按住 Shift 可绕过）
set hidden             " 切换 buffer 不要求保存，coc/LSP 依赖此设置
set updatetime=300     " 诊断/高亮刷新间隔
set timeoutlen=500     " leader / which-key 等待时间
set ttimeoutlen=10
set completeopt=menuone,noinsert,noselect
set shortmess+=c
set wildmenu
set wildmode=longest:full,full
set wildignore=*.o,*.obj,*.pyc,*.class,*.exe,*.dll,*.so,*.a,*.zip,*.tar.gz
set wildignore+=*/node_modules/*,*/.git/*,*/__pycache__/*,*/target/*,*/dist/*
set isfname-==         " 允许 gf 跳转带 = 的路径
set nrformats-=octal   " C-a / C-x 按十进制递增

" -----------------------------------------------------------------------------
" 3. 搜索
" -----------------------------------------------------------------------------
set ignorecase
set smartcase
set incsearch
set hlsearch
" 搜索后清屏
nnoremap <silent> <leader>nh :nohlsearch<CR>

" -----------------------------------------------------------------------------
" 4. 文件、备份、撤销
" -----------------------------------------------------------------------------
set nobackup
set nowritebackup
set undofile
set undolevels=1000
set undoreload=10000
set swapfile

for s:dir in ['~/.vim/undo', '~/.vim/swap', '~/.vim/backup']
  if !isdirectory(expand(s:dir))
    call mkdir(expand(s:dir), 'p')
  endif
endfor
let &undodir    = expand('~/.vim/undo')
let &directory  = expand('~/.vim/swap')
let &backupdir  = expand('~/.vim/backup')

" 重开文件时回到上次编辑位置
augroup vimrc_lastpos
  autocmd!
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   execute "normal! g`\"" |
        \ endif
augroup END

" -----------------------------------------------------------------------------
" 5. 快捷键
" -----------------------------------------------------------------------------
" 保存 / 退出
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>Q :qa!<CR>
inoremap <C-s> <Esc>:w<CR>a

" 配置本身
nnoremap <leader>rc :source $MYVIMRC<CR>
nnoremap <leader>re :vsplit $MYVIMRC<CR>

" 分屏（| 竖分，- 横分）
nnoremap <leader><Bar> :vsplit<CR>
nnoremap <leader>- :split<CR>
nnoremap <C-Up>    :resize +5<CR>
nnoremap <C-Down>  :resize -5<CR>
nnoremap <C-Left>  :vertical resize -5<CR>
nnoremap <C-Right> :vertical resize +5<CR>

" buffer
nnoremap <leader>bd :bdelete<CR>
nnoremap <Tab>   :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>

" 行内移动增强
nnoremap Y y$
nnoremap <silent> n nzzzv
nnoremap <silent> N Nzzzv
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
xnoremap < <gv
xnoremap > >gv

" 终端：Esc 回到普通模式
nnoremap <leader>t :tabnew<CR>:terminal<CR>
tnoremap <Esc> <C-\><C-n>

" 校验 vimrc 是否有语法/加载错误
nnoremap <leader>cv :source $MYVIMRC<CR>:messages<CR>

" -----------------------------------------------------------------------------
" 6. 插件（vim-plug）
" -----------------------------------------------------------------------------
" 首次运行自动安装 vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" —— 外观 ——
Plug 'joshdick/onedark.vim'                          " 配色
Plug 'vim-airline/vim-airline'                       " 状态栏
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'                        " 文件图标（需 Nerd Font）
Plug 'Yggdroot/indentLine'                           " 缩进参考线

" —— 导航与查找 ——
Plug 'preservim/nerdtree'                            " 文件树
Plug 'Xuyuanp/nerdtree-git-plugin'                   " 文件树上的 git 标记
Plug 'junegunn/fzf'                                  " 模糊查找（依赖系统 fzf 二进制）
Plug 'junegunn/fzf.vim'
Plug 'liuchengxu/vim-which-key'                      " 按键提示
Plug 'mhinz/vim-startify'                            " 启动页 / 最近文件

" —— 效率 ——
Plug 'tpope/vim-surround'                            " 增删改包围符
Plug 'tpope/vim-commentary'                          " gcc / gc 注释
Plug 'tpope/vim-repeat'                              " 让 . 重复插件操作
Plug 'tpope/vim-unimpaired'                          " [b ]b 等成对操作
Plug 'tpope/vim-sleuth'                              " 自动识别缩进
Plug 'LunarWatcher/auto-pairs'                       " 自动补括号
Plug 'editorconfig/editorconfig-vim'                 " 遵守 .editorconfig

" —— 语言与补全 ——
Plug 'sheerun/vim-polyglot'                          " 几十种语言的语法/缩进
Plug 'neoclide/coc.nvim', {'branch': 'release'}      " LSP + 补全（依赖 Node.js）

" —— Git ——
Plug 'tpope/vim-fugitive'                            " :Git / :Gdiff
Plug 'airblade/vim-gitgutter'                        " 行级改动标记

" —— tmux 联动 ——
Plug 'christoomey/vim-tmux-navigator'                " Ctrl-h/j/k/l 跨 vim/tmux 移动

call plug#end()

" 配色（插件未装好时不报错）
silent! colorscheme onedark

" -----------------------------------------------------------------------------
" 7. 插件配置
" -----------------------------------------------------------------------------

" ---- airline ----------------------------------------------------------------
let g:airline#extensions#tabline#enabled      = 1
let g:airline#extensions#tabline#formatter    = 'unique_tail_improved'
let g:airline#extensions#branch#enabled       = 1
let g:airline#extensions#hunks#enabled        = 1
let g:airline#extensions#coc#enabled          = 1
let g:airline_powerline_fonts                 = 1
let g:airline_theme                           = 'onedark'

" ---- NERDTree ---------------------------------------------------------------
let g:NERDTreeShowHidden    = 1
let g:NERDTreeMinimalUI     = 1
let g:NERDTreeWinSize       = 32
let g:NERDTreeIgnore        = ['\.pyc$', '^__pycache__$', '^\.git$', '^node_modules$', '^target$']
let g:NERDTreeStatusline    = ''
let g:NERDTreeGitStatusUseNerdFonts = 1

nnoremap <leader>e :NERDTreeToggle<CR>
nnoremap <leader>o :NERDTreeFind<CR>

" 只剩文件树时自动退出
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1
      \ && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" ---- fzf --------------------------------------------------------------------
" 用 fd 代替 find：更快、默认忽略 .gitignore
" Ubuntu 的 fd 包名是 fd-find，二进制名 fdfind；安装脚本会建好 fd 软链
let $FZF_DEFAULT_COMMAND = 'fd --type f --hidden --follow --exclude .git --exclude node_modules'
let $FZF_DEFAULT_OPTS    = '--height 60% --layout=reverse --border --info=inline'
let g:fzf_layout         = { 'window': { 'width': 0.9, 'height': 0.7, 'border': 'rounded' } }
let g:fzf_colors = {
      \ 'fg':      ['fg', 'Normal'],
      \ 'bg':      ['bg', 'Normal'],
      \ 'hl':      ['fg', 'Comment'],
      \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
      \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
      \ 'hl+':     ['fg', 'Statement'],
      \ 'info':    ['fg', 'PreProc'],
      \ 'border':  ['fg', 'Ignore'],
      \ 'prompt':  ['fg', 'Conditional'],
      \ 'pointer': ['fg', 'Exception'],
      \ 'marker':  ['fg', 'Keyword'],
      \ 'spinner': ['fg', 'Label'],
      \ 'header':  ['fg', 'Comment'] }

nnoremap <C-p>        :Files<CR>
nnoremap <leader>ff   :Files<CR>
nnoremap <leader>fg   :Rg<CR>
nnoremap <leader>fb   :Buffers<CR>
nnoremap <leader>fh   :Helptags<CR>
nnoremap <leader>fl   :Lines<CR>
nnoremap <leader>fw   :Windows<CR>
nnoremap <leader>fc   :Colors<CR>

" ---- indentLine -------------------------------------------------------------
let g:indentLine_char_list = ['│', '¦', '┆', '┊']
let g:indentLine_setColors = 0

" ---- which-key --------------------------------------------------------------
" 不占用裸 <leader>，避免每条 leader 命令都等 timeoutlen；
" 需要看键位表时按 <Space>?（已在下方映射）
let g:which_key_map = {
      \ 'f': { 'name': '+查找' },
      \ 'b': { 'name': '+buffer' },
      \ 'c': { 'name': '+代码/LSP' },
      \ 'g': { 'name': '+Git' },
      \ 'r': { 'name': '+配置' },
      \ 't': { 'name': '+终端' },
      \ }
nnoremap <silent> <leader>? :WhichKey '<Space>'<CR>
autocmd VimEnter * if exists(':WhichKey') | call which_key#register('<Space>', 'g:which_key_map') | endif

" ---- 常用 Git 操作 ----------------------------------------------------------
nnoremap <leader>gs :Git<CR>
nnoremap <leader>gd :Gdiffsplit<CR>
nnoremap <leader>gb :Git blame<CR>
nnoremap <leader>gl :Git log --oneline --graph<CR>

" ---- startify ---------------------------------------------------------------
let g:startify_lists = [
      \ { 'type': 'files',     'header': ['   最近文件'] },
      \ { 'type': 'dir',       'header': ['   当前目录'. getcwd()] },
      \ { 'type': 'sessions',  'header': ['   会话'] },
      \ { 'type': 'bookmarks', 'header': ['   书签'] },
      \ ]
let g:startify_bookmarks = [ {'c': '~/.vimrc'}, {'t': '~/.tmux.conf'} ]
let g:startify_custom_header = []
autocmd VimEnter * if !argc() && exists(':Startify') | Startify | endif

" ---- gitgutter --------------------------------------------------------------
set updatetime=300
let g:gitgutter_map_keys = 0
nnoremap <leader>hu :GitGutterUndoHunk<CR>

" -----------------------------------------------------------------------------
" 8. coc.nvim：补全 + LSP
" -----------------------------------------------------------------------------
" 注意：coc 需要 Node.js（安装脚本会装），扩展用 :CocInstall 管理
let g:coc_global_extensions = [
      \ 'coc-json',
      \ 'coc-pyright',
      \ 'coc-tsserver',
      \ 'coc-clangd',
      \ 'coc-sh',
      \ 'coc-snippets',
      \ 'coc-html',
      \ 'coc-css',
      \ 'coc-yaml',
      \ ]

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~# '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
inoremap <silent><expr> <c-space> coc#refresh()

nmap <silent> <leader>gd <Plug>(coc-definition)
nmap <silent> <leader>gy <Plug>(coc-type-definition)
nmap <silent> <leader>gi <Plug>(coc-implementation)
nmap <silent> <leader>gr <Plug>(coc-references)
nmap <silent> <leader>rn <Plug>(coc-rename)
nmap <silent> <leader>ca <Plug>(coc-codeaction-cursor)
nmap <silent> <leader>cf <Plug>(coc-format)
nmap <silent> <leader>cd <Plug>(coc-diagnostic-info)
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" 悬浮文档
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if coc#rpc#ready()
    call CocActionAsync('doHover')
  else
    execute 'normal! ' . &keywordprg . ' ' . expand('<cword>')
  endif
endfunction

" 高亮当前符号
augroup coc_highlight
  autocmd!
  autocmd CursorHold * silent call CocActionAsync('highlight')
augroup END

" 状态栏显示诊断数量
function! s:diagnostics()
  let info = get(b:, 'coc_diagnostic_info', {})
  if empty(info) | return '' | endif
  let msgs = []
  if get(info, 'error', 0)   | call add(msgs, 'E' . info['error'])   | endif
  if get(info, 'warning', 0) | call add(msgs, 'W' . info['warning']) | endif
  return join(msgs, ' ')
endfunction

" -----------------------------------------------------------------------------
" 9. 自动命令
" -----------------------------------------------------------------------------
augroup vimrc_autocmds
  autocmd!
  " 保存时去掉行尾空白（cursorline 大文件关闭，避免卡顿）
  autocmd BufWritePre * if getfsize(expand('%')) < 1024 * 1024
        \ | silent! %s/\s\+$//e | endif

  " 打开新文件时回到文件开头附近的光标位置由 lastpos 组负责

  " 快速修复窗口快捷键
  autocmd FileType qf nnoremap <buffer> <CR> <CR>
augroup END

" 大文件降级（> 2MB 关闭语法和行号）
augroup vimrc_bigfile
  autocmd!
  autocmd BufReadPre * if getfsize(expand('%')) > 2 * 1024 * 1024
        \ | syntax off | setlocal noundofile | endif
augroup END

" -----------------------------------------------------------------------------
" 10. WSL 剪贴板（Windows 与 WSL 互通，需要 win32yank）
" -----------------------------------------------------------------------------
if !empty($WSL_DISTRO_NAME) && executable('win32yank.exe')
  let g:clipboard = {
        \ 'name': 'win32yank-wsl',
        \ 'copy': {
        \    '+': ['win32yank.exe', '-i', '--crlf'],
        \    '*': ['win32yank.exe', '-i', '--crlf'],
        \ },
        \ 'paste': {
        \    '+': ['win32yank.exe', '-o', '--lf'],
        \    '*': ['win32yank.exe', '-o', '--lf'],
        \ },
        \ 'cache_enabled': 1,
        \ }
  set clipboard=unnamedplus
endif

" -----------------------------------------------------------------------------
" 11. 本地覆盖（不进 git，放机器相关的私有配置）
" -----------------------------------------------------------------------------
if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif
