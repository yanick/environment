" fish and some plugins don't play well together
set shell=/bin/sh

let mapleader="\\"

""" vim-plug {{{
" https://github.com/junegunn/vim-plug
call plug#begin('~/.config/nvim/plugged')

Plug 'neomake/neomake'

Plug 'leafgarland/typescript-vim'
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'Quramy/tsuquyomi'

Plug 'posva/vim-vue'

Plug 'tpope/vim-eunuch'

Plug 'ctrlpvim/ctrlp.vim', {
    \ 'on': [ 'CtrlP', 'CtrlPBuffer' ]
\ }

Plug 'dhruvasagar/vim-table-mode', {
    \ 'on': [ 'TableModeEnable' ]
\ }

Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'

Plug 'tpope/vim-commentary'

Plug 'chase/vim-ansible-yaml'
Plug 'pearofducks/ansible-vim'

Plug 'hotchpotch/perldoc-vim'

Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-webdevicons'

Plug 'vimwiki/vimwiki', { 
	\ 'on': [ '<Plug>VimwikiIndex', '<Plug>VimwikiTabIndex', '<Plug>VimwikiUISelect' ] 
\ }

Plug 'yanick/vim-project'

Plug 'elzr/vim-json'

function! DoRemote(arg)
  UpdateRemotePlugins
endfunction
Plug 'Shougo/deoplete.nvim', { 'do': function('DoRemote') }

" UltiSnips
" Plug 'SirVer/ultisnips'

Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'

Plug 'junegunn/vim-easy-align'

Plug 'honza/vim-snippets'


"Plug 'Shougo/neosnippet.vim'

"Plug 'Valloric/YouCompleteMe'
let g:ycm_collect_identifiers_from_tags_files = 1

Plug 'altercation/vim-colors-solarized'

Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'

Plug 'mattn/emmet-vim', { 'for': 'html' }

Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

call plug#end()
" }}}

""" plugins {{{

""" neosnippet {{{
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)

" imap <expr><TAB>
"  \ pumvisible() ? "\<C-n>" :
"  \ neosnippet#expandable_or_jumpable() ?
"  \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
" smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
" \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

""" }}}
" deoplete
let g:deoplete#enable_at_startup = 1
set completeopt+=noinsert
 "\ neosnippet#expandable_or_jumpable() ?
 "\    "\<Plug>(neosnippet_expand_or_jump)" : 

inoremap <Tab> <C-r>=<SID>my_tab_function()<CR>

function! s:my_tab_function() abort
  call UltiSnips#ExpandSnippet()
  if g:ulti_expand_res
      return ""
  endif    

  return pumvisible() ? deoplete#mappings#close_popup() : "\<TAB>"
endfunction

let g:UltiSnipsSnippetDirectories = [ 'UltiSnips' ]
let g:UltiSnipsSnippetsDir = '~/.config/nvim/UltiSnips'
let g:UltiSnipsEditSplit='vertical'
map <Leader>eu :UltiSnipsEdit<CR>
let g:UltiSnipsExpandTrigger="<dummy>"
let g:UltiSnipsListSnippets="<s-tab>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"


let g:neosnippet#snippets_directory='~/tmp'

"smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
"\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

inoremap <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function() abort
  return pumvisible() ? "\<C-E>\<CR>": "\<CR>"
  "return deoplete#mappings#close_popup() . "\<CR>"
endfunction

" vim-easy-align
vmap <Enter> <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" NerdTree
nnoremap <silent> <F9> :NERDTreeToggle<CR>

" }}}

""" allow creation of directories on-the-fly """

function! s:MkNonExDir(file, buf)
    if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
        let dir=fnamemodify(a:file, ':h')
        if !isdirectory(dir)
            call mkdir(dir, 'p')
        endif
    endif
endfunction

augroup BWCCreateDir
    autocmd!
    autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup END

""" sudo after the fact
cmap w!! w !sudo tee % >/dev/null


"
"""""""""""""""""""""""""""""""""""""""""""""'

