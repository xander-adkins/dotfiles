" Maintainer:	Alexander Adkins <http://alexanderadkins.com>
" Version:	2.0
" Path:	".dotfiles/nvim/init.vim"
" Github:	"https://github.com/xander-adkins/dotfiles"


" ----------------------------------------------------------------------------
" System
" ----------------------------------------------------------------------------

" Required
filetype off

" Be iMproved, required
set nocompatible

" Backspace control
set backspace=2

" Allow backspacing over everything in insert mode
set bs=indent,eol,start

" Mapping delays and key code delays
set timeoutlen=1000 ttimeoutlen=0

" Centralize backups, swapfiles and undo history
set backupdir=~/.nvim/backups
set directory=~/.nvim/swaps
set undodir=~/.nvim/undo " set undotree file directory
set undofile " set undotree to save to file

" Remember info about open buffers on close
set viminfo^=%

" Use the OS clipboard by default (on versions compiled with `+clipboard`)
set clipboard=unnamed

" Don’t show the intro message when starting Vim
set shortmess=atI

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic


" ----------------------------------------------------------------------------
" vim-plug
" ----------------------------------------------------------------------------
" Basic Plug Commands
" :PlugInstall – install the plugins
" :PlugUpdate – update the plugins
" :PlugClean – remove unused plugins

" Plugins will be downloaded under the specified directory.
call plug#begin(stdpath('data') . './plugged')

	" Declare the list of plugins.

	" System
	Plug 'christoomey/vim-tmux-navigator' "Seamless navigation between tmux panes and vim splits
	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } "A command-line fuzzy finder
	Plug 'junegunn/fzf.vim' "fzf for vim
	Plug 'scrooloose/nerdtree'  "A tree explorer plugin

	" Syntax & Highlighting
	Plug 'neoclide/coc.nvim', {'branch': 'release'} "Load extensions like VSCode and host language servers.
	Plug 'sheerun/vim-polyglot' "A solid language pack for Vim.

	" Linting & Formatting

	" Utilities
	Plug 'airblade/vim-gitgutter' "A Vim plugin which shows a git diff in the gutter
	Plug 'jiangmiao/auto-pairs' "Vim plugin, insert or delete brackets, parens, quotes in pair
	Plug 'junegunn/goyo.vim' "Distraction-free writing in Vim.
	Plug 'mbbill/undotree' "The undo history visualizer for VIM
	Plug 'tpope/vim-commentary' "Comment stuff out
	Plug 'tpope/vim-repeat' "Enable repeating supported plugin maps with '.'
	Plug 'tpope/vim-surround' "Quoting/parenthesizing made simple
	" Plug 'godlygeek/tabular' "Vim script for text filtering and alignment
	" Plug 'plasticboy/vim-markdown' "Markdown Vim Mode

	" Theming
	Plug 'flazz/vim-colorschemes' "One colour scheme pack to rule them all!
	Plug 'vim-airline/vim-airline' "Lean & mean status/tabline
	Plug 'vim-airline/vim-airline-themes' "A collection of themes for vim-airline

" List ends here. Plugins become visible to Vim after this call.
call plug#end()


" ----------------------------------------------------------------------------
" Formatting
" ----------------------------------------------------------------------------

" Tab control
set shiftwidth=4 " Number of spaces to use for indent and unindent
set softtabstop=4 " Edit as if the tabs are 4 characters wide
set tabstop=4 " The visible width of tabs

" Indentation control
set smartindent

" Automatically set indent of new line
set autoindent

" Don’t add empty newlines at the end of files
set binary
set noeol

" Start scrolling three lines before the horizontal window border
set scrolloff=8

" Wrap comment lines
set formatoptions-=t


" ----------------------------------------------------------------------------
" User Interface
" ----------------------------------------------------------------------------

" Vim Theme
colorscheme hemisu

" Show line numbers
set nu

" Make numbers sequential
set norelativenumber

" Allow for five characters in margin
set numberwidth=5


" ----------------------------------------------------------------------------
" Functions
" ----------------------------------------------------------------------------

" Visually select text then press ~ to convert the text to UPPER CASE, then to lower case, then to Title Case
function! TwiddleCase(str)
	if a:str ==# toupper(a:str)
		let result = tolower(a:str)
	elseif a:str ==# tolower(a:str)
		let result = substitute(a:str,'\(\<\w\+\>\)', '\u\1', 'g')
	else
		let result = toupper(a:str)
	endif
	return result
endfunction

" Automatically opens Goyo for all markdown files
function! s:auto_goyo()
  if &ft == 'markdown'
    Goyo 80
  elseif exists('#goyo')
    let bufnr = bufnr('%')
    Goyo!
    execute 'b '.bufnr
  endif
endfunction

" Markdown mapping for check-boxes
function Check()
    let l:line=getline('.')
    let l:curs=winsaveview()
    if l:line=~?'\s*-\s*\[\s*\].*'
        s/\[\s*\]/[.]/
    elseif l:line=~?'\s*-\s*\[\.\].*'
        s/\[.\]/[x]/
    elseif l:line=~?'\s*-\s*\[x\].*'
        s/\[x\]/[ ]/
    endif
    call winrestview(l:curs)
endfunction


" ----------------------------------------------------------------------------
" Mappings
" ----------------------------------------------------------------------------

" Assign the default map leader or <leader>
" Free keys are '-', 'H', 'L', '<space>', '<cr>', and '<bs>'
" Our <leader> will be the '<space>' key
let mapleader=" "

