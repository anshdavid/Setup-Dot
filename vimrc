"*****************************************************************************
"" Vim-PLug core
"*****************************************************************************
let vimplug_exists=expand('~/.vim/autoload/plug.vim')

if !filereadable(vimplug_exists)
  if !executable("curl")
    echoerr "You have to install curl or first install vim-plug yourself!"
    execute "q!"
  endif
  echo "Installing Vim-Plug..."
  echo ""
  silent exec "!\curl -fLo " . vimplug_exists . " --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  let g:not_finish_vimplug = "yes"

  autocmd VimEnter * PlugInstall
endif

" Required:
call plug#begin(expand('~/.vim/plugged'))

"*****************************************************************************
"" Plug install packages
"*****************************************************************************

"tree; on-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'Xuyuanp/nerdtree-git-plugin'

"fuzzy finder
if isdirectory('/usr/local/opt/fzf')
  Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
else
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
  Plug 'junegunn/fzf.vim'
endif

"comment line
Plug 'scrooloose/nerdcommenter'

"git integration
Plug 'airblade/vim-gitgutter'

"color-scheme
Plug 'morhetz/gruvbox'

"buffer as tabs
Plug 'ap/vim-buftabline'

"kite plugin!! just incase
Plug 'kiteco/vim-plugin'

"including just for more fucntionality
Plug 'davidhalter/jedi-vim'

"tagbar
Plug 'majutsushi/tagbar'

" vim checkhealth
Plug 'rhysd/vim-healthcheck'

"bracket autopairing
"check also https://www.reddit.com/r/vim/comments/6h0dy7/which_autoclosing_plugin_do_you_use/
Plug 'jiangmiao/auto-pairs'

" autosave pluging
Plug '907th/vim-auto-save'

"coc autocomplete
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
"*****************************************************************************
"" Include user's extra bundle
"*****************************************************************************
if filereadable(expand("~/.vimrc.local.bundles"))
  source ~/.vimrc.local.bundles
endif

call plug#end()

" required
filetype plugin indent on
"*****************************************************************************"
" basic setup
"*****************************************************************************"

"" Encoding
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8

"" File formats
set fileformats=unix,dos

"" disable swap file and backup
set noswapfile
set nobackup
set nowritebackup

"" light-wrap width
set wrap tw=80 fo+=t

"" ruler + number
syntax on
"set ruler
"set relativenumber number
set number

"" line highlights
set cursorline
highlight LineNr cterm=bold ctermfg=black
highlight CursorLine cterm=bold ctermbg=grey ctermfg=NONE
highlight CursorLineNR cterm=bold ctermfg=red ctermbg=NONE

"" highlight brackets under cursor
set showmatch

"" Display hidden Gcharacters
set showbreak=↪\
set listchars=tab:→\ ,eol:↲,nbsp:␣,extends:>,precedes:<,trail:·
set list

"" Fix backspace indent
set backspace=indent,eol,start

"" Tabs. May be overridden by autocmd rules
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smarttab

"" Automatic indentation is good
set autoindent

"" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

" Spell Check
"set spell

"" Enable hidden buffers
"set hidden

"" Git Gutter always shows
set signcolumn=yes

"" highlight white space, be sure to remove trail characters in list. helps in
"" improving speed
"highlight ExtraWhitespace ctermbg=red guibg=red
"match ExtraWhitespace /\s\+$/

"Statusline
set laststatus=2
set statusline=%F\ %m\ %r%h%w\ \[%{join(GitGutterGetHunkSummary())}\]%=\[%{mode()}]\ (%{&ff}/%Y)\ (line\ %l\/%L,\ col\ %c)

"get shell
if exists('$SHELL')
    set shell=$SHELL
else
    set shell=/bin/bash
endif

"Better display for messages
set cmdheight=1
"don't give |ins-completion-menu| messages.
"set shortmess+=c
" disable messages
set shortmess+=astWAITc

"if exists("*fugitive#statusline")
  "set statusline+=%{fugitive#statusline()}
"endif

"******************************************************************************
" autocmd rule
"******************************************************************************

"" remember last cursor position
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif

"dang that bell
if has('autocmd')
  autocmd GUIEnter * set visualbell t_vb=
endif

augroup nerdtree_highlights
    autocmd!
    autocmd FileType nerdtree call s:NERDTreeHighlight()
augroup END

autocmd BufEnter * lcd %:p:h

augroup filetype_rust
    autocmd!
    autocmd BufNewFile,BufRead *.rs setlocal filetype=rust
augroup END

