" Last updated 10/30/2014

" Compatability Issues
set nocompatible								" Use vim defaults, not old vi defaults
set backspace=indent,eol,start					" Allows backspace to work in a sane manner

" External Plugins ==========================================================
runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()
execute pathogen#helptags()
syntax on
filetype plugin indent on

" Personal Settings =========================================================


" General Environment Options
syntax on										" Syntax highlighting on
set ruler										" Show the cursor position all the time
set number										" Show line numbers
set wrap										" Turn wordwrap on
set laststatus=2								" Always show the status line
set background=dark								" Who rocks the white bg these days?
set iskeyword+=_,$,@,%,#						" None of these are word dividers
set hidden										" Keep changes when multiple files modified in buffer
set report=0									" Always report 'x lines changed' style messages
set history=500									" The default of 20 isn't enough
set showmode									" Shows the Mode you're in
set showcmd										" Honestly, never seen a vim install not have this on by default, but just in case
set showmatch									" Show matching brackets/braces
set matchpairs+=<:>,«:»							" Add more bracets to '%' matching
set nomore										" Don't page long listings
set virtualedit=block							" Allow whitespace selection in visual mode
set splitbelow									" I read left to right, top to bottom
set splitright									" Ditto


" Indentation Options
set autoindent									" Copies indentation from previous line
set nosmartindent								" Smart indent conflicts with 'filetype indent on'
set tabstop=4									" Because 8 columns is overkill
set softtabstop=4								" Ditto
set shiftwidth=4								" This should always match softtabstop
set noexpandtab									" Tabs are tabs
set shiftround									" Indentation to the nearest shiftwidth


" Search Options
set hlsearch									" Highlight search terms
set incsearch									" Do incremental searching
set ignorecase									" Ignore case when searching
set smartcase									" Unless the search contains capitalization
set scrolloff=2									" Scroll so search term has at least 2 lines above and below it


" Smarter Command Line Options
set wildmenu									" Enable wildmeu capabilities
set wildmode=list:longest,full					" Makes hitting tab work like it does in bash in the wild menu
set wildignore+=*.a,*.o							" Ignore certain filetypes
set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png	" Ignore more filetypes
set wildignore+=.DS_Store,.git,.hg,.svn			" Ignore more filetypes
set wildignore+=*~,*.swp,*.tmp					" Ignore more filetypes


