# ~/.zshrc - Custom Mac Terminal Configuration

#################################
# Prompt Customization
#################################

# Set the shell prompt to display only a "$"
PROMPT='$ '

#################################
# Aliases
#################################

# File Listing Aliases
alias l='ls -lFh'    # List files in long format with classifications and human-readable sizes
alias la='ls -a'     # List all files, including hidden ones

# System Utilities
alias ip='ipconfig getifaddr en0'               # Display the current IP address of the primary network interface (en0)
alias cleanup='find . -name ".DS_Store" -type f -delete'  # Recursively remove all ".DS_Store" files from the current directory
alias reboot='sudo shutdown -r now'             # Restart the computer immediately (requires sudo privileges)

#################################
# Additional Configurations
#################################

# Enable command auto-correction
ENABLE_CORRECTION="true"

# Enable extended globbing for more powerful pattern matching
setopt EXTENDED_GLOB

# Improve command history behavior
HIST_IGNORE_ALL_DUPS="true"      # Remove duplicate entries from history
HIST_STAMPS="yyyy-mm-dd"         # Timestamp format for history entries

# Enable case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Optional: Ignore case when performing completion
setopt NO_CASE_GLOB

#################################
# Key Bindings
#################################

# Bind Ctrl + L to clear the terminal screen
bindkey '^L' clear

#################################
# NVM Config
#################################

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Automatically switch node versions based on .nvmrc
autoload -U add-zsh-hook
load-nvmrc() {
  command -v nvm >/dev/null 2>&1 || return

  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc
