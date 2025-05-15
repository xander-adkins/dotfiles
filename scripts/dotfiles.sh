#!/bin/zsh

set -euo pipefail

# Define your dotfile configurations.
typeset -A configs=(
  "aws"      "$HOME/Workspace/dotfiles/aws/config"
  "emacs"    "$HOME/Workspace/dotfiles/emacs/init.el"
  "ghostty"  "$HOME/Workspace/dotfiles/ghostty/config"
  "git"      "$HOME/Workspace/dotfiles/git/.gitconfig"
  "nvim"     "$HOME/Workspace/dotfiles/nvim/init.lua"
  "scripts"  "$HOME/Workspace/dotfiles/scripts/"
  "ssh"      "$HOME/Workspace/dotfiles/ssh/config"
  "zshrc"    "$HOME/Workspace/dotfiles/zsh/.zshrc"
)

# If fzf is installed, use it for an interactive selection.
if command -v fzf &>/dev/null; then
  selected=$(printf "%s\n" "${(@k)configs}" | fzf --prompt="Select a dotfile config: ")
  if [[ -n "$selected" ]]; then
    nvim "${configs[$selected]}"
  else
    echo "No selection made."
  fi
else
  # Fallback to a simple select menu.
  echo "Select a dotfile config to open:"
  select config in "${(@k)configs}"; do
    if [[ -n "$config" ]]; then
      nvim "${configs[$config]}"
      break
    else
      echo "Invalid selection. Try again."
    fi
  done
fi
