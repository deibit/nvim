" ============= Vim-Plug ============== "{{{

" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin(expand('~/.config/nvim/plugged'))

"}}}

" ================= looks and GUI stuff ================== "{{{

Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'glepnir/galaxyline.nvim' , {'branch': 'main'}
Plug 'neovim/nvim-lspconfig'

Plug 'nvim-lua/completion-nvim'
Plug 'steelsojka/completion-buffers'

Plug 'kyazdani42/nvim-web-devicons'
Plug 'luochen1990/rainbow'                              " rainbow parenthesis
Plug 'hzchirs/vim-material'                             " material color themes
Plug 'morhetz/gruvbox'
Plug 'gregsexton/MatchTag'                              " highlight matching html tags
Plug 'kyazdani42/nvim-tree.lua'
Plug 'deibit/atlas.vim'
"}}}

" ================= Functionalities ================= "{{{

" Plug 'Yggdroot/indentLine'                              " show indentation lines
Plug 'tpope/vim-commentary'                             " better commenting
Plug 'tpope/vim-fugitive'                               " git support
Plug 'wellle/tmux-complete.vim'                         " complete words from a tmux panes
Plug 'tpope/vim-eunuch'                                 " run common Unix commands inside Vim
Plug 'machakann/vim-sandwich'                           " make sandwiches
Plug 'christoomey/vim-tmux-navigator'                   " seamless vim and tmux navigation
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
call plug#end()

"}}}

" ==================== general config ======================== "{{{

set termguicolors                                       " Opaque Background
set mouse=a                                             " enable mouse scrolling
set clipboard+=unnamedplus                              " use system clipboard by default
set tabstop=4 softtabstop=4 shiftwidth=4 autoindent     " tab width
set expandtab smarttab                                  " tab key actions
set incsearch ignorecase smartcase hlsearch             " highlight text while searching
set list listchars=trail:»,tab:»-                       " use tab to navigate in list mode
set fillchars+=vert:\▏                                  " requires a patched nerd font (try FiraCode)
set wrap breakindent                                    " wrap long lines to the width set by tw
set encoding=utf-8                                      " text encoding
set number                                              " enable numbers on the left
set title                                               " tab title as file name
set noshowmode                                          " dont show current mode below statusline
set noshowcmd                                           " to get rid of display of last command
set cmdheight=2
set conceallevel=2                                      " set this so we wont break indentation plugin
set splitright                                          " open vertical split to the right
set splitbelow                                          " open horizontal split to the bottom
set tw=90                                               " auto wrap lines that are longer than that
set emoji                                               " enable emojis
set history=1000                                        " history limit
set backspace=indent,eol,start                          " sensible backspacing
set undofile                                            " enable persistent undo
" set undodir=/tmp                                        " undo temp file directory
set foldlevel=0                                         " open all folds by default
" set foldmethod=marker
set inccommand=nosplit                                  " visual feedback while substituting
set showtabline=2                                       " always show tabline
set grepprg=rg\ --vimgrep                               " use rg as default grepper
set shortmess=I                                         " disable intro message

" performance tweaks
set cursorline
set nocursorcolumn
set scrolljump=5
set lazyredraw
set redrawtime=10000
set synmaxcol=180
set re=1

set hidden
set nobackup
set nowritebackup
set updatetime=300
set shortmess+=c
set signcolumn=yes

" Theme
let g:material_style = 'dark'
let g:atlas_bold=1
colorscheme atlas

"}}}

" ======================== Plugin Configurations ======================== "{{{

"" built in plugins
let loaded_netrw = 0                                    " disable netew
let g:omni_sql_no_default_maps = 1                      " disable sql omni completion
let g:loaded_python_provider = 0
let g:loaded_perl_provider = 0
let g:loaded_ruby_provider = 0
let g:python3_host_prog = expand('/usr/bin/python3')

" Vim-go
let g:go_code_completion_enabled = 0

" indentLine
let g:indentLine_char_list = ['▏', '¦', '┆', '┊']
let g:indentLine_setColors = 0
let g:indentLine_setConceal = 0                         " actually fix the annoying markdown links conversion

" rainbow brackets
let g:rainbow_active = 1

" tmux navigator
let g:tmux_navigator_no_mappings = 1

" completion-nvim
autocmd BufEnter * lua require'completion'.on_attach()
" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
set completeopt=menuone,noinsert,noselect
set shortmess+=c
imap <tab> <Plug>(completion_smart_tab)
imap <s-tab> <Plug>(completion_smart_s_tab)
let g:completion_chain_complete_list = [
    \{'complete_items': ['lsp', 'buffers', 'path']},
\]


"}}}

" ======================== Commands ============================= "{{{

au BufEnter * set fo-=c fo-=r fo-=o                     " stop annoying auto commenting on new lines
au FileType help wincmd L                               " open help in vertical split
au BufWritePre * :%s/\s\+$//e                           " remove trailing whitespaces before saving

" enable spell only if file type is normal text
let spellable = ['markdown', 'gitcommit', 'txt', 'text', 'liquid', 'rst']
autocmd BufEnter * if index(spellable, &ft) < 0 | set nospell | else | set spell | endif

" fzf if passed argument is a folder
augroup folderarg
    " change working directory to passed directory
    autocmd VimEnter * if argc() != 0 && isdirectory(argv()[0]) | execute 'cd' fnameescape(argv()[0])  | endif
    " start fzf on passed directory
    autocmd VimEnter * if argc() != 0 && isdirectory(argv()[0]) | execute 'Files ' fnameescape(argv()[0]) | endif
augroup END

" Return to last edit position when opening files
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

" advanced grep
command! -nargs=* -bang Rg call RipgrepFzf(<q-args>, <bang>0)

"}}}

" ======================== Custom Mappings ====================== "{{{

"" the essentials
let mapleader=","
nmap \ <leader>q
nnoremap <space> /
nmap <leader>E :so ~/.config/nvim/init.vim<CR>
nmap <leader>e :e ~/.config/nvim/init.vim<CR>
nmap <leader>q :bd<CR>
nmap <leader>w :w<CR>
map <leader>s :Format<CR>
nmap <Tab> :bnext<CR>
nmap <S-Tab> :bprevious<CR>
noremap <C-q> :q<CR>
" Window splits
nnoremap <leader>" :vsplit<CR>
nnoremap <leader>% :split<CR>
" Move between panes
nnoremap <c-left> <c-w>h
nnoremap <c-down> <c-w>j
nnoremap <c-up> <c-w>k
nnoremap <c-right> <c-w>l
" Redo
nnoremap U <c-r>
" Close pane
nnoremap <leader>x <c-w>c

" new line in normal mode and back
map <Enter> o<ESC>
map <S-Enter> O<ESC>

" use a different register for delete and paste
nnoremap d "_d
vnoremap d "_d
vnoremap p "_dP
nnoremap x "_x

" emulate windows copy, cut behavior
vnoremap <LeftRelease> "+y<LeftRelease>
vnoremap <C-c> "+y<CR>
vnoremap <C-x> "+d<CR>

" disable hl with 2 esc
noremap <silent><esc> <esc>:noh<CR><esc>

" trim white spaces
nnoremap <F2> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

" fugitive mappings
nmap <leader>gd :Gdiffsplit<CR>
nmap <leader>gb :Git blame<CR>

" tmux navigator
nnoremap <silent> <C-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <C-j> :TmuxNavigateDown<cr>
nnoremap <silent> <C-k> :TmuxNavigateUp<cr>

" Telescope
nnoremap <leader>F <cmd>Telescope file_browser<cr>
nnoremap <leader>M <cmd>Telescope marks<cr>
nnoremap <leader>b <cmd>Telescope buffers<cr>
nnoremap <leader>c <cmd>Telescope commands<cr>
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fd <cmd>Telescope fd<cr>
nnoremap <leader>h <cmd>Telescope help_tags<cr>
nnoremap <leader>k <cmd>Telescope man_pages<cr>
nnoremap <leader>l <cmd>Telescope live_grep<cr>
nnoremap <leader>L <cmd>Telescope current_buffer_fuzzy_find<cr>
nnoremap <leader>m <cmd>Telescope keymaps<cr>
nnoremap <leader>gc <cmd>Telescope git_commits<cr>
nnoremap <leader>gb <cmd>Telescope git_bcommits<cr>

" nvimlsp
nnoremap <silent><leader>K <cmd>lua vim.lsp.buf.hover()<cr>
nnoremap <silent><leader>d <cmd>lua vim.lsp.buf.type_definition()<cr>
nnoremap <silent>gd <cmd>lua vim.lsp.buf.definition()<cr>
nnoremap <silent>gD <cmd>lua vim.lsp.buf.declaration()<cr>
nnoremap <silent>gr <cmd>lua vim.lsp.buf.references()<cr>
nnoremap <silent>gi <cmd>lua vim.lsp.buf.implementation()<cr>
nnoremap <silent>gx <cmd>lua vim.lsp.buf.lsp_workspace_diagnostics()<cr>

" nvim-tree
nnoremap <leader>t :NvimTreeToggle<CR>

"}}}

lua << EOF
require'lspconfig'.clangd.setup{}
require'lspconfig'.gopls.setup{}
require("galaxylineconfig")
EOF