""" edit/source the vimrc at will
" http://learnvimscriptthehardway.stevelosh.com/chapters/07.html
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

nnoremap <leader>ef :vsplit ~/.config/fish/config.fish<cr>

""" misc abbreviations {{{
iabbrev @@ yanick@babyl.ca
iabbrev cpan@ yanick@cpan.org
imap @today <C-R>=strftime("%F")<CR>
imap  @now   <C-R>=strftime("%H:%M")<CR>

cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" }}}

""" colors {{{
if &t_Co >= 256 || has("gui_running")
    let g:solarized_termcolors=256
endif

if &t_Co > 2 || has("gui_running")
    " switch syntax highlighting on, when the terminal has colors
    syntax on
endif

set background=light

let g:solarized_visibility='low'

colorscheme solarized

" comments should be visible, not hidden
hi Comment guifg=red
hi Comment ctermfg=red

let g:airline_powerline_fonts = 1
set laststatus=2
"set encoding=utf-8

""" general stuff  {{{

" don't auto-comment subsequent lines
autocmd FileType * setlocal formatoptions-=r formatoptions-=o

" help 'complete'
" .: The current buffer
" w: Buffers in other windows
" b: Other loaded buffers
" u: Unloaded buffers
" t: Tags
" i: Included files
" k: dictionary :set dictionary=/usr/share/dict/words
set complete=.,w,b,t


set clipboard=unnamed

" ai toggle
map <Leader><space> :set ai!<CR>:set ai?<CR>


" folding 
set foldcolumn=0
set foldlevel=1

" scrolling and viewport
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>
set scrolloff=3

set ruler  " see the coords of the cursor

filetype on
filetype plugin on
filetype indent on

set wildmode=longest,list,full
set wildmenu

set wildignore=*.swp,*.bak,*.pyc,*.class

" visual bell
set visualbell


set autoindent
set textwidth=78
set backspace=indent,eol,start

set tabstop=4
set expandtab
set shiftwidth=4
set shiftround

set matchpairs+=<:>

set list
set listchars=tab:>.,extends:#,nbsp:.,precedes:<
autocmd filetype python set listchars=tab:>.,trail:.,extends:#,nbsp:.,precedes:<

" some ideas stolen from http://items.sjbach.com/319/configuring-vim-right
set history=1000
"
" buffer stuff
set hidden

set title  " set the terminal title

" }}}

""" searching {{{
set ignorecase   
set smartcase         " don't ignore case if there's a uppercase
set incsearch         " show me right now!
set hlsearch
hi search ctermbg=223 ctermfg=238
hi incsearch ctermbg=216 ctermfg=242

nmap <silent> <leader>/ :nohlsearch<CR>

"}}}

""" line numbers {{{

" http://jeffkreeftmeijer.com/2012/relative-line-numbers-in-vim-for-super-fast-movement/
set number
set relativenumber
map <leader>1 :set norelativenumber<CR>:set number<CR>
map <leader>2 :set relativenumber<CR>:set number<CR>
map <leader>3 :set norelativenumber<CR>:set nonumber<CR>

au FocusLost   * :set norelativenumber
au FocusGained * :set relativenumber

au WinLeave    * :set norelativenumber
au WinEnter    * :set relativenumber

autocmd InsertEnter * :set norelativenumber
autocmd InsertLeave * :set relativenumber

" }}}

""" backup {{{
set nobackup
set noswapfile
set writebackup
"set   backupdir=~/.vim/backup,./.backup,~/.vim/backup,.,/tmp
"set   directory=~/.vim/backup,.,./.backup,/tmp
" }}}

""" wrapping text {{{

set showbreak=↪
set breakindent

" }}}

""" vimwiki {{{
nmap <leader>ww <Plug>VimwikiIndex
nmap <Leader>wt <Plug>VimwikiTabIndex
nmap <Leader>wu <Plug>VimwikiUISelect

let g:vimwiki_list = [
    \ { 'path': '~/environment/cheatsheets/src', 'syntax': 'markdown', 'path_html': '~/environment/cheatsheets/html', 'auto_export': 0, 'template_path': '~/environment/cheatsheets/templates/', 'template_default': 'default', 'template_ext': '.html'},
    \ { 'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.md' }, 
    \ { 'path': '/home/ii/vimwiki/src', 'path_html': '/home/ii/vimwiki/html'}
    \ ]

let g:vimwiki_menu = 'Vimwiki'
"--------- }}}

autocmd FileType json map <leader>t :%!transerialize -.json -.yaml<CR>:set filetype=yaml<CR>
autocmd FileType json set equalprg=equal_json
autocmd FileType yaml map <leader>t :%!transerialize -.yaml -.json<CR>:set filetype=json<CR>
autocmd FileType javascript vmap <leader>j :'<,'>!equal_json<CR>
autocmd FileType json vmap <leader>j :'<,'>!equal_json<CR>

function! Get_visual_selection()
  " Why is this not a built-in Vim script function?!
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  let lines = getline(lnum1, lnum2)
  let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][col1 - 1:]
  return join(lines, "\n")
endfunction

map <F10> :Project .git/vim.project<CR>

au BufNewFile,BufRead vim.project set filetype=project

au FileType project nmap <buffer><F5> :%!~/bin/gen_pvim<CR>


""" Perl stuff {{{

au FileType perl nnoremap <Leader>pm :call LoadPerlModule()<CR>

function! LoadPerlModule()
  execute 'new `perldoc -l ' . expand("<cWORD>") . '`'
endfunction

" }}}

""" CtrlP {{{
map <c-p> :CtrlP<CR>
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
map <c-b> :CtrlPBuffer<CR>
" }}}

""" Show when lines extend past column 80 {{{

highlight ColorColumn ctermbg=lightred guibg=lightred
function! MarkMargin (on)
    if exists('b:MarkMargin')
        try
            call matchdelete(b:MarkMargin)
        catch /./
        endtry
        unlet b:MarkMargin
    endif
        
    if a:on
        let b:MarkMargin = matchadd('ColorColumn', '\%81v', 100)
    endif
endfunction

augroup MarkMargin
autocmd!
autocmd BufEnter * :call MarkMargin(1)
autocmd BufEnter *.vp* :call MarkMargin(0)
augroup END

""" }}}
