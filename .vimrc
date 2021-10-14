set autoindent
set expandtab
set textwidth=80

syntax enable
set background=dark
colorscheme zenburn

"filetype plugin indent on
"" Maps Coquille commands to CoqIDE default key bindings
"au FileType coq call coquille#FNMapping()

set number
highlight LineNr cterm=NONE ctermbg=NONE
set hlsearch incsearch
set tabstop=2

"nnoremap <C-n><C-n> :set invnumber<CR>
"nnoremap <C-p><C-p> :!preview %:p<CR>:redraw!<CR>
"nnoremap <C-p><C-w> :!workbook -p<CR>:!preview /home/travis/documents/notebook/main.tex<CR>:redraw!<CR>
"nnoremap <C-j>      :noh <CR>
"nnoremap <C-m><C-m> :!makeNotes<CR>
"nnoremap <C-m><C-n> :!makeNotes upload<CR>

"Latex related shortcuts

"Blackboard bold
imap <C-r><C-r> \mathbb{R}
imap <C-C><C-C> \mathbb{C}
imap <C-Z><C-Z> \mathbb{Z}

"Caligraphic
imap <C-C><C-U> \mathbb{U}
imap <C-C><C-H> \mathbb{U}
imap <C-C><C-A> \mathbb{U}

"Fraktur
imap <C-f><C-g> \mathfrak{g}
imap <C-f><C-h> \mathfrak{h}

"Synctex support
function! SyncTexForward()
    let execstr = "silent !zathura --synctex-forward ".line(".").":".col(".").":%:p %:p:r.pdf &"
    exec execstr
endfunction
au FileType tex nmap <C-q> :call SyncTexForward()<CR>:redraw!<CR>

au FileType coq call coquille#FNMapping() 


" Save root files with sudo
cnoremap w!! execute 'silent! write !sudo tee % > /dev/null' <bar> edit!

" Quick run via <F5>
nnoremap <F5> :call <SID>compile_and_run()<CR>

function! s:compile_and_run()
    exec 'w'
    if &filetype == 'c'
        exec "AsyncRun! gcc % -o %<; time ./%<"
    elseif &filetype == 'cpp'
       exec "AsyncRun! g++ -std=c++11 % -o %<; time ./%<"
    elseif &filetype == 'java'
       exec "AsyncRun! javac %; time java %<"
    elseif &filetype == 'sh'
       exec "AsyncRun! time bash %"
    elseif &filetype == 'python'
       exec "AsyncRun! time python3 %"
    endif
endfunction

nnoremap <F12> :AsyncRun! time sage -python % <CR>

" asyncrun now has an option for opening quickfix automatically
let g:asyncrun_open = 8

""""
"NERDTree
""""
map <C-t> :NERDTreeToggle<CR>

"Start NERDTree automatically when no file specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

"Start NERDTree automatically when opening a directory in VIM
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif

"Close vim if only NERDTree window remains
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif



