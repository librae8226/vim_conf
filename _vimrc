" .vimrc - Vim configuration file.
"
" Copyright (c) 2010 Jeffy Du. All Rights Reserved.
"
" Maintainer: Jeffy Du <jeffy.du@gmail.com>
"    Created: 2010-01-01
" LastChange: 2011-01-09
"
" Modified:   Librae <librae8226@gmail.com>
" LastChange: 2011-07-28

" GENERAL SETTINGS: {{{1
" To use VIM settings, out of VI compatible mode.
set nocompatible
" Enable file type detection.
filetype plugin indent on
" Syntax highlighting.
syntax on
" Setting colorscheme
colorscheme desert 
" Config for vim72
if v:version >= 702
set   autoindent
set   autoread
set   autowrite
set   background=dark
set   backspace=indent,eol,start
set   nobackup
set   cindent
set   cinoptions=:0
set   completeopt=longest,menuone
"set   cursorline
set   encoding=utf-8
set   noexpandtab
set   fileencodings=utf-8,gb2312,gbk,gb18030,chinese
set   fileformat=unix
set   foldenable
set   foldmethod=marker
set   helpheight=10
set   helplang=cn
set   hidden
set   history=100
set   nohlsearch
set   ignorecase
set   incsearch
set   laststatus=2
"set   mouse=a
set   mouse=v
set   number
"set   paste
set   pumheight=10
set   ruler
set   scrolloff=5
set   shiftwidth=8
set   showcmd
set   smartindent
set   smartcase
set   tabstop=8
set   termencoding=utf-8
"set   textwidth=80
set   whichwrap=h,l
set   wildignore=*.bak,*.o,*.e,*~
set   wildmenu
set   wildmode=list:longest,full
"set nowrap
endif
" Config for vim73
if v:version >= 703
"set   colorcolumn=+1
endif
" Config for win32 gvim.
if has("win32")
set   guioptions-=T
set   guioptions-=m
set   guioptions-=r
set   guioptions-=l
set   lines=26
set   columns=90
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim
language messages zh_CN.utf-8
endif

" Customiaze settings
"hi cMathOperator	cterm=none ctermfg=6

" Multi-line Comment -------------------
" @brief: Add or delete line comment //
" @map&bind
nmap <C-C> <Esc>:Setcomment<CR>
imap <C-C> <Esc>:Setcomment<CR>
vmap <C-C> <Esc>:SetcommentV<CR>
command! -nargs=0 Setcomment call s:SET_COMMENT()
command! -nargs=0 SetcommentV call s:SET_COMMENTV()

"非视图模式下所调用的函数
function! s:SET_COMMENT()
    let lindex=line(".")
    let str=getline(lindex)
    "查看当前是否为注释行
    let CommentMsg=s:IsComment(str)
    call s:SET_COMMENTV_LINE(lindex,CommentMsg[1],CommentMsg[0])
endfunction

"视图模式下所调用的函数
function! s:SET_COMMENTV()
    let lbeginindex=line("'<") "得到视图中的第一行的行数
    let lendindex=line("'>") "得到视图中的最后一行的行数
    let str=getline(lbeginindex)
    "查看当前是否为注释行
    let CommentMsg=s:IsComment(str)
    "为各行设置
    let i=lbeginindex
    while i<=lendindex
         call s:SET_COMMENTV_LINE(i,CommentMsg[1],CommentMsg[0])
        let i=i+1
    endwhile
endfunction

"设置注释
"index:在第几行
"pos:在第几列
"comment_flag: 0:添加注释符 1:删除注释符
function! s:SET_COMMENTV_LINE( index,pos, comment_flag )
    let poscur = [0, 0,0, 0]
    let poscur[1]=a:index
    let poscur[2]=a:pos+1
    call setpos(".",poscur) "设置光标的位置

    if a:comment_flag==0
        "插入//
        exec "normal! i//"
    else
        "删除//
        exec "normal! xx"
    endif
endfunction

"查看当前是否为注释行并返回相关信息
"str:一行代码
function! s:IsComment(str)
    let ret= [0, 0] "第一项为是否为注释行（0,1）,第二项为要处理的列，
    let i=0
    let strlen=len(a:str)
    while i<strlen
        "空格和tab允许为"//"的前缀
        if !(a:str[i]==' ' ||    a:str[i] == '  ' )
            let ret[1]=i
            if a:str[i]=='/' && a:str[i+1]=='/'
                let ret[0]=1
            else
                let ret[0]=0
            endif
            return ret
        endif
        let i=i+1
    endwhile
    return [0,0]  "空串处理
endfunction
" Multi-line Comment End ---------------

"-----------------
" vimwiki support
"-----------------
map <S-F7> :VimwikiAll2HTML<cr>
map <F7> :Vimwiki2HTML<cr>
" 我们并不怎么需要驼峰英文成为维基词条
let g:vimwiki_camel_case = 0
" 标记为完成的 checklist 项目会有特别的颜色
let g:vimwiki_hl_cb_checked = 1
let g:vimwiki_list = [{'path_html': '~/vimwiki/vimwiki_html/',}]
" 是否在词条文件保存时就输出html  这个会让保存大词条比较慢
" 所以我默认没有启用  有需要的话就把这一行复制到下面去
" \ 'auto_export': 1,     
" 多个维基项目的配置
" let g:vimwiki_list = [{'path': 'E:/My Dropbox/vimwiki/',
"       \ 'html_header': 'E:/My Dropbox/Public/vimwiki_template/header.htm',
"       \ 'html_footer': 'E:/My Dropbox/Public/vimwiki_template/footer.htm',
"       \ 'diary_link_count': 5},
"       \{'path': 'Z:\demo\qiuchi\wiki'}]
" 对中文用户来说，我们并不怎么需要驼峰英文成为维基词条
" let g:vimwiki_camel_case = 0
" 标记为完成的 checklist 项目会有特别的颜色
" let g:vimwiki_hl_cb_checked = 1
" 我的 vim 是没有菜单的，加一个 vimwiki 菜单项也没有意义
" let g:vimwiki_menu = ''
" 是否开启按语法折叠  会让文件比较慢
" let g:vimwiki_folding = 1   
" 是否在计算字串长度时用特别考虑中文字符
" let g:vimwiki_CJK_length = 1       
" 详见下文...
" let g:vimwiki_valid_html_tags='b,i,s,u,sub,sup,kbd,del,br,hr,div,code,h1'

