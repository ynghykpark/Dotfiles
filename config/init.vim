call plug#begin('~/.local/share/nvim/plugged')
    Plug 'benmills/vimux' "vimux makes vim control tmux pane
    Plug 'christoomey/vim-tmux-navigator' "Navigate tmux and vim seamlessly
    Plug 'ddollar/nerdcommenter' "you don't need to memorize which char is a comment
    Plug 'duff/vim-trailing-whitespace' "Erase trailing whitespace automatically.
    Plug 'machakann/vim-highlightedyank' "highlight yank.
    Plug 'sheerun/vim-polyglot' "For better syntax highlight!
    Plug 'simeji/winresizer' "Easy resizing of vim panes
    Plug 'morhetz/gruvbox'
    Plug 'junegunn/seoul256.vim'
    " Languagre Server Protocol and Auto completion
    Plug 'prabirshrestha/vim-lsp'
    Plug 'prabirshrestha/asyncomplete.vim'
    Plug 'prabirshrestha/asyncomplete-lsp.vim'
call plug#end()

set expandtab " only use space
set tabstop=4 " the visible width of tabs
set shiftwidth=4 " number of spaces to use for indent and unindent
set softtabstop=4 " the width of indentation produced by the 'tab' key
set autoindent
set nosmarttab " tab respects 'tabstop', 'shiftwidth', and 'softtabstop'
set shiftround " round indent to a multiple of 'shiftwidth'
set number " show line number
set relativenumber " show line number with relative number
set numberwidth=2
set wrap " turn on line wrapping
set wrapmargin=8 "wrap lines when coming within n characters from side
set linebreak " set soft wrapping
set showbreak=… " show ellipis at breaking
set showmatch " show matching braces
set matchtime=5
set laststatus=0 " do not show the status line all the time
set statusline=%f
set showtabline=2
set tabline=%!TabLine()
set lazyredraw " don't redraw while executing macros
set cmdheight=1 " command bar height
set showcmd "show incomplete commands
set nolist
set listchars=tab:→\ ,eol:¬,trail:⋅,extends:❯,precedes:❮
set showbreak=↪
set cursorline
set nohlsearch " highlight search results
set incsearch " set incremental search, like modern browsers
set ignorecase " case insensitive searching
set smartcase " case-sensitive if expression contains a capital letter
set autoread " detect when a file is changed
set autowrite
set history=1000
set backspace=indent,eol,start " make backspace behave in a sane manner
set clipboard=unnamed "Share clipboard with os
set hidden "current buffer can be put into background
set shell=$SHELL "set shell for vim as default bash
set title " set terminal title
set mat=2 " how many tenths of a second to blink
set updatetime=300 "update swap if nothing is written in 0.3 second
set encoding=utf-8
set noswapfile
set magic
set splitbelow
set splitright
set undofile "undo function after reopening
set undodir=/tmp
set mouse=a
set scrolljump=-15
set wildmode=list:longest,full
"Disable automatic comment
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
filetype plugin indent on
syntax on

" Mapping
let mapleader = " "
nnoremap <silent> <leader><space> :silent w<cr>
nnoremap <silent> <leader>b :ls<cr>:b<space>
nnoremap <silent> <leader>hs :setlocal hlsearch!<cr>
nnoremap <silent> <leader>l :set list!<cr>
nnoremap <silent> <leader>n :set number! norelativenumber!<cr>
nnoremap j gj
nnoremap k gk
inoremap <C-u> <esc>vbUea

" python specific option
augroup filetype_python
autocmd!
autocmd FileType python nnoremap <buffer> <leader>mk
            \ :call VimuxRunCommand("clear;python3 " . expand("%"))<cr>
autocmd FileType python nnoremap <buffer> <leader>mi
            \ :call VimuxRunCommand("clear;python3 -i " . expand("%"))<cr>
autocmd FileType python nnoremap <buffer> <leader>mc
            \ :call VimuxRunCommand("clear;python3 -m pdb -c continue " . expand("%"))<cr>
autocmd FileType python nnoremap <buffer> <leader>p :call InsertLine()<cr>

if executable('pyls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'whitelist': ['python'],
        \ })
endif

set completeopt=noinsert,menuone,noselect
augroup END

" Vimux
let g:VimuxHeight="20"
let g:VimuxOrientation="v"
let g:VimuxUseNearest = 1
let g:VimuxResetSequence = "q C-u"
let g:VimuxPromptString = "Command? "
let g:VimuxRunnerType = "pane"
map <Leader>vp :VimuxPromptCommand<CR>

" Colorscheme
if filereadable(expand("~/.local/share/nvim/plugged/gruvbox/colors/gruvbox.vim"))
    colorscheme seoul256
    highlight Normal         cterm=none    ctermbg=none    ctermfg=253
    highlight Pmenu          cterm=none    ctermbg=237     ctermfg=253
    highlight PmenuSel       cterm=none    ctermbg=gray    ctermfg=253
    highlight PmenuSbar      cterm=none    ctermbg=gray    ctermfg=gray
    highlight PmenuThumb     cterm=none    ctermbg=gray    ctermfg=gray
    highlight MatchParen     cterm=none    ctermbg=green   ctermfg=black
    highlight LineNr         cterm=none    ctermbg=none    ctermfg=black
    highlight CursorLine     cterm=none    ctermbg=237
    highlight CursorLineNr   cterm=none    ctermbg=237
    highlight VertSplit      cterm=none    ctermbg=237      ctermfg=237
    highlight StatusLine     cterm=none    ctermbg=none     ctermfg=none
    highlight StatusLineNC   cterm=none    ctermbg=none     ctermfg=none
    highlight TabLineFill    cterm=none    ctermbg=237      ctermfg=none
    highlight TabLine        cterm=none    ctermbg=237      ctermfg=black
    highlight TabLineSel     cterm=none    ctermbg=237      ctermfg=253
endif

" Whitespace
nnoremap <silent> <leader>f :FixWhitespace<cr>

" LSP
" let g:lsp_preview_keep_focus=0
" let g:asyncomplete_auto_popup=0
let g:lsp_diagnostics_enabled = 0         " disable diagnostics support
let g:lsp_highlight_references_enabled = 0

" Functions
function TabLine()
    let s = ''
    for i in range(tabpagenr('$'))
        if i + 1 == tabpagenr()
            let s .= '%#TabLineSel#'
        else
            let s .= '%#TabLine#'
        endif
	    let s .= ' %{TabLabel(' . (i + 1) . ')} '
    endfor
    let s .= '%#TabLineFill#%T'
    return s
endfunction

function TabLabel(n)
    let buf = tabpagebuflist(a:n)[tabpagewinnr(a:n) - 1]
    let s = ''
    if getbufinfo(buf)[0].changed
        let s .= '✚'
    endif
    let s .= fnamemodify(bufname(buf), ":t")
    return s
endfunction

function! InsertLine()
    let trace = expand("import pdb; pdb.set_trace()")
    execute "normal o".trace
endfunction
