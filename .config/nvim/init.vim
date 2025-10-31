" Indentation/Alignment
set list listchars=tab:>-,trail:.,extends:>,precedes:<
set smarttab
set copyindent
set tabstop=4
set shiftwidth=4
set softtabstop=0

set splitright

set textwidth=80

syntax enable
colorscheme zenburn

set number
set relativenumber
highlight LineNr cterm=NONE ctermbg=NONE
set hlsearch incsearch

autocmd TermOpen * setlocal nonu


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VIM-zathura synctex configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
cnoremap w!! execute 'silent! write !sudo tee % > /dev/null' <bar> edit!

function! Synctex()
    let vimura_param = " --synctex-forward " . line('.') . ":" . col('.') . ":" . expand('%:p') . " " . substitute(expand('%:p'),"tex$","pdf", "")
    if has('nvim')
        call jobstart("nvimura neovim" . vimura_param)
    else
        exe "!nvimura vim" . vimura_param . "&"
    endif
    redraw!
endfunction
nmap <C-q> :call Synctex()<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Quick run 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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
		if isdirectory(".venv")
			exec "AsyncRun time .venv/bin/python3 %"
		else
			exec "AsyncRun time python3 %"
		endif
	elseif &filetype == 'tex'
		exec "AsyncRun! time make"
	endif
endfunction

nnoremap <F12> :AsyncRun! time sage -python % <CR>
" asyncrun now has an option for opening quickfix automatically
let g:asyncrun_open = 20

" Don't show line numbers in quickfix lists
au FileType qf setlocal nonumber


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NERDTree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <C-t> :NERDTreeToggle<CR>

"Start NERDTree automatically when no file specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

"Start NERDTree automatically when opening a directory in VIM
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif

"Close vim if only NERDTree window remains
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Jedi
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:jedi#auto_vim_configuration = 0
let g:jedi#popup_on_dot = 0
let g:jedi#show_call_signatures = "2"


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Xournalpp
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" map <F9> read ! launch_xournal % <CR>
" map <F9>:read ! launch_xournal % <CR>

function! s:get_filename_from_line()
	let line = getline('.')
	return matchstr(getline('.'), '\[\zs.\{-}\ze\]')
endfunction

map <F9> :read !create_xournal % <CR>
map <F10> :execute '!edit_xournal' s:get_filename_from_line()


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Lua
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
lua require('config/treesitter')
lua require('config/image')
