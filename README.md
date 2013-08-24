The Greatest VIM Configuration in History
-----------------------------------------

Hyperbole aside, this is my VIM configuration folder. There are many like it, but this one is mine.


## To Use

	cd ~
	git clone https://github.com/zaffudo/dotfiles.git ~/.vim

	ln -s ~/.vim/vimrc ~/.vimrc

	cd ~/.vim
	git submodule update --init --recursive
	git submodule update --recursive

Or, consider making this part of a larger 'dotfiles' directory, and keep all your configs in one 
place like so: https://github.com/zaffudo/dotfiles

###For More Info
Feel free to use/steal from this as you see fit. If you're really looking to take your VIM use to
the next level, I suggest checking out vimcasts. I wish I was as good at anything, as that dude is
at VIM:

http://vimcasts.org/episodes/synchronizing-plugins-with-git-submodules-and-pathogen
