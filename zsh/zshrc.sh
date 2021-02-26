# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# chruby Configuration Requirement
source /usr/local/share/chruby/chruby.sh
source /usr/local/share/chruby/auto.sh

# Path to your NVM installation
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="robbyrussll"
ZSH_THEME="evan"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )



# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
	brew
	git
	node
	npm
	npx
	nvm
	tmux
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Set default editor to nvim
export EDITOR='nvim'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Start Tmux automatically on terminal start
[[ $TERM != "screen" ]] && exec tmux

# Always Start with 256 Colors 
export TERM=xterm-256color
[ -n "$TMUX" ] && export TERM=screen-256color

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Shortcuts
	alias v='nvim'
	alias vi='nvim'
	alias la="ls -a"
	alias oldvim="\vim"

# cd commands for quick navigation
	alias home="cd ~"
	alias root="cd /"
	alias g="cd ~/Programming/Github"
	alias db="cd ~/Dropbox"
	alias dl="cd ~/Downloads"
	alias dt="cd ~/Desktop"
	alias dot='cd ~/.dotfiles'
	alias o="open ."
	alias cd..="cd .."
	alias ..="cd .."
	alias ...="cd ../.."
	alias ....="cd ../../.."

# Show/hide hidden files in Finder
	alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
	alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# IP addresses
	alias ip="ipconfig getifaddr en0"

# Find commands typed most often
	alias typeless='history n 20000 | sed "s/.*  //"  | sort | uniq -c | sort -g | tail -n 100'

# Find the number of lines of code in a git project
	alias lines='git ls-files | xargs wc -l'

# Make edits to vimrc.vim & zshrc.sh
	alias zshrc="$EDITOR ~/.dotfiles/zsh/zshrc.sh"
	alias vimrc="$EDITOR ~/.dotfiles/nvim/init.vim"
	alias tmux.conf="$EDITOR ~/.dotfiles/tmux/tmux.conf"
	alias spell="$EDITOR ~/.vim/spell/en.utf-8.add"

###########################################################
# => Settings
###########################################################

# set cd autocompletion to commonly visited directories
cdpath=(~ ~/src $DEV_DIR $SOURCE_DIR)


###########################################################
# => Custom Functions
###########################################################

# Change Directory with List All
 	c() {
 		cd $1;
 		ls -a;
 	}
 	alias cd="c"

# Add quick Github functionality
	git_prepare() {
		if [ -n "$BUFFER" ]; then
			BUFFER="git add -A && git commit -m \"$BUFFER\" && git push"
		fi

		if [ -z "$BUFFER" ]; then
			BUFFER="git add -A && git commit -v && git push"
		fi

		zle accept-line
	}

	zle -N git_prepare
	bindkey "^g" git_preparee

# Calling nvm use automatically in a directory with a .nvmrc file
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

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


