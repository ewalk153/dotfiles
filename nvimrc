" =================================================
" Functions
" =================================================

" Use git-stripspace
function! StripWhitespace()
  let l = line(".")
  let c = col(".")
  %!git stripspace
  call cursor(l, c)
endfunction

" =================================================
" Plugins
" =================================================
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.local/share/nvim/plugged')
Plug 'mattn/calendar-vim'
Plug 'vimwiki/vimwiki'

Plug 'tpope/vim-dispatch'

" `ctrl + d` open Nerdtree
Plug 'scrooloose/nerdtree'

" `ctrl + p` quick file opening
" Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" `:Ack [options] {pattern} [{directories}]` Search everywhere
Plug 'mileszs/ack.vim'

" `'` Quick comment
Plug 'tpope/vim-commentary'

" Wrap stuff
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'

Plug 'tpope/vim-abolish'
" Git status in gutter
Plug 'airblade/vim-gitgutter'

" TESTING better language support?
Plug 'sheerun/vim-polyglot'

" one dark theme
Plug 'joshdick/onedark.vim'

" multi cursor
Plug 'terryma/vim-multiple-cursors'

" Gstatus, Gbrowse
Plug 'tpope/vim-fugitive'

" Enables Gbrowse to open Github
Plug 'tpope/vim-rhubarb'

" Fast switching between open buffers
" Plug 'jeetsukumaran/vim-buffergator'

" fast buffer switch
Plug 'jlanzarotta/bufexplorer'

" Ruby plugin
Plug 'vim-ruby/vim-ruby'

" Rails specific support
Plug 'tpope/vim-rails'

" mirror of taglist v 4.6
Plug 'ewalk153/taglist_46'

Plug 'tpope/vim-dispatch'

" ruby code block navigation
Plug 'dewyze/vim-ruby-block-helpers'

" to do list
Plug 'dewyze/vim-tada'
" autocomplete with vim from sorbet
" Plug 'autozimu/LanguageClient-neovim'

" Plug 'Shopify/vim-sorbet' ", { 'branch': 'main' }

" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

call plug#end()

" Use rg instead of ack
let g:ackprg = 'rg --vimgrep'

" vim-json
let g:vim_json_syntax_conceal = 0

" vim-ruby
let g:ruby_indent_access_modifier_style = 'normal'
let g:ruby_indent_assignment_style = 'variable'
let g:ruby_indent_block_style = 'do'

"let g:LanguageClient_serverCommands = {
"   \ 'ruby': ['bundle', 'exec', 'srb', 'tc', '--lsp'],
"   \ }

" setup deoplete
" let g:deoplete#enable_at_startup = 1
" =================================================
" Configs
" =================================================

" Colors
syntax on
colorscheme onedark
set colorcolumn=120
" Old file types
" Avsc monorail definitions
au BufRead,BufNewFile *.avsc set filetype=json

" Tab stuff
nnoremap H gT
nnoremap L gt

" Leader stuff
let mapleader=","
nnoremap <Leader>c :nohl<CR>
" disabled, as it conflicts with vim-wiki binding
" nnoremap <Leader>w :call StripWhitespace()<CR>:w<CR>

" NERDTree
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>m :NERDTreeFind<CR>

" run tests
nmap <leader>fx "zy:let @x=expand("%").":".line(".")<CR>:Dispatch /opt/dev/bin/dev test <C-r>x <CR>

" open pr in gh
nmap <leader>pr :Dispatch /opt/dev/bin/dev open pr<CR>

" Copy current file path
" nnoremap <silent> <leader>y :let @+=expand("%")<CR>
nnoremap <leader>y :let @+=expand("%")<CR>

" copy current file path and line number
nnoremap <leader>cfn :let @+=expand("%").":".line(".")<CR>

" Cuopy current directory, eg for searching for similar things
nnoremap <leader>ch :let @+=expand("%:p:h")<CR>

" Preview current file in Github
nnoremap <leader>gh :.Gbrowse<CR>

" Git blame current file
nnoremap <leader>gb :G blame<CR>

" Gstatus current file
nnoremap <leader>gs :Gstatus<CR>

" edit this config file
nnoremap <leader>eco :e ~/.config/nvim/init.vim<CR>
" Relative line number hybrid mode

nnoremap <Leader>g- :silent Git stash<CR>:e<CR>
nnoremap <Leader>g+ :silent Git stash pop<CR>:e<CR

" nnoremap <Leader>t :TlistToggle<CR>
nnoremap <Leader>t :tselect

" open current file in a tab
nnoremap <Leader>a :tab sp<CR>

" autocomplete end with <shift><CR>
imap <S-CR>    <CR><CR>end<Esc>-cc

set rnu
set nu

" Convenience
set nobackup noswapfile

" Splits
set splitright
set splitbelow
set fillchars=""

nnoremap <silent> <Leader>= :exe "vertical resize +30"<CR>
nnoremap <silent> <Leader>- :exe "vertical resize -30"<CR>

" Enable basic mouse useage
set mouse=a

" / Search
set ic

" color in spin
set termguicolors

" text editing
set tabstop=2 softtabstop=2 shiftwidth=2 expandtab
set textwidth=0
set nowrap
set formatoptions-=t " Auto-wrap text
set formatoptions-=c " Auto-wrap comments
set formatoptions-=l " Auto-wrap in insert mode
set scrolloff=2 " 2 line of padding when scrolling

" Remapble bash style tab completion
 set wildmenu
 set wildmode=list:longest,full

" FZF
nnoremap <C-p> :Files<CR>
" Quick comment toggling
noremap \ :Commentary<CR>

" =================================================
" Clipboard
" =================================================

" https://github.com/spf13/spf13-vim/blob/7d48f769d1c991f82beee18a7f644b4ed351e5ce/.vimrc#L73-L79
if has('clipboard')
  if has('unnamedplus') " When possible use + register for copy-paste
    set clipboard=unnamedplus
  else " On mac and Windows, use * register for copy-paste
    set clipboard=unnamed
  endif
end