" Misc Options
set titlestring=%t%(\ %M%)%(\ -\ (%{expand(\"%:p\")})%)%(\ %a%)\ -\ %{hostname()}
set title										" Put the filename in the window title
set noautochdir									" Don't change the working directory (Needed for some plugins)
set pastetoggle=<F5>							" Toggle pastemode
highlight LineNr ctermfg=grey					" Make line numbers Grey instead of Yellow



" Keyboard Mappings =========================================================

" Use Tab key to move between vim tabs
nnoremap <silent> <Tab> gt 
nnoremap <silent> <S-Tab> gT 

" Spacebar to clear search highlighting
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

" To account for me being absent-minded
inoremap jj <Esc>

" Move up/down through wordwrapped lines
nnoremap [B gj
nnoremap [A gk
nnoremap <C-j> gj
nnoremap <C-k> gk

" Bubble single lines
nnoremap [D ddkP
nnoremap [C ddp

" Bubble multiple lines
vnoremap <C-Left> xkP`[V`]
vnoremap <C-Right> xp`[V`]

" Toggle line numbers
nnoremap <F6> :set invnumber<CR>
inoremap <F6> <ESC>:set invnumber<CR>i

" Expands %% to current file path 
cabbr <expr> %% expand('%:p:h')

" One Key JSBeautify
nnoremap <F12> :%!js-beautify -j -q -f -<CR>

" Allow numeric keypad to work like it should
inoremap <Esc>OQ /
cnoremap <Esc>OQ /
inoremap <Esc>OR *
cnoremap <Esc>OR *
inoremap <Esc>OS -
cnoremap <Esc>OS -
inoremap <Esc>Ol +
cnoremap <Esc>Ol +
inoremap <Esc>On .
cnoremap <Esc>On .
inoremap <Esc>Op 0
cnoremap <Esc>Op 0
inoremap <Esc>Oq 1
cnoremap <Esc>Oq 1
inoremap <Esc>Or 2
cnoremap <Esc>Or 2
inoremap <Esc>Os 3
cnoremap <Esc>Os 3
inoremap <Esc>Ot 4
cnoremap <Esc>Ot 4
inoremap <Esc>Ou 5
cnoremap <Esc>Ou 5
inoremap <Esc>Ov 6
cnoremap <Esc>Ov 6
inoremap <Esc>Ow 7
cnoremap <Esc>Ow 7
inoremap <Esc>Ox 8
cnoremap <Esc>Ox 8
inoremap <Esc>Oy 9
cnoremap <Esc>Oy 9


" Functions =================================================================

" Wrap all conditional mappings in a function so they can be called after plugins have been loaded.
"
function! PluginChecks()
	" Use Commentary plugin to comment or uncomment lines
	" Mapped to # because I came up on Perl & Bash
	if exists("g:loaded_commentary")
		map <silent> # <Plug>CommentaryLine
	endif

	" Surround Plugin Shortcuts

	" Syntastic
	if exists(":SyntasticCheck")
		nmap <F4>  :SyntasticCheck<CR>:Errors<CR>
		nmap <F9>  :lnext<CR>
		nmap <F10> :lprevious<CR>
		let g:syntastic_javascript_checkers=['jslint']
	endif

	" NERDTree
	if exists(":NERDTreeToggle")
		map <C-n> :NERDTreeToggle<CR>
		let g:NERDTreeDirArrows=0	" Don't use Unicode Characters as they break display on some systems
	endif

	" Gundo Toggle
	if exists(":GundoToggle")
		nnoremap <F7> :GundoToggle<CR>
	endif
endfunction


" Used to for template building in Master TMS.
"
function! UglyPrePost()
	let filebase = substitute(expand('%:p'), '.json','','')
	let preline = searchpos('preBuild')[0]
	let postline = searchpos('postBuild')[0]
	let builds = []
	if &filetype == 'javascript'
		if preline > 0
			call add(builds, 'preBuild')
		endif
		if postline > 0
			call add(builds, 'postBuild')
		endif
		for mybuild in builds
			let myfile = filebase . '-' . mybuild . '.js'
			if filereadable(myfile)
				let output = '"multi": "' . system('command -v uglifyjs >/dev/null && uglifyjs -nc ' . myfile . ' | sed -r -e ''s/("##|##")/##/g'' -e ''s/"/\x27/g'' -e ''s/&/\\&/g''') . '"'
				if output != '"multi": ""'
					echom output
					let myline = getline(searchpos(mybuild)[0]+1)
					if myline =~ '^\s\{-}"multi'
						call setline(searchpos(mybuild)[0]+1, substitute(myline, '\"multi\":.*', output, ''))
						echo 'Successfully Uglified ' . myfile
					else
						echom 'Error: No line with "multi" found beneath a pre or post build.'
					endif
				else
					echom 'Error: Looks like uglifyjs is not in your path' 
				endif
			else
				echom 'Error: Could not read file: (' . myfile .')'
			endif
		endfor
	else
		echom 'Error: Filetype is not Javascript'
	endif
endfunction

nnoremap <silent> <F11> :call UglyPrePost()<CR>



" Other Auto Commands =======================================================


" Map plugin keys and commands once plugins are loaded
augroup plugin_check " {
	autocmd!
	autocmd vimenter * :call PluginChecks()
	autocmd vimenter * if !argc() | NERDTree | endif	" Open NERDTree if no file is selected
	autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
augroup END " }


" Auto Reload vimrc when changed
augroup reload_vimrc " {
	autocmd!
	autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END " }


" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif
