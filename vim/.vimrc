" 置于用户目录下 会覆盖默认的vim配置(linux下默认配置是/etc/vimrc)

" 设置编码(缓存的文本、寄存器、Vim 脚本文件等)
set encoding=utf-8

" 设置 Vim 写入文件时采用的编码类型
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936

" 输出到终端时采用的编码类型
set termencoding=utf-8

" 显示行号
set nu 
"set number

" 取消显示行号
"set nonu

" 历史记录数
set history=1000

" 不换行
set nowrap

" 默认缩进4个空格
"set shiftwidth=4

" 使用tab时 表示的空格数
"set softtabstop=4

" tab键宽度为4个空格
set tabstop=4

" 不要用空格代替制表符
set noexpandtab

" 在行和段开始处使用制表符
set smarttab

" 自动缩进 即每行的缩进同上一节相同
set autoindent

" 突出显示当前行
set cursorline

" 语法高亮
set syntax=on

" 去掉输入错误的提示声音
set noeb

" 在处理未保存或只读文件的时候，弹出确认
set confirm

" 共享剪贴板  
set clipboard=unnamed 

" 从不备份  
set nobackup

" 禁止生成临时文件
set noswapfile

" 高亮显示匹配的括号
set showmatch

" 匹配括号高亮的时间（单位是十分之一秒）
set matchtime=1

" 光标移动到buffer的顶部和底部时保持3行距离
set scrolloff=3


" 启用鼠标
set mouse=a
set selection=exclusive
set selectmode=mouse,key

" 不要使用vi的键盘模式，而是vim自己的
set nocompatible

set ts=4

" 设置当文件被改动时自动载入
set autoread

" 侦测文件类型
filetype on
" 载入文件类型插件  
filetype plugin on
" 为特定文件类型载入相关缩进文件
filetype indent on




