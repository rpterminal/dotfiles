#!/usr/bin/env zsh

# --- XDG Base Directory Specification ---
# Força o padrão para evitar que o Neovim procure na Home diretamente
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# --- Variáveis de Usuário ---
export EDITOR="nvim"
export BROWSER="zen-browser" # Ou seu navegador de preferência

# --- PATH ---
# Adiciona pastas locais ao PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PNPM_HOME:$PATH"
export PATH="$HOME/.tmuxifier/bin:$PATH"
