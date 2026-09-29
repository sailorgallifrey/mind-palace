# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# Stock oh-my-zsh theme. No bundled theme shows git + aws + kube together, but
# robbyrussell leaves RPROMPT alone, so the aws and kube segments can be added
# with a single RPROMPT assignment after oh-my-zsh.sh is sourced (see below).
# A custom theme that renders all three inline is kept in this repo at
# oh-my-zsh-custom/themes/sexy-aws-kube.zsh-theme if you want to go back to it.
ZSH_THEME="robbyrussell"

# robbyrussell uses oh-my-zsh's async git prompt (enabled by default), which
# computes the branch/dirty segment in a background process so the prompt never
# blocks. Measured sync cost with async disabled: ~195ms per render in a small
# repo and ~830ms in the 102k-file policy-management repo.
# If the git segment ever fails to appear, force the synchronous path:
# zstyle ':omz:alpha:lib:git' async-prompt no

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change the frequency the auto-updater is run (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line to set how old an update must be before it's applied, manually or via the auto-updater (in days).
# zstyle ':omz:update' cooldown 10

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# Measured on the 102k-file policy-management repo: scanning untracked files
# costs 3900ms per prompt vs 160ms without. Leave this on; use `git status`
# when you need to see untracked files.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# Not needed - this config uses a stock theme and no custom plugins, so the
# default $ZSH/custom is fine.
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
#
# git      - branch/dirty info used by the theme, plus g* aliases
# aws      - aws_prompt_info for the prompt, asp/agp profile switching
# kubectl  - kubectl completion and aliases (provides `k`)
# kube-ps1 - kube context segment, mtime-cached so kubectl rarely runs
# macos    - ofd/pfd/showfiles helpers
# brew, golang, docker, gpg-agent - completions
# colored-man-pages - readable man output
#
# Deliberately NOT enabled: `nvm` and `sdk`, because ~/.zprofile already
# initializes nvm and sdkman by hand and loading both would double-init them.
plugins=(
  git
  aws
  kubectl
  kube-ps1
  macos
  brew
  golang
  docker
  gpg-agent
  colored-man-pages
)

# Machine-local PATH/env and credentials, loaded BEFORE oh-my-zsh so that
# plugins can detect binaries (kubectl, brew, go) on PATH. These two files live
# only in $HOME and are deliberately not tracked in this repo - see
# .zsh_path.example and .zsh_secrets.example for templates.
# ~/.zprofile loads them for login shells; this covers non-login shells too.
# Re-sourcing is harmless because `typeset -U` de-duplicates PATH.
if [[ -z "$_ZSH_ENV_LOADED" ]]; then
  typeset -U path PATH
  [[ -r "$HOME/.zsh_path" ]]    && source "$HOME/.zsh_path"
  [[ -r "$HOME/.zsh_secrets" ]] && source "$HOME/.zsh_secrets"
fi
export _ZSH_ENV_LOADED=1

# --- plugin settings that must be set BEFORE oh-my-zsh.sh is sourced -------
# oh-my-zsh loads plugins before the theme, so anything a plugin reads at load
# time has to be set here.

# kube-ps1 reads these when it loads. Render just "(context)" to match the old
# bash prompt: no ⎈ symbol, no namespace. kube-ps1 caches on the kubeconfig's
# mtime, so kubectl only runs when the config actually changes.
KUBE_PS1_PREFIX=" ("
KUBE_PS1_SUFFIX=")"
KUBE_PS1_SEPARATOR=""
KUBE_PS1_SYMBOL_ENABLE=false
KUBE_PS1_NS_ENABLE=false
KUBE_PS1_PREFIX_COLOR="white"
KUBE_PS1_CTX_COLOR="cyan"
KUBE_PS1_SUFFIX_COLOR="white"

source $ZSH/oh-my-zsh.sh

# --- prompt settings that must come AFTER oh-my-zsh.sh ---------------------
# Put the kube context and AWS profile on the LEFT prompt, just before the git
# segment. The theme is loaded inside oh-my-zsh.sh, so $PROMPT only exists once
# that has run.
#
# This splices the segments in rather than rewriting $PROMPT wholesale, so it
# keeps working if the theme changes. Three details matter:
#   1. The literal string '$(git_prompt_info)' MUST survive in $PROMPT.
#      lib/git.zsh's _defer_async_git_register pattern-matches the prompt
#      variables for exactly that text to decide whether to enable the async
#      git prompt. Interpolating the git segment any other way silently makes
#      every prompt render block on `git status`.
#   2. The substitution is on the unexpanded literal, so the pattern needs the
#      $ and parens backslash-escaped.
#   3. Both KUBE_PS1_PREFIX and ZSH_THEME_AWS_PROFILE_PREFIX start with their
#      own leading space, so the splice swallows the theme's existing space
#      before the git segment. That keeps the spacing right whether neither,
#      either, or both segments render.
# _defer_async_git_register runs as a precmd hook (i.e. at the first prompt,
# after this file finishes), so editing $PROMPT here is still seen by it.
if [[ $PROMPT == *' $(git_prompt_info)'* ]]; then
  PROMPT=${PROMPT/ \$\(git_prompt_info\)/\$\(kube_ps1\)\$\(aws_prompt_info\) \$\(git_prompt_info\)}
elif [[ $PROMPT == *'$(git_prompt_info)'* ]]; then
  PROMPT=${PROMPT/\$\(git_prompt_info\)/\$\(kube_ps1\)\$\(aws_prompt_info\) \$\(git_prompt_info\)}
else
  # Theme doesn't use git_prompt_info; just append the segments.
  PROMPT+='$(kube_ps1)$(aws_prompt_info) '
fi

# The aws plugin sets RPROMPT='$(aws_prompt_info)' at load time. Both segments
# now live on the left, so clear it to avoid showing the profile twice.
RPROMPT=''

# aws_prompt_info expands these at render time. They must be set after
# oh-my-zsh.sh because $fg is only populated once `colors` has been autoloaded.
# Renders " (profile)" to match the kube segment instead of the "<aws:...>"
# default.
ZSH_THEME_AWS_PROFILE_PREFIX=" %{$fg[white]%}(%{$fg[yellow]%}"
ZSH_THEME_AWS_PROFILE_SUFFIX="%{$fg[white]%})%{$reset_color%}"

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

export NODE_ENV=localhost

# oh-my-zsh runs compinit for us; bashcompinit lets us reuse bash completion
# scripts that have no zsh equivalent (nvm ships bash-only completion).
autoload -Uz bashcompinit && bashcompinit
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# --- history ---------------------------------------------------------------
# oh-my-zsh sets sane defaults; these raise the limits and share history
# between concurrent shells.
HISTSIZE=50000
SAVEHIST=50000
setopt share_history hist_ignore_space

# --- aliases ---------------------------------------------------------------
# The kubectl plugin already provides `k`, and the git plugin provides most
# g* aliases, so only the ones oh-my-zsh does not cover are defined here.
alias lg=lazygit
alias vi=nvim
alias vir='dir="$(ls -a $DEV_FOLDER | sk)" && [[ -n "$dir" ]] && vi "$DEV_FOLDER/$dir"'
alias k9sc='context="$(kubectl config get-contexts -o name | sk)" && [[ -n "$context" ]] && k9s --context "$context"'
alias kc='context="$(kubectl config get-contexts -o name | sk)" && [[ -n "$context" ]] && kubectl config use-context "$context"'
alias awsp='profile="$(aws configure list-profiles | sk)" && [[ -n "$profile" ]] && export AWS_PROFILE="$profile"'
alias updatefork='git fetch --all --prune && git rebase upstream/master && git push'
alias updateforkmain='git fetch --all --prune && git rebase upstream/main && git push'

# --- functions -------------------------------------------------------------
function dev-env() {
  docker run -v ~/.saml2aws:/root/.saml2aws -v ~/.aws:/root/.aws -v ~/.config:/root/.config -v "$PWD":/src -it dev-env:$1 /bin/bash
}

function showcert() {
  nslookup $1
  (openssl s_client -showcerts -servername $1 -connect $1:443 <<< "Q" | openssl x509 -text | grep -iA2 "Validity")
}

function gprunemerged() {
  local main
  main=$(git remote show origin | sed -n "/HEAD branch/s/.*: //p")
  git checkout "$main" && git fetch --all --prune && git pull && git branch -vv | grep -v "$main" | grep ": gone" | awk '{print $1}' | xargs -n 1 git branch -D
}

# --- ruby ------------------------------------------------------------------
source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
source /opt/homebrew/opt/chruby/share/chruby/auto.sh
chruby ruby-3.4.1

# --- login banner ----------------------------------------------------------
# oh-my-zsh has no system-info plugin, so this stays custom. Unlike the old
# .bashrc, every value is computed inside the function instead of at shell
# startup, so the ~10 subprocesses (sw_vers, sysctl, uptime, df, ipconfig)
# only run when the banner is actually drawn.
function sysinfo() {
  local versionNumber versionMajor versionMinor versionShort versionString
  local ipAddressInternal mem

  versionNumber=$(sw_vers -productVersion)
  versionMajor=${versionNumber%%.*}
  versionMinor=${${versionNumber#*.}%%.*}
  versionShort="${versionMajor}.${versionMinor}"

  case $versionMajor in
    26) versionString="Tahoe" ;;
    15) versionString="Sequoia" ;;
    14) versionString="Sonoma" ;;
    13) versionString="Ventura" ;;
    12) versionString="Monterey" ;;
    11) versionString="Big Sur" ;;
    10)
      case $versionShort in
        10.15) versionString="Catalina" ;;
        10.14) versionString="Mojave" ;;
        10.13) versionString="High Sierra" ;;
        10.12) versionString="Sierra" ;;
        10.11) versionString="El Capitan" ;;
        10.10) versionString="Yosemite" ;;
        10.9)  versionString="Mavericks" ;;
        10.8)  versionString="Mountain Lion" ;;
        10.7)  versionString="Lion" ;;
        10.6)  versionString="Snow Leopard" ;;
      esac
      ;;
  esac

  ## en1 or en0 should contain the ip address
  ipAddressInternal=$(ipconfig getifaddr en1)
  [[ -z "$ipAddressInternal" ]] && ipAddressInternal=$(ipconfig getifaddr en0)

  mem=$(sysctl -n hw.memsize)

  print -r -- "
    User: $(whoami)
    Hostname: $(hostname | sed 's/.local//g')
    Version: OS X ${versionNumber} ${versionString}
    Kernal: $(uname)
    Uptime: $(uptime | sed 's/.*up \([^,]*\), .*/\1/')
    Shell: $SHELL
    Terminal: $TERM
    CPU: $(sysctl -n machdep.cpu.brand_string)
    Memory: $((mem / 1073741824)) GB
    Disk Used: $(df -l -H | head -3 | tail -1 | awk '{print $5}')
    Internal IP: ${ipAddressInternal}"
}

function ponyinfo() {
  (( $+commands[ponysay] )) || { sysinfo; return; }
  local ponies=(twilight trixie pinkie fluttershy rainbow pinkiecannon)
  paste -d' ' \
    <(ponysay --pony-only --pony ${ponies[RANDOM % ${#ponies} + 1]}) \
    <(sysinfo)
}

# Only greet real interactive terminals, so scripts, scp/rsync and editor
# shells are not polluted with the banner.
if [[ -o interactive && -t 1 ]]; then
  ponyinfo
fi
