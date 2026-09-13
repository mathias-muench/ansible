" Built-In Functionality
"" General
let mapleader = '-'
let maplocalleader = '-'

nnoremap <F29> <C-{>
nnoremap <F30> <C-[>
nnoremap <F31> <C-]>
nnoremap <F32> <C-}>
nnoremap <F33> <C-\>
nnoremap <F34> <C-|>
nnoremap <C-F7> <C-{>
nnoremap <C-F8> <C-[>
nnoremap <C-F9> <C-]>
nnoremap <C-F10> <C-}>
nnoremap <C-F11> <C-\>
nnoremap <C-F12> <C-|>
noremap <M-Right> :tabnext<C-M>

tnoremap <F29> <C-{>
tnoremap <F30> <C-[>
tnoremap <F31> <C-]>
tnoremap <F32> <C-}>
tnoremap <F33> <C-\>
tnoremap <F34> <C-|>
tnoremap <C-F7> <C-{>
tnoremap <C-F8> <C-[>
tnoremap <C-F9> <C-]>
tnoremap <C-F10> <C-}>
tnoremap <C-F11> <C-\>
tnoremap <C-F12> <C-|>
tnoremap <M-Right> <C-\><C-O>:tabnext<C-M>
tnoremap ° <C-\><C-N>

" Plugins

"" Installation with VimPlug
if has("win32")
" Invoke-WebRequest -UseBasicParsing https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |`New-Item $HOME/vimfiles/autoload/plug.vim -Force
" (Get-Item -Force $HOME\vimfiles).Attributes += 'Hidden'
" (Get-Item -Force $HOME\_vimrc).Attributes += 'Hidden'
call plug#begin()
else
call plug#begin('~/.config/nvim/plugged')
endif

Plug 'chrisbra/csv.vim'
Plug 'dense-analysis/ale'
Plug 'michaeljsmith/vim-indent-object'
Plug 'tpope/vim-fugitive'

call plug#end()

" Plug 'dense-analysis/ale'
let g:loaded_python3_provider = 0  " Disable Python 3 provider
let g:ale_fixers = {
\   'yaml': [
\       'yamlfmt',
\   ],
\}
let g:ale_linters_explicit = 1
let g:ale_linters = {
\   'python': [
\       'pyright',
\       'ruff',
\   ],
\}
let g:ale_set_quickfix = 1

augroup vimrc
    autocmd!
    autocmd BufRead,BufNewFile *.json.j2 set filetype=json.jinja2
    autocmd FileType html,html.* setlocal shiftwidth=2 tabstop=2 noexpandtab autoindent
    autocmd FileType json,json.*,yaml,yaml.* setlocal shiftwidth=2 tabstop=2 expandtab autoindent
    autocmd FileType python,jinja setlocal shiftwidth=4 tabstop=4 expandtab autoindent
    autocmd FileType markdown setlocal shiftwidth=4 tabstop=4 expandtab autoindent
    autocmd BufRead,BufNewFile Jenkinsfile* set filetype=groovy
    autocmd FileType groovy setlocal shiftwidth=4 tabstop=4 expandtab autoindent
    autocmd FileType structurizr,groovy setlocal cinoptions=+0
    autocmd FileType csv setlocal conceallevel=2
augroup END
