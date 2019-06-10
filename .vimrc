" Beginners .vimrc
" v0.1 2012-10-22 Philip Thrasher
"
" Important things for beginners:
" * Start out small... Don't jam your vimrc full of things you're not ready to
"   immediately use.
" * Read other people's vimrc's.
" * Use a plugin manager for christ's sake! (I highly recommend vundle)
" * Spend time configuring your editor... It's important. Its the tool you
"   spend 8 hours a day crafting your reputation.
" * remap stupid things to new keys that make you more efficient.
" * Don't listen to the haters that complain about using non-default
"   key-bindings. Their argument is weak. I spend most of my time in the editor
"   on my computer, not others, so I don't care if customizing vim means I'll
"   have a harder time using remote vim.
"
" Below I've left some suggestions of good default settings to have in a bare
" minimal vimrc. You only what you want to use, and nothing more. I've heavily
" commented each, and these are what I consider bare necessities, my workflow
" absolutely depends on these things.
"
" If you have any questions, email me at pthrash@me.com
set nocompatible " Fuck VI... That's for grandpas.
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'alvan/vim-closetag'
Plugin 'git://github.com/godlygeek/tabular.git'
Plugin 'https://github.com/tpope/vim-surround.git'
Plugin 'https://github.com/tpope/vim-repeat.git'
Plugin 'https://github.com/tpope/vim-commentary.git'
Plugin 'https://github.com/kana/vim-textobj-user.git'
Plugin 'https://github.com/tkhren/vim-textobj-numeral.git'
Plugin 'michaeljsmith/vim-indent-object'
Plugin 'rhysd/vim-clang-format'
Plugin 'tpope/vim-fugitive'
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
" We have to turn this stuff back on if we want all of our features.
"
syntax on " Syntax highlighting

set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab " use spaces instead of tabs.
set smarttab " let's tab key insert 'tab stops', and bksp deletes tabs.
set shiftround " tab / shifting moves to closest tabstop.
set autoindent " Match indents on new lines.
"set smartindent " Intellegently dedent / indent new lines based on rules.

" don't nag me when hiding buffers
set hidden " allow me to have buffers with unsaved changes.
set autoread " when a file has changed on disk, just load it. Don't ask.

" Make search more sane
set ignorecase " case insensitive search
set smartcase " If there are uppercase letters, become case-sensitive.
set incsearch " live incremental searching
set showmatch " live match highlighting
set hlsearch " highlight matches
set gdefault " use the `g` flag by default.

" allow the cursor to go anywhere in visual block mode.
set virtualedit+=block

" leader is a key that allows you to have your own "namespace" of keybindings.
" You'll see it a lot below as <leader>
let mapleader = ","


" So we don't have to press shift when we want to get into command mode.
nnoremap ; :
vnoremap ; :

" create new vsplit, and switch to it.
noremap <leader>v <C-w>v

" bindings for easy split nav
" nnoremap <A-Up> <C-w>h
" nnoremap <A-Down> <C-w>j
" nnoremap <A-Left> <C-w>k
" nnoremap <A-Right> <C-w>l

" Clear match highlighting
noremap <leader><space> :noh<cr>:call clearmatches()<cr>

" Quick buffer switching - like cmd-tab'ing
nnoremap <leader><leader> <c-^>

" jump alias only because I can't remember <C-i> ...
noremap <leader>jl <C-i>
noremap <leader>jh <C-o>

" Visual line nav, not real line nav
" If you wrap lines, vim by default won't let you move down one line to the
" wrapped portion. This fixes that.
noremap j gj
noremap k gk

" Plugin settings:
" Below are some 'sane' (IMHO) defaults for a couple of the above plugins I
" referenced.

" Map the key for toggling comments with vim-commentary
" nnoremap <leader>c <Plug>Commentary

" Remap ctrlp to ctrl-t -- map it however you like, or stick with the
" defaults. Additionally, in my OS, I remap caps lock to control. I never use
" caps lock. This is highly recommended.
let g:ctrlp_map = '<c-t>'

" Let ctrlp have up to 30 results.
let g:ctrlp_max_height = 30

" Finally the color scheme. Choose whichever you want from the list in the
" link above (back up where we included the bundle of a ton of themes.)
"colorscheme elflord
set undofile

" Youcompleteme
let g:ycm_server_python_interpreter= '/usr/bin/python2'
let g:ycm_python_binary_path = '/usr/bin/python2'
let g:ycm_global_ycm_extra_conf = $HOME . '/optimus/vehicle/.ycm_extra_conf.py' 
let g:ycm_goto_buffer_command = 'new-tab'
nnoremap <leader>jd :YcmCompleter GoToDefinition<CR>
nnoremap <leader>jD :YcmCompleter GoToDeclaration<CR>

" Closetag
let g:closetag_filenames = '*.xml,*.html,*.xhtml,*.phtml,*.launch,*.world,*.config,*.sdf,*.xacro'
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx'
let g:closetag_emptyTags_caseSensitive = 1
let g:closetag_shortcut = '>'

autocmd BufNewFile,BufReadPost *.launch set filetype=xml
autocmd BufNewFile,BufReadPost *.world set filetype=xml
autocmd BufNewFile,BufReadPost *.config set filetype=xml
autocmd BufNewFile,BufReadPost *.sdf set filetype=xml
autocmd BufNewFile,BufReadPost *.urdf set filetype=xml
autocmd BufNewFile,BufReadPost *.xacro set filetype=xml

if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Paste without Yank
"
" I haven't found how to hide this function (yet)
function! RestoreRegister()
  let @" = s:restore_reg
  return ''
endfunction

function! s:Repl()
    let s:restore_reg = @"
    return "p@=RestoreRegister()\<cr>"
endfunction

" NB: this supports "rp that replaces the selection by the contents of @r
vnoremap <silent> <expr> p <sid>Repl()
" Windows
" nmap <silent> <A-Up> :wincmd k<CR>
" nmap <silent> <A-Down> :wincmd j<CR>
" nmap <silent> <A-Left> :wincmd h<CR>
" nmap <silent> <A-Right> :wincmd l<CR>
set showcmd
set tabpagemax=100
" autocmd BufNewFile,BufRead * setlocal formatoptions-=cro

set relativenumber

nnoremap <leader>r :w \| ! chmod +x %:p && %:p<Enter>
nnoremap <leader>s :%s/\<<C-r><C-w>\>/
nnoremap <leader>f :ClangFormat<Enter>

set textwidth=80
set wrap

set wildmenu
set wildmode=longest,list,full
set diffopt+=vertical
