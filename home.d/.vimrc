" ~/.vimrc file

" Environment {{{
  if &compatible
  " Normally we use vim-extensions. If you want true vi-compatibility
  " remove the following line
    set nocompatible  " Be iMproved, required
  endif

  " If using a dark background within the editing area and syntax
  " highlighting turn on this option as well
  set background=dark

  set history=50      " keep 50 lines of command history
  set mouse=v         " use mouse in visual mode
  "set mouse=a         " Enable mouse usage (all modes: normal,insert,command,help mode)
  "set autowrite       " Automatically save before commands like :next and :make

  set timeout          " time out for mappings
  set timeoutlen=1000  " wait up to 1000ms after <mapleader>
  set ttimeout         " time out for key codes
  set ttimeoutlen=1000 " wait up to 1000ms after Esc for special key

  " modelines have historically been a source of security/resource
  " vulnerabilities -- disable by default, even when 'nocompatible' is set
  set nomodeline

  " disable warning when editing file in read-only mode
  set noreadonly

  " Linebreak on 500 characters
  set linebreak
  set textwidth=500

  "set autoread # reload file changed outside
  " This makes vim act like all other editors, buffers can
  " exist in the background without being in a window.
  " http://items.sjbach.com/319/configuring-vim-right
  set hidden          " remember undo after quitting

  " Turn off swap files since most stuff is in SVN, git et.c anyway...
  set noswapfile
  set nobackup
  set nowritebackup

  " system settings
  set lazyredraw           " no redraws in macros (good performance config)
  "set confirm              " get a dialog when :q, :w, or :wq fails
  " remember copy registers after quitting in the .viminfo file -- 20
  " jump links, regs up to 500 lines'
  "set viminfo='20,\"500
  set guicursor=a:blinkon0 " Disable cursor blink
  " No annoying sound on errors
  set noendofline
  set noerrorbells novisualbell t_vb=

" }}}

" Encoding {{{
  set encoding=utf-8
  set ttyfast
  set fileformat=unix       " file mode is unix
  "set fileformats=unix,dos  " only detect unix file format, displays that ^M with dos files
" }}}

" Vim UI {{{
  "set number                                            " Show line numbers
  "set cursorline                                        " highlight current line
  set cmdheight=2                                       " Height of the command bar
  set showmode                                          " Show mode: normal,insert,command,help mode
  set title                                             " Show file in titlebar
  if has("cmdline_info")
    set ruler                                           " Always show current position in status bar
    "set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " a ruler on steroids
    set showcmd                                         " Show (partial) command in the last line of the screen
  endif

  hi User1 ctermbg=Brown     ctermfg=White
  hi User2 ctermbg=Red       ctermfg=DarkRed
  hi User3 ctermbg=Blue      ctermfg=White
  hi User4 ctermbg=White     ctermfg=DarkMagenta
  hi User5 ctermbg=Green     ctermfg=DarkRed
  hi User6 ctermbg=White     ctermfg=Black
  hi User7 ctermbg=Green     ctermfg=Red
  hi User8 ctermbg=Cyan      ctermfg=LightRed
  hi User9 ctermbg=Magenta   ctermfg=Yellow
  hi User0 ctermbg=LightGray ctermfg=White

  if has("statusline")
    set laststatus=2   " use 2 lines for the status bar
    " Format the status line
    set statusline=
    set statusline+=%1*\[%n]                              " buffer number
    set statusline+=%1*\ %<%F\                            " Filepath
    set statusline+=%6*\ %{(&fenc!=''?&fenc:&enc)}\       " encoding
    set statusline+=%3*\ %y[%{&ff}]                       " filetype, file format (dos/unix..)
    set statusline+=%3*%m%r%w%h\                          " Options: modified,readonly,help buffer,Preview window flag
    set statusline+=%4*\ %{&paste?'[paste]':'[nopaste]'}\ " warning if paste is set
    set statusline+=%5*%=                                 " switch to the right side
    set statusline+=%5*\ Line:\ %4l/%L\                   " current line/total lines (%)
    set statusline+=%6*\ Column:\ %-4v                    " column number
  endif

  " Show as much as possible of the last line in the window rather
  " than a column of "@", which is the default behavior.
  set display+=lastline
  " Configure backspace so it acts as it should act
  set backspace=indent,eol,start " Allow backspacing over everything in insert mode
  set whichwrap=b,s,h,l,<,>,[,]  " backspace and cursor keys wrap to

  " Search for selected text, forwards or backwards.
  " NOTE:
  "     <C-R>/ is the contents of the last search pattern
  "            (see http://vimdoc.sourceforge.net/htmldoc/cmdline.html#c_CTRL-R)
  vnoremap <silent> * :<C-U>call GetVisualSelectedText('/')<CR>/<C-R>/<CR>
  vnoremap <silent> # :<C-U>call GetVisualSelectedText('?')<CR>?<C-R>/<CR>
