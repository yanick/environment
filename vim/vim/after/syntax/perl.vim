" supposed to be loaded after perl-support.vim

let g:Perl_AuthorName      = 'Yanick Champoux'     
let g:Perl_AuthorRef       = 'YANICK'                         
let g:Perl_Email           = 'yanick@cpan.org'            
let g:Perl_Template_File   = 'my-perl-file-header'

" check perl code with :make
autocmd FileType perl set makeprg=perl\ -c\ %\ $*
autocmd FileType perl set errorformat=%f:%l:%m
autocmd FileType perl set autowrite

" my perl includes pod
let perl_include_pod = 1
" syntax color complex things like @{${"foo"}}
let perl_extended_vars = 1

" folding
let perl_fold=1
let perl_fold_blocks=1

" statements
" if
map <Leader>if \ai
imap <Leader>if <ESC>,if
" else
map <Leader>el ]}oelse {<CR>}<ESC>ko
imap <Leader>el <ESC>,el
" elsif
map <Leader>ei ]}oelsif ( X ) {<CR>}<ESC>k0fXxi
imap <Leader>ei <ESC>,ei
" while
map <Leader>wh \aw
imap <Leader>wh <ESC>\aw

" insert a template for a method
map ,m o<ESC>:r~/documents/vim/templates/perl.method<CR>/METHOD<CR>cw