augroup filetype_python
    autocmd!
    autocmd BufNewFile,BufRead *.py setlocal filetype=python
        \ cinwords=if,elif,else,for,while,try,except,finally,def,class,with
augroup END

" make/cmake
augroup filetype_make_cmake
  autocmd!
  autocmd FileType make setlocal noexpandtab
  autocmd BufNewFile,BufRead CMakeLists.txt setlocal filetype=cmake
augroup END

" autogroup for save
" Allow us to use Ctrl-s and Ctrl-q as keybinds
"silent !stty -ixon
" Restore default behaviour when leaving Vim.
"autocmd VimLeave * silent !stty ixon

"******************************************************************************
" custom functions
"******************************************************************************

function! PasteForStatusline()
    let paste_status = &paste
    if paste_status == 1
        return " [paste] "
    else
        return ""
    endif
endfunction

function! s:NERDTreeHighlight()
    for l:name in keys(g:NERDTreeIndicatorMapCustom)
        let l:icon = g:NERDTreeIndicatorMapCustom[l:name]
        if empty(l:icon)
            continue
        endif
        let l:prefix = index(['Dirty', 'Clean'], l:name) > -1 ? 'Dir' : ''
        let l:hiname = escape('NERDTreeGitStatus'.l:prefix.l:name, '~')
        execute 'syntax match '.l:hiname.' #'.l:icon.'# containedin=NERDTreeFlags'
    endfor
    syntax match hideBracketsInNerdTree "\]" contained conceal containedin=NERDTreeFlags
    syntax match hideBracketsInNerdTree "\[" contained conceal containedin=NERDTreeFlags
endfunction

"******************************************************************************
"python interpreter setup
"recognize environment
"avoid if u already have a language server setup / coc.nvim[coc-python] / etc
"IMPORTANT : kite article 97-adding-libraries-from-pythonpath-to-the-kite-index
"******************************************************************************

"let g:python3_host_prog = '/home/ironwolf1990/software/anaconda3/bin/python3.7'
"let g:python_host_prog = '/home/ironwolf1990/software/anaconda3/bin/python'
let python3= system('which python3.7')
let g:python3_host_prog = substitute(python3 , '\n', '', '')

let python= system('which python')
let g:python_host_prog = substitute(python , '\n', '', '')

"*****************************************************************************"
" plugin customizations (no keymappings here!)
"*****************************************************************************"

let g:NERDTreeIndicatorMapCustom = {
    \ 'Modified':   "♲",
    \ 'Staged':     "→",
    \ 'Untracked':  "↛",
    \ 'Renamed':    "⇌",
    \ 'Unmerged':   "≠",
    \ 'Deleted':    "✖",
    \ 'Dirty':      "☒",
    \ 'Clean':      "☑",
    \ 'Ignored':    "☢",
    \ 'Unknown':    "⚠"}

let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

highlight! NERDTreeOpenable ctermfg=132 guifg=#B05E87
highlight! def link NERDTreeClosable NERDTreeOpenable

highlight! NERDTreeFile ctermfg=246 guifg=#999999
highlight! NERDTreeExecFile ctermfg=246 guifg=#999999

highlight! clear NERDTreeFlags
highlight! NERDTreeFlags ctermfg=234 guifg=#1d1f21
highlight! NERDTreeCWD ctermfg=240 guifg=#777777

highlight! NERDTreeGitStatusModified ctermfg=1 guifg=#D370A3
highlight! NERDTreeGitStatusStaged ctermfg=10 guifg=#A3D572
highlight! NERDTreeGitStatusUntracked ctermfg=12 guifg=#98CBFE
highlight! def link NERDTreeGitStatusRenamed Title
highlight! def link NERDTreeGitStatusUnmerged Label
highlight! def link NERDTreeGitStatusDirDirty Constant
highlight! def link NERDTreeGitStatusDirClean DiffAdd
highlight! def link NERDTreeGitStatusUnknown Comment

"FZF
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__
let $FZF_DEFAULT_COMMAND =  "find * -path '*/\.*' -prune -o -path 'node_modules/**' -prune -o -path 'target/**' -prune -o -path 'dist/**' -prune -o  -type f -print -o -type l -print 2> /dev/null"

let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

"vim-gitgutter
highlight GitGutterAdd cterm=bold ctermbg=green ctermfg=232
highlight GitGutterChange cterm=bold ctermbg=yellow ctermfg=232
highlight GitGutterDelete cterm=bold ctermbg=red ctermfg=232
highlight GitGutterChangeDelete ctermbg=5 ctermfg=232

"The Silver Searcher
if executable('ag')
  let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -g ""'
  set grepprg=ag\ --nogroup\ --nocolor
