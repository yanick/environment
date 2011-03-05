" supposed to be loaded after perl-support.vim

let g:Perl_AuthorName      = 'Yanick Champoux'     
let g:Perl_AuthorRef       = 'YANICK'                         
let g:Perl_Email           = 'yanick@cpan.org'            
let g:Perl_Template_File   = 'my-perl-file-header'

setlocal iskeyword=48-57,_,A-Z,a-z,:

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


" as seen on http://blogs.perl.org/users/marcel_grunauer/2010/12/vim-add-a-use-statement-without-moving-the-cursor.html

" perl: add 'use' statement
"
" make sure you have
"   setlocal iskeyword=48-57,_,A-Z,a-z,:
" so colons are recognized as part of a keyword

function! PerlAddUseStatement()
    let s:package = input('Package? ', expand('<cword>'))
    " skip if that use statement already exists
    if (search('^use\s\+'.s:package, 'bnw') == 0)
        " below the last use statement, except for some special cases
        let s:line = search('^use\s\+\(constant\|strict\|warnings\|parent\|base\|5\)\@!','bnw')
        " otherwise, below the ABSTRACT (see Dist::Zilla)
        if (s:line == 0)
            let s:line = search('^# ABSTRACT','bnw')
        endif
        " otherwise, below the package statement
        if (s:line == 0)
            let s:line = search('^package\s\+','bnw')
        endif
        " if there isn't a package statement either, put it below
        " the last use statement, no matter what it is
        if (s:line == 0)
            let s:line = search('^use\s\+','bnw')
        endif
        " if there are no package or use statements, it might be a
        " script; put it below the shebang line
        if (s:line == 0)
            let s:line = search('^#!','bnw')
        endif
        " if s:line still is 0, it just goes at the top
        call append(s:line, 'use ' . s:package . ';')
    endif
endfunction

map ,use :<C-u>call PerlAddUseStatement()<CR>

let g:NumberRowRemapped = 0

function! RemapNumberRow()
    if ( g:NumberRowRemapped == 0 )
" map each number to its shift-key character
inoremap 1 !
inoremap 2 @
inoremap 3 #
inoremap 4 $
inoremap 5 %
inoremap 6 ^
inoremap 7 &
inoremap 8 *
inoremap 9 (
inoremap 0 )
" and then the opposite
inoremap ! 1
inoremap @ 2
inoremap # 3
inoremap $ 4
inoremap % 5
inoremap ^ 6
inoremap & 7
inoremap * 8
inoremap ( 9
inoremap ) 0

let g:NumberRowRemapped = 1

else

inoremap 1 1
inoremap 2 2
inoremap 3 3
inoremap 4 4
inoremap 5 5
inoremap 6 6
inoremap 7 7
inoremap 8 8
inoremap 9 9
inoremap 0 0
" and then the opposite
inoremap ! !
inoremap @ @
inoremap # #
inoremap $ $
inoremap % %
inoremap ^ ^
inoremap & &
inoremap * *
inoremap ( (
inoremap ) )

let g:NumberRowRemapped = 0

endif

endfunction

"call RemapNumberRow()

map <Leader>1 :call RemapNumberRow()<CR>
