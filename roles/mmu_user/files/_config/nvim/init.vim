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

"Plug 'ambv/black'
"Plug 'davidhalter/jedi-vim'
"Plug 'SirVer/ultisnips' | Plug 'jayli/vim-easycomplete'
Plug 'dense-analysis/ale'
"Plug 'pearofducks/ansible-vim'
Plug 'michaeljsmith/vim-indent-object'
"Plug 'vim-airline/vim-airline'
"Plug 'junegunn/vim-easy-align'
"Plug 'godlygeek/tabular'
"Plug 'dhruvasagar/vim-table-mode'
Plug 'chrisbra/csv.vim'
"Plug 'chr4/nginx.vim'
"Plug 'chr4/sslsecure.vim'
Plug 'tpope/vim-fugitive'
"Plug 'tpope/vim-surround'
"Plug 'vim-syntastic/syntastic'
"Plug 'tpope/vim-sensible'
"Plug 'aklt/plantuml-syntax'
"Plug 'mattn/webapi-vim' | Plug 'mattn/vim-gist'
Plug 'nvim-treesitter/nvim-treesitter'

call plug#end()

" Plug 'mattn/webapi-vim' | Plug 'mattn/vim-gist'
let g:gist_api_url = 'https://github.boschdevcloud.com/api/v3'
let g:gist_post_private = 1

if has("win32")
" Plug 'psf/black' ", { 'branch': 'stable' }
let g:black_virtualenv = "~/vimfiles/black"
endif

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

" Plug 'chrisbra/csv.vim'
let g:csv_comment = '#'
let g:csv_delim_test = "\t"

" Plugin 'pearofducks/ansible-vim'
let g:ansible_unindent_after_newline = 1

" Plugin 'vim-syntastic/syntastic'
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 1

if has("gui_running")
if has("win32")
  set lines=32767 columns=32767
endif
  set guioptions-=m " Turn off menubar
  set guioptions-=T " Turn off toolbar
  set guioptions-=r " Turn off right-hand scrollbar
  set guioptions-=R " Turn off right-hand scrollbar when split
  set guioptions-=L " Turn off left-hand scrollbar
  set guioptions-=l " Turn off left-hand=scrollbar when split
  set guicursor+=a:blinkon0 " Turn off blinking cursor
if has("win32")
  set guifont=Consolas:h11
else
  set guifont=Fira\ Code\ 12
endif
endif

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
    autocmd BufRead,BufNewFile *.tsv,*.tab let b:delimiter="\t" | set filetype=csv
    autocmd BufRead,BufNewFile *.csv,*.dat set filetype=csv
augroup END
