###########################################################
# => General Settings 
###########################################################

	# Load Tmux on start 
	ZSH_TMUX_AUTOSTART=true


###########################################################
# => Export Environment Variables
###########################################################

	# Default editor
	export EDITOR="nvim"
	export VISUAL="nvim"

	# Haskell Stack
	export PATH=/Users/alexander/.local/bin:$PATH
	
	# NVM
	export NVM_DIR=$HOME/.nvm
	export NVM_COLORS='bcmye'

	# History
	export HISTFILE=$HOME/.zsh_history		# History filepath
	export HISTSIZE=10000					# Maximum events for internal history
	export SAVEHIST=10000					# Maximum events in history file


###########################################################
# => Set Options 
###########################################################

	# Auto CD
	setopt autocd				# Change directory without explicit "cd" command

	# Directory Stack
	setopt AUTO_PUSHD           # Push the current directory visited on the stack.
	setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
	setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.


###########################################################
# => Aliases
###########################################################

	# Vim to Neovim 
	alias v="nvim"

	# List 
	alias l="ls -lFh"			# List files as a long list, show size, type, human-readable
	alias la="ls -lAfh" 		# List almost all files as a long list show size, type, human-readable	
	alias lr="ls -tRFh"		# List files recursively sorted by date, show type, human-readable
	alias lt="ls -ltFh"	 	# List files as a long list sorted by date, show type, human-readable
	alias ll="ls -l"			# List files as a long list
	alias ldot="ls -ld .*" 	# List dot files as a long list
	alias lS="ls -1FSsh"	 	# List files showing only size and name sorted by size
	alias lart="ls -1Fcart"	# List all files sorted in reverse of create/modification time (oldest first)
	alias lrt="ls -1Fcrt"	 	# List files sorted in reverse of create/modification time(oldest first)

	# CD 
	alias home="cd ~"
	alias root="cd /"
	alias notes="cd ~/Dropbox/Notes && ./notes.sh"
	alias g="cd ~/Programming/Github"
	alias db="cd ~/Dropbox"
	alias dl="cd ~/Downloads"
	alias dt="cd ~/Desktop"
	alias dot="cd ~/.dotfiles"
	alias o="open ."
	alias cd..="cd .."
	alias ..="cd .."
	alias ...="cd ../.."
	alias ....="cd ../../.."

	# Git
	alias gs='git status'
	alias ga='git add'
	alias gp='git push'
	alias gpo='git push origin'
	alias gtd='git tag --delete'
	alias gtdr='git tag --delete origin'
	alias gr='git branch -r'
	alias gplo='git pull origin'
	alias gb='git branch '
	alias gc='git commit'
	alias gd='git diff'
	alias gco='git checkout '
	alias gl='git log'
	alias gr='git remote'
	alias grs='git remote show'
	alias glo='git log --pretty="oneline"'
	alias glol='git log --graph --oneline --decorate'

	# IP address
	alias ip="ipconfig getifaddr en0"

	# Find most typed commands 
	alias typeless='history n 20000 | sed "s/.*  //"  | sort | uniq -c | sort -g | tail -n 100'

	# Git project line-count
	alias lines="git ls-files | xargs wc -l"

	# Configuration Links
	alias zshrc="$EDITOR ~/.dotfiles/zsh/zshrc.sh"
	alias vimrc="$EDITOR ~/.dotfiles/nvim/init.vim"
	alias tmux.conf="$EDITOR ~/.dotfiles/tmux/tmux.conf"
	alias scimrc="$EDITOR ~/.dotfiles/sc-im/scimrc"

	# Display the stack directories with a prefix number
	alias d='dirs -v'
	for index ({1..9}) alias "$index"="cd +${index}" 
	unset index

	# Recursively remove .DS_Store files
	alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"

	# Show/hide hidden files in Finder
	alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
	alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

	# Hide/show all desktop icons (useful when presenting)
	alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
	alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

	# Eject all hardrives
	alias ejectall='osascript -e "tell application \"Finder\" to eject (every disk whose ejectable is true)"'

	# Reboot the computer 
	alias reboot='osascript -e "tell app \"System Events\" to restart"'

	# Autoset Correct Macbook Volume when Cmus starts 
	alias cmus='osascript -e "set volume output volume 70" && cmus'

	# Update cmus library
	alias cmusupdate='echo "Updating cmus..." && cmus-remote -C "view tree" && cmus-remote -C clear && cmus-remote -C "add /Volumes/Music_Library/Music" && cmus-remote -C "update-cache -f" && echo "Done."'
	
	# Mount Music_Library from piCorePlayer
	alias musicmount='bash ~/.dotfiles/utils/mnt_music.sh'


