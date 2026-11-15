# Read by every zsh, including the login shell Zed spawns to load its environment.
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

# Untracked per-machine secrets (e.g. CONTEXT7_API_KEY for the Zed Context7 MCP server).
[[ -f "$HOME/.secrets.zsh" ]] && . "$HOME/.secrets.zsh"
