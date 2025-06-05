execute pathogen#infect()
call pathogen#infect()
syntax on
filetype plugin indent on
" This is necessary for VimTeX to load properly. The "indent" is optional.
" Note: Most plugin managers will do this automatically!"

" This enables Vim's and neovim's syntax-related features. Without this, some
" VimTeX features will not work (see ":help vimtex-requirements" for more
" info).
" Note: Most plugin managers will do this automatically!
syntax enable

" Viewer options: One may configure the viewer either by specifying a built-in
" viewer method:
let g:vimtex_view_method = 'zathura'

" Or with a generic interface:
let g:vimtex_view_general_viewer = 'okular'
let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'

" VimTeX uses latexmk as the default compiler backend. If you use it, which is
" strongly recommended, you probably don't need to configure anything. If you
" want another compiler backend, you can change it as follows. The list of
" supported backends and further explanation is provided in the documentation,
" see ":help vimtex-compiler".
let g:vimtex_compiler_latexmk = {
  \ 'output_directory' : 'build',
  \ 'callback' : 1,
  \ 'options' : [
  \   '-pdf',
  \   '-pdflatex=pdflatex',
  \   '-synctex=1',
  \   '-interaction=nonstopmode'
  \ ],
\}



" Java compilation

autocmd Filetype java set makeprg=javac\ %
set errorformat=%A%f:%l:\ %m,%-Z%p^,%-C%.%#
map <F9> :make<Return>:copen<Return>
map <F10> :cnext<Return>
map <F11> :!javac %; java `basename % .java`<CR>

"Only apply auto-pairing mappings for filetypes other than 'tex'
"autocmd FileType * if &filetype !=# 'tex' | inoremap " ""<ESC>i | endif
"autocmd FileType * if &filetype !=# 'tex' | inoremap ' ''<ESC>i | endif
"autocmd FileType * if &filetype !=# 'tex' | inoremap { {<Cr>}<Esc>O | endif

" Most VimTeX mappings rely on localleader and this can be changed with the
" following line. The default is usually fine and is the symbol "\".
let maplocalleader = ","
" Start NERDTree. If a file is specified, move the cursor to its window.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * NERDTree | if argc() > 0 || exists("s:std_in") | wincmd p | endif
" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | call feedkeys(":quit\<CR>:\<BS>") | endif
