# Login shell setup (zsh reads .zprofile before .zshrc)

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
