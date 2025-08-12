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


" Tagbar
" Tagbar Configuration
nmap <F2> :TagbarToggle<CR> " Toggle Tagbar window with F2
let g:tagbar_width = 30     " Set Tagbar window width
let g:tagbar_autofocus = 1  " Autofocus Tagbar when opened

" JavaComplete2 Configuration
autocmd FileType java setlocal omnifunc=javacomplete#Complete

" Optional: Key mappings for JavaComplete2 (highly recommended)
" Smart Add/Organize Imports: Adds missing imports intelligently, removes unused ones.
nmap <F4> <Plug>(JavaComplete-Imports-AddSmart)
imap <F4> <Plug>(JavaComplete-Imports-AddSmart)

" Add specific import (prompts you)
nmap <F5> <Plug>(JavaComplete-Imports-Add)
imap <F5> <Plug>(JavaComplete-Imports-Add)

" Add all missing imports (might add more than you need, then use F4)
nmap <F6> <Plug>(JavaComplete-Imports-AddMissing)
imap <F6> <Plug>(JavaComplete-Imports-AddMissing)

" Go to definition (similar to F12 in IDEs)
nmap gd <Plug>(JavaComplete-GoToDefinition)

" auto compile
autocmd FileType java nnoremap <buffer> <leader>jc :w<CR>:silent !javac %<CR>:term ++curwin javac %<CR>


" Find references
nmap gr <Plug>(JavaComplete-FindReferences)
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


" --- Auto-generate Java class boilerplate on new files ---
augroup JavaBoilerplate
  autocmd!
  " When a new .java file is created (BufNewFile) and the buffer is empty
  autocmd BufNewFile *.java if expand('%:p') =~# '\.java$' && getline(1) == '' | call JavaBoilerplate() | endif
augroup END

" Function to generate Java class boilerplate
function! JavaBoilerplate()
  let className = expand('%:t:r') " Get filename without extension
  " Remove package declarations (if any) to get just the class name
  let className = substitute(className, '\v^(.*/)*', '', '') 

  " Get package name from directory structure
  " This assumes a standard Maven/Gradle src/main/java/com/example/package/ClassName.java structure
  let fullPath = expand('%:p:h')
  let projectRoot = finddir('.git', fullPath) " Find project root based on .git or .svn, etc.
  if empty(projectRoot)
    let projectRoot = finddir('pom.xml', fullPath) " Try pom.xml for Maven
  endif
  if empty(projectRoot)
    let projectRoot = finddir('build.gradle', fullPath) " Try build.gradle for Gradle
  endif

  let packageName = ''
  if !empty(projectRoot)
    let relativePath = fnamemodify(fullPath, ":~:s?" . projectRoot . "/?\\?gc") " Get relative path from project root
    " Extract package from common Java source roots (src/main/java, src/test/java)
    if relativePath =~# '\v(src/(main|test)/java/)'
      let packageDir = substitute(relativePath, '\v.*(src/(main|test)/java/)\zs(.*)', '\3', '')
      let packageName = substitute(packageDir, '/', '.', 'g')
    endif
  endif

  " Prepare the boilerplate content
  let boilerplate = []
  if !empty(packageName)
    call add(boilerplate, 'package ' . packageName . ';')
    call add(boilerplate, '')
  endif
  call add(boilerplate, '/**')
  call add(boilerplate, ' * ' . className . '.java')
  call add(boilerplate, ' *')
  call add(boilerplate, ' * @author Nathan Hogg') " Customize your author name here
  call add(boilerplate, ' * @version 1.0')
  call add(boilerplate, ' * @since ' . strftime('%Y-%m-%d %H:%M:%S')) " Current date/time
  call add(boilerplate, ' */')
  call add(boilerplate, 'public class ' . className . ' {')
  call add(boilerplate, '')
  call add(boilerplate, '    public static void main(String[] args) {')
  call add(boilerplate, '    }')
  call add(boilerplate, '}')

  " Insert the boilerplate into the buffer
  call append(0, boilerplate)
  " Position cursor for convenience (e.g., inside the class body)
  normal! GkJ
  startinsert!
endfunction
