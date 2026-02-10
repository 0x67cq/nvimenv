
" =====文件=====
" 设置编码格式
set encoding=utf-8
if !has('nvim')
  set termencoding=utf-8
endif

" 文件修改自动载入
set autoread
" 覆盖文件不备份
set nobackup
" 关闭交换文件
set noswapfile

" =====命令行=====

" 菜单补全
set completeopt-=preview
" 历史命令容量
set history=2000
" 命令行智能补全

" =====状态栏=====
" 显示光标当前位置
set ruler
" 显示当前正在输入的命令
set showcmd
" 允许有未保存时切换缓冲区
set hidden

" =====显示=====
" 禁止拆行
set nowrap
" 高亮显示当前行

" 提高画面流畅度
set lazyredraw

" 显示tab跟空格
set list
set listchars=tab:>-,trail:·,nbsp:·


" 垂直滚动
set scrolloff=5
" 水平滚动
set sidescroll=1
set sidescrolloff=5


" =====搜索=====

" 高亮显示搜索结果
set hlsearch
" 开启实时搜索功能
set incsearch
" 搜索时大小写不敏感
set ignorecase
set smartcase

" =====缩进=====

" 退格键正常处理
set backspace=2
" 智能缩进
"set cindent
" 自动缩进
set autoindent
" 制表符占用空格数
set tabstop=4
" 自动缩进距离
set shiftwidth=4
" 连续空格视为制表符
"set softtabstop=4
" 按退格键一次删掉4个空格
set smarttab
" 将Tab自动转化成空格
set ts=4
set expandtab
:%retab
" 智能缩进
"set shiftround
" 设置超过100长度提示
set colorcolumn=81
" 快捷键延迟
set ttimeoutlen=15

" 背景颜色
set background=dark
" 主题
let g:rehash256 = 1
let g:molokai_original = 1
set t_Co=256

set redrawtime=10000
highlight Normal ctermbg=None

"设置鼠标选择
set mouse=a