endif

"ripgrep
"if executable('rg')
  "let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
  "set grepprg=rg\ --vimgrep
  "command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
"endif

"gruvbox
set background=dark
colorscheme gruvbox
highlight SignColumn ctermbg=black

" COC-NVIM
"let g:coc_global_extensions = ['coc-prettier', 'coc-tsserver', 'coc-css', 'coc-json', 'coc-yaml']

"kite
let g:kite_tab_complete=1
set completeopt+=menuone   " show the popup menu even when there is only 1 match
set completeopt+=noinsert  " don't insert any text until user chooses a match
set completeopt-=longest   " don't insert the longest common text
set completeopt-=preview   " preview window up top!
"set statusline+=%{kite#statusline()}

let g:kite_documentation_continual=1
autocmd CompleteDone * if !pumvisible() | pclose | endif
set belloff+=ctrlg  " if vim beeps during completion

"jedi here
let g:jedi#auto_initialization = 1
let g:jedi#popup_on_dot = 0
let g:jedi#popup_select_first = 0
let g:jedi#completions_enabled = 0
let g:pymode_rope = 0

" autosave here
let g:auto_save = 1  " enable AutoSave on Vim startup
let g:auto_save_events = ["InsertLeave", "TextChanged"]
let g:auto_save_write_all_buffers = 1
let g:auto_save_silent = 1
"Smaller updatetime for CursorHold & CursorHoldI
set updatetime=4000

"*****************************************************************************
" Mappings
"
":map   :noremap  :unmap     Normal, Visual, Select, Operator-pending
":nmap  :nnoremap :nunmap    Normal
":vmap  :vnoremap :vunmap    Visual and Select
":smap  :snoremap :sunmap    Select
":xmap  :xnoremap :xunmap    Visual
":omap  :onoremap :ounmap    Operator-pending
":map!  :noremap! :unmap!    Insert and Command-line
":imap  :inoremap :iunmap    Insert
":lmap  :lnoremap :lunmap    Insert, Command-line, Lang-Arg
":cmap  :cnoremap :cunmap    Command-line
"*****************************************************************************

" Map leader to ,
let mapleader=','

" disable arrow keys
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
noremap <Up> <Nop>

"" disable arrow keys in insert mode!!!
"noremap! <Down> <Nop>
"noremap! <Left> <Nop>
"noremap! <Right> <Nop>
"noremap! <Up> <Nop>

"" quickly cancel search highlighting
nnoremap <leader><space> :nohlsearch<cr>

"" better vertial movement for wrapped lines
nnoremap j gj
nnoremap k gk

"" no one is really happy until you have this shortcuts
cmap W! w!
cmap Q! q!
cmap Qall! qall!
cmap Wq wq
cmap Wa wa
cmap wQ wq
cmap WQ wq
cmap W w
cmap Q q
cmap Qall qall

"" Replace <Esc> with C-c
"inoremap <C-s> <Esc>
"nnoremap <C-s> :w!<cr>
noremap <C-z> :so%<cr>

" Split
noremap <Leader>h :<C-u>split<CR>
noremap <Leader>v :<C-u>vsplit<CR>

"Opens an edit command with the path of the currently edited file filled in
noremap <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

"Opens a tab edit command with the path of the currently edited file filled
noremap <Leader>te :tabe <C-R>=expand("%:p:h") . "/" <CR>

"Switching windows
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap <C-h> <C-w>h

"Vmap for maintain Visual Mode after shifting > and <
vmap < <gv
vmap > >gv

"NERDTREE
nnoremap <silent> <C-a> :NERDTreeToggle<CR>

"Search mappings: These will make it so that going to the next search will
"centre in on the line
nnoremap n nzzzv
nnoremap N Nzzzv

"map fuzzyfinder
nnoremap <C-f> :FZF<CR>
"map silver-searcher
nnoremap <leader>f :Ag<CR>

" Buffer nav
noremap <leader>z :bp<CR>
noremap <leader>x :bn<CR>
" Close buffer
noremap <silent> <leader>c :bprevious<bar>split<bar>bnext<bar>bdelete<CR>

" TAgbar Toggle
nmap <silent> <C-q> :TagbarToggle<CR>

"jedi here
"let g:jedi#goto_command = <leader>d
let g:jedi#goto_assignments_command = "<leader>g"
let g:jedi#goto_stubs_command = "<leader>s"
let g:jedi#goto_definitions_command = "<leader>d"
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<leader>n"
"let g:jedi#completions_command = "<C-Space>"
let g:jedi#rename_command = "<leader>r"
