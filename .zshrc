# ~/.zshrc - Custom Mac Terminal Configuration

## Aliases ##

# File Listings
alias l='ls -lFh'                                         # Long format, human-readable sizes
alias la='ls -a'                                          # Include hidden files

# System Utilities
alias ip='ipconfig getifaddr en0'                         # Show current IP address (en0)
alias reboot='sudo shutdown -r now'                       # Restart computer
alias cleanup='find . -name ".DS_Store" -type f -delete'  # Remove all .DS_Store files

## Options ##

setopt CORRECT                                            # Command auto-correction
setopt EXTENDED_GLOB                                      # Enhanced globbing
setopt NO_CASE_GLOB                                       # Case-insensitive globbing
setopt AUTO_CD                                            # Auto `cd` into directories

## History ##

export ZSH=$HOME/.zsh                                     # Set zsh home directory
export HISTFILE=$ZSH/.zsh_history                         # Set history file path
export HISTSIZE=10000                                     # Number of commands to load into memory
export SAVEHIST=10000                                     # Number of commands to save to file

setopt HIST_IGNORE_ALL_DUPS                               # Remove duplicate history entries
setopt HIST_FIND_NO_DUPS                                  # No duplicates in history search
HIST_STAMPS="yyyy-mm-dd"                                  # History timestamp format

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

## Theme ##

# Pure theme
fpath+=($ZSH/themes/pure)
autoload -U promptinit; promptinit
prompt pure

## Plugins ##

plugins=(
  1password
  aws
  docker-compose
  npm
  nvm
  podman
  yarn
  zsh-autosuggestions
)
for plugin ($plugins); do
  source $ZSH/plugins/$plugin/$plugin.plugin.zsh
done

## Key Bindings ##

# Ctrl + L to clear screen
bindkey '^L' clear

## Custom Functions ##

# Function to execute after any directory change
chpwd() {
  ls -la  # List all files, including hidden ones, in long format
}

# Optional: Enable colored output for ls for better readability
alias ls='ls --color=auto'

## NVM Config ##

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                    # Load nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # Load nvm bash_completion

# Auto switch Node versions based on .nvmrc
autoload -U add-zsh-hook
load-nvmrc() {
  command -v nvm >/dev/null 2>&1 || return

  local nvmrc_path="$(nvm_find_nvmrc)"
  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")
    if [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use
    fi
  elif [ "$(nvm version)" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

## Docker/Podman ##

# Use Docker CLI with Podman
export DOCKER_HOST='unix:///var/folders/87/21sv93yn4mg1yj0tv6st55rc0000gn/T/podman/podman-machine-default-api.sock'