" }}}

" Color settings (if terminal/gui supports it) {{{
  " Switch syntax highlighting on when the terminal has colors or when using the
  " GUI (which always has colors).
  if &t_Co > 2 || has("gui_running")
    syntax enable      " enable syntax highlighting

    " I like highlighting strings inside C comments.
    " Revert with ":unlet c_comment_strings".
    "let c_comment_strings=1
  endif

  " For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries.
  if has('win32')
    set guioptions-=t
  endif
" }}}

" Indentation {{{
  set nowrap           " don't wrap lines
  set autoindent       " indent at the same level of the previous line
  set smartindent      " smart auto indenting
  set smarttab         " smart tab handling for indenting
  set shiftwidth=2     " operation >> indents 2 columns; << unindents 2 columns
  set softtabstop=2    " insert/delete 2 spaces when hitting a TAB/BACKSPACE
  set tabstop=2        " a hard TAB displays as 2 columns
  set expandtab        " insert spaces when hitting TABs

  set pastetoggle=<F3> " paste mode to avoid autoindent
" }}}

" Automatic commands {{{
  " Only do this part when compiled with support for auto-commands.
  if has("autocmd")
    " Load indentation rules and
    " plugins according to the detected filetype.
    filetype indent on
    filetype plugin on

    " Jump to the last position when reopening a file
    "autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

    " remove whitespaces on save
    autocmd BufWritePre *.php,*.md,*.vim,*.txt,*.js,*.py,*.sh,*.c,*.cpp,*.h,*.hpp,*.java,*.sh :call TrimTrailingWhiteSpace()
    " Disable visualbell
    autocmd GUIEnter * set visualbell t_vb=

    " But do wrap on these types of files...
    autocmd FileType java setlocal noexpandtab listchars=tab:+\ ,eol:-
    autocmd FileType html setlocal wrap
    autocmd BufEnter Makefile setlocal noexpandtab shiftwidth=4
    autocmd BufNewFile,BufRead CMakeLists.txt setlocal filetype=cmake
    autocmd FileType markdown setlocal wrap
    autocmd FileType php setlocal listchars=tab:+\ ,eol:-
    autocmd FileType python setlocal wrap formatoptions+=croq tabstop=4 softtabstop=4 shiftwidth=4 textwidth=79
    autocmd FileType perl setlocal wrap
    autocmd FileType ruby setlocal wrap
    autocmd FileType vim setlocal foldenable foldmethod=marker foldlevel=0 modelines=1
    autocmd FileType xml setlocal noexpandtab shiftwidth=4
  endif
" }}}

" Syntax highlight
" Default highlight is better than polyglot
"let g:polyglot_disabled = ['python']
"let python_highlight_all = 1

" Folds {{{
  set nofoldenable        " dont fold by default
  if &foldenable
    set foldmethod=indent " fold based on indent
    set foldnestmax=3     " deepest fold is 3 levels
    " Add a bit extra margin to the left
    "set foldcolumn=1
    " space open/closes folds
    nnoremap <space> za
  endif
" }}}

" Completion {{{
  set wildmode=list:longest
  set wildmenu            " enable ctrl-n and ctrl-p to scroll thru matches
  " Ignore compiled files
  set wildignore=*.o,*.obj,*.bak,*.exe,*.py[co],*.swp,*~,.svn
" }}}

" Scrolling {{{
  " 7 lines to the cursor - when moving using j/k
  set scrolloff=7
  set sidescrolloff=15
  set sidescroll=1
" }}}

