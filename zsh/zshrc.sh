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

	# History
	export HISTFILE=$HOME/.zsh_history		# History filepath
	export HISTSIZE=10000					# Maximum events for internal history
	export SAVEHIST=10000					# Maximum events in history file


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


###########################################################
# => Autoload 
###########################################################

	# Start Tmux automatically on terminal start
	[[ $TERM != "screen" ]] && exec tmux

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

	# Zsh Completion System
	zstyle :compinstall filename '$HOME/.zshrc'
	# case insensitive path-completion
	zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'
	# partial completion suggestions
	zstyle ':completion:*' list-suffixes
	zstyle ':completion:*' expand prefix suffix
	# Initialize Completion
	autoload -Uz compinit && compinit
	
###########################################################
# => Sourcing & Plugins 
###########################################################

	source /usr/local/share/chruby/chruby.sh					# Chruby configuration requirement
	source /usr/local/share/chruby/auto.sh						# 
	source $HOME/.dotfiles/zsh/plugins/nvm/nvm.plugin.zsh		# Adds autocompletions for nvm â€” a Node.js version manager
	source $HOME/.dotfiles/zsh/plugins/tmux/tmux.plugin.zsh		# Provides aliases for tmux, the terminal multiplexer
	source $HOME/.dotfiles/zsh/plugins/brew/brew.plugin.zsh		# Adds several aliases for common brew commands
	source $HOME/.dotfiles/zsh/plugins/cabal/cabal.plugin.zsh	# Provides completion for Cabal, a build tool for Haskell
	source $HOME/.dotfiles/zsh/plugins/fzf/fzf.plugin.zsh		# Enables fzf's fuzzy auto-completion and key bindings
	source $HOME/.dotfiles/zsh/plugins/osx/osx.plugin.zsh		# Provides a few utilities for macOS
	source $HOME/.dotfiles/zsh/plugins/stack/stack.plugin.zsh	# Provides completion for Stack a tool for Haskell
	source $HOME/.dotfiles/zsh/plugins/yarn/yarn.plugin.zsh		# Adds completion and aliases for the Yarn package manager
	 
	# Path to ghcup & ghcup-env
	[ -f "/Users/alexander/.ghcup/env" ] && source "/Users/alexander/.ghcup/env" 



###########################################################
# => Theme Prompt 
###########################################################

# Minimal Theme Prompt
PROMPT='%m :: %2~ %BÈ%b '