" Our <localleader> will be the '<space>' key
let maplocalleader=" "

"Remap Esc Key for easier access
inoremap jk <esc>

" Edit my vimrc file
nnoremap <leader>ev :vsplit ~/.dotfiles/nvim/init.vim<cr>

" Source my vimrc file
nnoremap <leader>sv :source $MYVIMRC<cr>

" Quicker window movement
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" This makes j and k work on 'screen lines' instead of on 'file lines'
nnoremap j gj
nnoremap k gk

" Make ',' select word in normal mode
nnoremap , viw

" Make 'vv' select entire line by rolling Shift-H Shift-L
nnoremap <S-H><S-L> 0v$

" Use tab to jump between blocks, because it's easier
nnoremap <tab> %
vnoremap <tab> %

" Jump cursor to start of line
nnoremap H 0

" Jump cursor to end of line
nnoremap  L $

" Move current line up
nnoremap  <leader>k ddkP

" Move current line down
nnoremap  <leader>j ddp

" Change Windows
noremap <C-h> <C-W>L<cr>

" Select-all (don't need confusing increment C-a)
noremap  <leader>a gg0vG$

" Quickly write/close windows
nnoremap <leader>w :w<cr>
nnoremap <leader>W :w!<cr>
nnoremap <leader>q :q<cr>
nnoremap <leader>Q :q!<cr>

" Substitute all occurrences of the word under cursor
nnoremap <leader>fr :%s/\<<C-r><C-w>\>//g<Left><Left>

" Remove search highlight with esc key
nnoremap <esc> :noh<return><esc>

" Don't re-write register during copy paste
xnoremap p pgvy

" Sort selection alphabetically
vmap <leader>o :'<,'>sort u<cr>

" qq to record, Q to replay
nnoremap Q @q

" Toggle spelling
nnoremap  <Leader>s <C-o>:setlocal spell! spelllang=en_gb<CR>
nnoremap <Leader>s :setlocal spell! spelllang=en_gb<CR>

" Launch Spell Check Correction Options Dialogue
nnoremap ? z=

" Shortcut to open NERDTree
noremap <leader>n :NERDTreeToggle<CR>

" Map show undo tree
nnoremap <leader>u :UndotreeShow<CR>

" Rerender the Vim window to fix glitched characters
nnoremap <leader>0 :redraw!<CR>

" Visually select text then press ~ to convert the text to UPPER CASE, then to lower case, then to Title Case
vnoremap <leader>cc y:call setreg('', TwiddleCase(@"), getregtype(''))<CR>gv""Pgv

" Insert timestamp at the end of the line in this format: 20200527T113245
nnoremap <leader>ts m'A<C-R>=strftime('%Y%m%dT%H%M%S')<CR>

" I typo this enough to be worthwhile aliasing it
command! W :write


" ----------------------------------------------------------------------------
" Autocommands
" ----------------------------------------------------------------------------

" tpope/vim-commentary
autocmd FileType apache setlocal commentstring=#\ %s

" Close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Return to last edit position when opening files
augroup last_edit
  autocmd!
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
augroup END

" Source the vimrc file after saving it
augroup sourcing
  autocmd!
  if has('nvim')
    autocmd bufwritepost init.vim source $MYVIMRC
  else
    autocmd bufwritepost .vimrc source $MYVIMRC
  endif
augroup END

" Treat all .md files as markdown
autocmd BufNewFile,BufRead *.md set filetype=markdown

" Automatically opens Goyo for all markdown files
augroup goyo_markdown
  autocmd!
  autocmd BufNewFile,BufRead * call s:auto_goyo()
augroup END

" Markdown mapping for check-boxes
autocmd FileType markdown nnoremap <silent> - :call Check()<CR>

" Set spell check to the Queen's English
" autocmd FileType markdown setlocal spell spelllang=en_gb

" Hide plaintext formatting
autocmd FileType markdown set conceallevel=2

" Set linebreak for markdown files
autocmd FileType markdown set linebreak

" Disable cursor line and column highlight
autocmd FileType markdown set nocursorline
autocmd FileType markdown set nocursorcolumn


" ----------------------------------------------------------------------------
" Plugin settings
" ----------------------------------------------------------------------------

" scrooloose/nerdtree
" Open/Close selected node with 'l' & 'h' or default '<enter>'
let NERDTreeMapActivateNode = 'l'
" Automatically close NERDTree after openning file
let NERDTreeQuitOnOpen = 1
" Show hidden files by default
let NERDTreeShowHidden = 1
" Use minimal UI
let NERDTreeMinimalUI = 1
" Change arrow icons
let NERDTreeDirArrows = 1
" Set window size
let g:NERDTreeWinSize = 30
" Automatically remove a buffer when a file is being deleted or renamed
let NERDTreeAutoDeleteBuffer = 1
" Collapses on the same line directories that have only one child directory
let NERDTreeCascadeSingleChildDir = 0

" vim-airline/vim-airline-themes
let g:airline_theme='minimalist'


" ----------------------------------------------------------------------------
" CoC Vim Configuration
" ----------------------------------------------------------------------------
" Declare CoC extensions
let g:coc_global_extensions = [
  \ 'coc-css',
  \ 'coc-eslint',
  \ 'coc-json',
  \ 'coc-pairs',
  \ 'coc-prettier',
  \ 'coc-tsserver'
  \ ]

" Prettier command for CoC
command! -nargs=0 Prettier :CocCommand prettier.formatFile

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" remap keys for applying codeaction to the current buffer.
nmap <leader>ac  <plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)