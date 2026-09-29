# Login shell setup (zsh reads .zprofile before .zshrc)

# Machine-local PATH/env and credentials. These live only in $HOME and are
# deliberately not tracked in this repo - see the .example files for templates.
# `typeset -U path PATH` keeps PATH de-duplicated so re-sourcing is harmless.
typeset -U path PATH
[[ -r "$HOME/.zsh_path" ]]    && source "$HOME/.zsh_path"
[[ -r "$HOME/.zsh_secrets" ]] && source "$HOME/.zsh_secrets"
export _ZSH_ENV_LOADED=1

[[ -r "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"

# >>> coursier install directory >>>
export PATH="$PATH:$HOME/Library/Application Support/Coursier/bin"
# <<< coursier install directory <<<

[[ -r "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