" Search {{{
  set esckeys         " map missed escape sequences (enables keypad keys)
  set hlsearch        " highlight search (very useful!)
  set incsearch       " search incremently (search while typing)
  set ignorecase      " Do case insensitive matching
  set smartcase       " but do case sensitive if you type uppercase characters
  set gdefault        " /g flag on :s substitutions by default
  set magic           " For regular expression, change the way backslashes
                      " are used in search patterns
  set showmatch       " highlight matching [{()}]
  set matchtime=2     " show matching bracket for 0.2 seconds
  set matchpairs+=<:> " specially for html
" }}}

" Key mappings {{{
  " With a map leader it is s possible to do extra key combinations
  " like <leader>w saves the current file
  " The mapleader has to be set before vundle starts loading all
  " the plugins.
  let mapleader   = ","
  let g:mapleader = ","
  " Making it so ; works like : for commands. Saves typing and
  " eliminates :W style typos due to lazy holding shift.
  nnoremap ; :
  noremap <leader>h :%!xxd<cr>:set syntax=xxd<cr> " for binary file
  noremap <leader>u :%!xxd -r<cr>:syntax enable<cr> " to revert after xxd
  nmap <leader>w :w!<cr> " fast saving
  nmap <leader>q :q<cr>  " quit file
  nmap <leader>Q :q!<cr> " quit anyway
  " Fast set wrapping
  nmap <leader>r :set wrap<cr>
  " sudo write when no have enough privilege
  nmap <leader>s :w !sudo tee % > /dev/null 2>&1
  " turn off search highlight
  nnoremap <leader><space> :nohlsearch<cr>
  " turn on fold
  noremap <leader>f :set foldenable<cr>:set foldmethod=marker<cr>:set foldlevel=0<cr>:set modelines=1<cr>
  " Move up/down editor lines, rather than next line in file
  nnoremap j gj
  nnoremap k gk
  "nnoremap <silent> <Esc> :nohlsearch<Bar>:echo<cr>
  " Search mappings: These will make it so that going to the next one in a
  " search will center on the line it's found in.
  nnoremap n nzzzv
  nnoremap N Nzzzv
  " Tab back and forth between those files
  nnoremap <TAB> :bnext<cr>
  nnoremap <S-TAB> :bprevious<cr>
  " close only one buffer
  nnoremap <leader>c :bd<cr>
  " no one is really happy until you have this shortcuts
  "cnoreabbrev W! w!
  "cnoreabbrev Q! q!
  "cnoreabbrev Qall! qall!
  "cnoreabbrev Wq wq
  "cnoreabbrev Wa wa
  "cnoreabbrev wQ wq
  "cnoreabbrev WQ wq
  "cnoreabbrev W w
  "cnoreabbrev Q q
  "cnoreabbrev Qall qall
  "cmap Tabe tabe
  " Switching windows
  noremap <C-j> <C-w>j
  noremap <C-k> <C-w>k
  noremap <C-l> <C-w>l
  noremap <C-h> <C-w>h
  " Vmap for maintain Visual Mode after shifting > and <
  vnoremap < <gv
  vnoremap > >gv
  " Yank to the end of the line, to be consistent with C and D.
  nnoremap Y y$

" }}}

" Clipboard {{{
if has("unnamedplus")
  set clipboard=unnamed,unnamedplus
endif

noremap YY "+y<cr>
noremap <leader>p "+gP<cr>
noremap XX "+x<cr>
" }}}

" Helper functions {{{
  "
  " Write a Vim script manual: http://vimdoc.sourceforge.net/htmldoc/usr_41.html
  "

  " strips trailing whitespace at the end of all of lines. This
  " is called on Buffer Write Event in the autogroup above.
  fun! TrimTrailingWhiteSpace()
    let l:save = winsaveview()
    %s/\s\+$//e
    call winrestview(l:save)
  endfun

  " Escape string in selected text
  " http://vim.wikia.com/wiki/Search_for_visually_selected_text
  fun! GetVisualSelectedText(cmd)
    let l:old_reg=getreg('"')
    let l:old_regtype=getregtype('"')
    norm! gvy
    let l:escape_range = '\.*$^~['
    let l:pattern_esc = escape(@", a:cmd.l:escape_range)
    let l:pattern = substitute(l:pattern_esc, '\_s\+', '\\_s\\+', 'g')
    norm! gV
    let @/ = l:pattern
    call setreg('"', l:old_reg, l:old_regtype)
  endfun
" }}}

if filereadable(expand("~/.vim/vimrc"))
  source ~/.vim/vimrc
endif
