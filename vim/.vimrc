" Prerequisites for vimwiki, vim-latex
set nocompatible
filetype plugin on
syntax on


" for indentation and heading folding
let g:vimwiki_folding='expr'
set shiftwidth=4


"for tagbar integration
let g:tagbar_type_vimwiki = {
          \   'ctagstype':'vimwiki'
          \ , 'kinds':['h:header']
          \ , 'sro':'&&&'
          \ , 'kind2scope':{'h':'header'}
          \ , 'sort':0
          \ , 'ctagsbin':'~/.local/bin/vwtags.py'
          \ , 'ctagsargs': 'default'
          \ }
nmap <F8> :TagbarToggle<CR>


" FOR vim-latex
" IMPORTANT: win32 users will need to have 'shellslash' set so that latex
" can be called correctly
" set shellslash

" OPTIONAL: This enables automatic indentation as you type
filetype indent on

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' isntead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'


" FOR vimwiki
" Personal wiki attributes
let wiki_personal = {}
let wiki_personal.path = '~/Documents/personal/wiki/'
let wiki_personal.path_html = '~/Documents/personal/wiki_html/'
let wiki_personal.auto_export = 1

" Work wiki attributes
let wiki_work = {}
let wiki_work.path = '~/Documents/work/pyasa/wiki/'
let wiki_work.path_html = '~/Documents/work/pyasa/wiki_html/'
let wiki_work.auto_export = 1

" Register wikis
let g:vimwiki_list = [wiki_personal, wiki_work]


" FOR vim-plug
" Specify a directory for plugins
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')
Plug 'powerman/vim-plugin-AnsiEsc'
Plug 'majutsushi/tagbar'
" Plug 'Shougo/unite.vim'
Plug 'Shougo/denite.nvim'
Plug 'vim-airline/vim-airline'
Plug 'blindFS/vim-taskwarrior'
Plug 'vimwiki/vimwiki', { 'branch': 'dev' }
Plug 'tbabej/taskwiki'
Plug 'vim-latex/vim-latex'
Plug 'aperezdc/vim-template'
call plug#end()

