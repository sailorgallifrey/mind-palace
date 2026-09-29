export NODE_ENV=localhost

# --- completion ------------------------------------------------------------
# Homebrew-provided zsh completions
if [[ -d /opt/homebrew/share/zsh/site-functions ]]; then
  fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
fi

# kubectl ships its own zsh completion; cache it so we don't fork on every start
_zsh_completion_cache="$HOME/.zsh/completions"
if (( $+commands[kubectl] )); then
  [[ -d "$_zsh_completion_cache" ]] || mkdir -p "$_zsh_completion_cache"
  if [[ ! -s "$_zsh_completion_cache/_kubectl" || "$commands[kubectl]" -nt "$_zsh_completion_cache/_kubectl" ]]; then
    kubectl completion zsh > "$_zsh_completion_cache/_kubectl"
  fi
  fpath=("$_zsh_completion_cache" $fpath)
fi

autoload -Uz compinit bashcompinit
compinit
bashcompinit  # lets us reuse bash completion scripts (e.g. nvm)

# `k` is an alias for kubectl, so give it kubectl's completions
(( $+commands[kubectl] )) && compdef k=kubectl

[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# --- history ---------------------------------------------------------------
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt append_history share_history hist_ignore_dups hist_ignore_space
setopt extended_glob

# --- prompt ----------------------------------------------------------------
source ~/.zsh_prompt

# --- aliases ---------------------------------------------------------------
alias lg=lazygit
alias vi=nvim
alias k=kubectl
alias vir='dir="$(ls -a $DEV_FOLDER | sk)" && [[ -n "$dir" ]] && vi "$DEV_FOLDER/$dir"'
alias k9sc='context="$(kubectl config get-contexts -o name | sk)" && [[ -n "$context" ]] && k9s --context "$context"'
alias kc='context="$(kubectl config get-contexts -o name | sk)" && [[ -n "$context" ]] && kubectl config use-context "$context"'
alias awsp='profile="$(aws configure list-profiles | sk)" && [[ -n "$profile" ]] && export AWS_PROFILE="$profile"'
alias updatefork='git fetch --all --prune && git rebase upstream/master && git push'
alias updateforkmain='git fetch --all --prune && git rebase upstream/main && git push'

# --- functions -------------------------------------------------------------
function dev-env() {
  docker run -v ~/.saml2aws:/root/.saml2aws -v ~/.aws:/root/.aws -v ~/.config:/root/.config -v "$PWD":/src -it dev-env:$1 /bin/zsh
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
user=$(whoami)
hostname=$(hostname | sed 's/.local//g')

version="OS X $(sw_vers -productVersion)"
versionNumber=$(sw_vers -productVersion)
versionMajor=${versionNumber%%.*}
versionMinor=${${versionNumber#*.}%%.*}
versionShort="${versionMajor}.${versionMinor}"

## en1 or en0 should contain the ip address
ipAddressInternal=$(ipconfig getifaddr en1)
if [ -z "$ipAddressInternal" ]; then
  ipAddressInternal=$(ipconfig getifaddr en0)
fi

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
      10.5)  versionString="Leopard" ;;
      10.4)  versionString="Tiger" ;;
      10.3)  versionString="Panther" ;;
      10.2)  versionString="Jaguar" ;;
      10.1)  versionString="Puma" ;;
      10.0)  versionString="Cheetah" ;;
    esac
    ;;
esac

kernel=$(uname)
uptime=$(uptime | sed 's/.*up \([^,]*\), .*/\1/')
shell="$SHELL"
terminal="$TERM"
cpu=$(sysctl -n machdep.cpu.brand_string)
mem=$(sysctl -n hw.memsize)
ram="$((mem / 1073741824)) GB"
disk=$(df -l -H | head -3 | tail -1 | awk '{print $5}')

if (( $+commands[ponysay] )); then
  ponies=(twilight trixie pinkie fluttershy rainbow pinkiecannon)
  paste -d' ' <(ponysay --pony-only --pony ${ponies[RANDOM % ${#ponies} + 1]}) <(echo "
    User: $user
    Hostname: $hostname
    Version: $version $versionString
    Kernal: $kernel
    Uptime: $uptime
    Shell: $shell
    Terminal: $terminal
    CPU: $cpu
    Memory: $ram
    Disk Used: $disk
    Internal IP: $ipAddressInternal")
fi

expressions=("Notice me senpai" "dessu dessu" "baka baka baka" "nani")
#say -v Kyoko "${expressions[RANDOM % ${#expressions} + 1]}"