" AUTO COMMANDS: {{{1
" auto expand tab to blanks
"autocmd FileType c,cpp set expandtab
" Restore the last quit position when open file.
autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \     exe "normal g'\"" |
    \ endif

" SHORTCUT SETTINGS: {{{1
" Set mapleader
let mapleader=","
" Space to command mode.
"nnoremap <space> :
"vnoremap <space> :
" Switching between buffers.
nnoremap <C-h> <C-W>h
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-l> <C-W>l
inoremap <C-h> <Esc><C-W>h
inoremap <C-j> <Esc><C-W>j
inoremap <C-k> <Esc><C-W>k
inoremap <C-l> <Esc><C-W>l
" "cd" to change to open directory.
let OpenDir=system("pwd")
nmap <silent> <leader>cdr :exe 'cd ' . OpenDir<cr>:pwd<cr>
nmap <silent> <leader>cdf :cd %:h<cr>:pwd<cr>

" PLUGIN SETTINGS: {{{1
" taglist.vim
let g:Tlist_Auto_Update=1
let g:Tlist_Process_File_Always=1
let g:Tlist_Exit_OnlyWindow=1
let g:Tlist_Show_One_File=1
let g:Tlist_WinWidth=36
let g:Tlist_Enable_Fold_Column=0
let g:Tlist_Auto_Highlight_Tag=1
" NERDTree.vim
let g:NERDTreeWinPos="right"
let g:NERDTreeWinSize=26
let g:NERDTreeShowLineNumbers=1
let g:NERDTreeQuitOnOpen=1
" cscope.vim
if has("cscope")
    set csto=1
    set cst
    set nocsverb
    if filereadable("cscope.out")
        cs add cscope.out
    endif
    set csverb
endif
" OmniCppComplete.vim
let g:OmniCpp_DefaultNamespaces=["std"]
let g:OmniCpp_MayCompleteScope=1
let g:OmniCpp_SelectFirstItem=2
" VimGDB.vim
if has("gdb")
	set asm=0
	let g:vimgdb_debug_file=""
	run macros/gdb_mappings.vim
endif
" LookupFile setting
let g:LookupFile_TagExpr='"tags.fn"'
let g:LookupFile_MinPatLength=2
let g:LookupFile_PreserveLastPattern=0
let g:LookupFile_PreservePatternHistory=1
let g:LookupFile_AlwaysAcceptFirst=1
let g:LookupFile_AllowNewFiles=0
" Man.vim
source $VIMRUNTIME/ftplugin/man.vim
" snipMate
let g:snips_author="Du Jianfeng"
let g:snips_email="cmdxiaoha@163.com"
let g:snips_copyright="SicMicro, Inc"
" plugin shortcuts
function! RunShell(Msg, Shell)
	echo a:Msg . '...'
	call system(a:Shell)
	echon 'done'
endfunction
nmap  <F2> :TlistToggle<cr>
nmap  <F3> :NERDTreeToggle<cr>
nmap <C-F3> :NERDTreeRefreshRoot<cr>
nmap  <F4> :MRU<cr>
nmap  <F5> <Plug>LookupFile<cr>
nmap <C-F5> :e<cr>
nmap  <F6> :vimgrep /<C-R>=expand("<cword>")<cr>/ **/*.c **/*.h<cr><C-o>:cw<cr>
nmap <C-F9> :call RunShell("Generate tags", "ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .")<cr>
nmap <C-F10> :call HLUDSync()<cr>
nmap <C-F11> :call RunShell("Generate filename tags", "~/.vim/shell/genfiletags.sh")<cr>
nmap <C-F12> :call RunShell("Generate cscope", "cscope -Rb")<cr>:cs add cscope.out<cr>
nmap <leader>sa :cs add cscope.out<cr>
nmap <leader>ss :cs find s <C-R>=expand("<cword>")<cr><cr>
nmap <leader>sg :cs find g <C-R>=expand("<cword>")<cr><cr>
nmap <leader>sc :cs find c <C-R>=expand("<cword>")<cr><cr>
nmap <leader>st :cs find t <C-R>=expand("<cword>")<cr><cr>
nmap <leader>se :cs find e <C-R>=expand("<cword>")<cr><cr>
nmap <leader>sf :cs find f <C-R>=expand("<cfile>")<cr><cr>
nmap <leader>si :cs find i <C-R>=expand("<cfile>")<cr><cr>
nmap <leader>sd :cs find d <C-R>=expand("<cword>")<cr><cr>
nmap <leader>zz <C-w>o
nmap <leader>gs :GetScripts<cr>
" mark setting
nmap <silent> <leader>hl <Plug>MarkSet
vmap <silent> <leader>hl <Plug>MarkSet
nmap <silent> <leader>hh <Plug>MarkClear
vmap <silent> <leader>hh <Plug>MarkClear
nmap <silent> <leader>hr <Plug>MarkRegex
vmap <silent> <leader>hr <Plug>MarkRegex 