###########################################################
# => NVM Autoload & Source Config 
###########################################################

	# Start NVM automatically on terminal start
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

	# Use NVM automatically when .nvmrc present in dir
	autoload -U add-zsh-hook
	load-nvmrc() {
	  local node_version="$(nvm version)"
	  local nvmrc_path="$(nvm_find_nvmrc)"
	  if [ -n "$nvmrc_path" ]; then
		local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")
		if [ "$nvmrc_node_version" = "N/A" ]; then
		  nvm install
		elif [ "$nvmrc_node_version" != "$node_version" ]; then
		  nvm use
		fi
	  elif [ "$node_version" != "$(nvm version default)" ]; then
		echo "Reverting to nvm default version"
		nvm use default
	  fi
	}
	add-zsh-hook chpwd load-nvmrc
	load-nvmrc


###########################################################
# => Changing Cursor
###########################################################

	# Visual indicator to show the current mode (NORMAL or INSERT)	
	cursor_mode() {
		cursor_block='\e[2 q'
		cursor_beam='\e[6 q'
		function zle-keymap-select {
			if [[ ${KEYMAP} == vicmd ]] ||
				[[ $1 = 'block' ]]; then
				echo -ne $cursor_block
			elif [[ ${KEYMAP} == main ]] ||
				[[ ${KEYMAP} == viins ]] ||
				[[ ${KEYMAP} = '' ]] ||
				[[ $1 = 'beam' ]]; then
				echo -ne $cursor_beam
			fi
		}
		zle-line-init() { echo -ne $cursor_beam }
		zle -N zle-keymap-select
		zle -N zle-line-init
	}
	# Initialize Cursor Mode
	cursor_mode


###########################################################
# => Zsh Completion System 
###########################################################

	# Designate compinstall file
	zstyle :compinstall filename '$HOME/.zshrc'
	# Case insensitive path-completion
	zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
	# Partial completion suggestions
	zstyle ':completion:*' list-suffixes
	zstyle ':completion:*' expand prefix suffix
	# Initialize completion
	autoload -Uz compinit && compinit
	_comp_options+=(globdots) # With hidden files

###########################################################
# => Sourcing & Plugins 
###########################################################

	source /usr/local/share/chruby/chruby.sh							# Chruby configuration requirement
	source /usr/local/share/chruby/auto.sh								# 
	source $HOME/.dotfiles/zsh/plugins/brew/brew.plugin.zsh				# Adds several aliases for common brew commands
	source $HOME/.dotfiles/zsh/plugins/cabal/cabal.plugin.zsh			# Provides completion for Cabal, a build tool for Haskell
	source $HOME/.dotfiles/zsh/plugins/fzf/fzf.plugin.zsh				# Enables fzf's fuzzy auto-completion and key bindings
	source $HOME/.dotfiles/zsh/plugins/gitignore/gitignore.plugin.zsh	# Enables the use of gitignore.io from the command line
	source $HOME/.dotfiles/zsh/plugins/nvm/nvm.plugin.zsh				# Adds autocompletions for nvm â€” a Node.js version manager
	source $HOME/.dotfiles/zsh/plugins/osx/osx.plugin.zsh				# Provides a few utilities for macOS
	source $HOME/.dotfiles/zsh/plugins/stack/stack.plugin.zsh			# Provides completion for Stack a tool for Haskell
	source $HOME/.dotfiles/zsh/plugins/tmux/tmux.plugin.zsh				# Provides aliases for tmux, the terminal multiplexer
	source $HOME/.dotfiles/zsh/plugins/yarn/yarn.plugin.zsh				# Adds completion and aliases for the Yarn package manager
	 
	# Path to ghcup & ghcup-env
	[ -f "/Users/alexander/.ghcup/env" ] && source "/Users/alexander/.ghcup/env" 



###########################################################
# => Theme Prompt 
###########################################################

# Minimal Theme Prompt
fpath=($HOME/.dotfiles/zsh/plugins/prompt $fpath)
autoload -Uz prompt_setup; prompt_setup
# PROMPT='%m :: %2~ %BÈ%b '


