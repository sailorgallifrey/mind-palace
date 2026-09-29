BASH_COMPLETION_COMPAT_DIR="/usr/local/etc/bash_completion.d"
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

export NODE_ENV=localhost

. ~/.bash_prompt
#. ~/.bash_profile

alias lg=lazygit
alias vi=nvim
alias k=kubectl
alias vir='dir="$(ls -a $DEV_FOLDER | sk)" && [[ -n "$dir" ]] && vi "$DEV_FOLDER/$dir"'
alias k9sc='context="$(kubectl config get-contexts -o name |sk)" && [[ -n "$context" ]] && k9s --context "$context"'
alias kc='context="$(kubectl config get-contexts -o name |sk)" && [[ -n "$context" ]] && kubectl config use-context "$context"'
alias awsp='profile="$(aws configure list-profiles | sk)" && [[ -n "$profile" ]] && export AWS_PROFILE="$profile"'

source "/Users/JWATKDK/.sdkman/bin/sdkman-init.sh"

function dev-env() {
  docker run -v ~/.saml2aws:/root/.saml2aws -v ~/.aws:/root/.aws -v ~/.config:/root/.config -v "$PWD":/src -it dev-env:$1 /bin/bash
}

complete -F __start_kubectl k

function showcert() {
  nslookup $1
  (openssl s_client -showcerts -servername $1 -connect $1:443 <<< "Q" | openssl x509 -text | grep -iA2 "Validity")
}

# Variables

## Names
user=$(whoami)
hostname=$(hostname | sed 's/.local//g')

## Version of OS X
version="OS X $(sw_vers -productVersion)"

## Version name
versionNumber=$(sw_vers -productVersion) # Finds version number

versionMajor=`echo $versionNumber | cut -d'.' -f1`
versionMinor=`echo $versionNumber | cut -d'.' -f2`
versionShort="${versionMajor}.${versionMinor}"


## en1 or en0 should contain the ip address
ipAddressInternal=`ipconfig getifaddr en1`
if [ -z "$ipAddressInternal" ]; then
    ipAddressInternal=`ipconfig getifaddr en0`
fi


case $versionShort in
    11.4)
	versionString="Big Sur"
	;;
    10.15)
        versionString="Catalina"
        ;;
    10.14)
        versionString="Mojave"
        ;;
    10.13)
        versionString="High Sierra"
        ;;
    10.12)
        versionString="Sierra"
        ;;
    10.11)
        versionString="El Capitan"
        ;;
    10.10)
        versionString="Yosemite"
        ;;
    10.9)
        versionString="Mavericks"
        ;;
    10.8)
        versionString="Mountain Lion"
        ;;
    10.7)
        versionString="Lion"
        ;;
    10.6)
        versionString="Snow Leopard"
        ;;
    10.5)
        versionString="Leopard"
        ;;
    10.4)
        versionString="Tiger"
        ;;
    10.3)
        versionString="Panther"
        ;;
    10.2)
        versionString="Jaguar"
        ;;
    10.1)
        versionString="Puma"
        ;;
    10.0)
        versionString="Cheetah"
        ;;
esac

## Kernal
kernel=$(uname)

## Uptime
uptime=$(uptime | sed 's/.*up \([^,]*\), .*/\1/')

## Shell
shell="$SHELL"

## Terminal
terminal="$TERM"

## Number of packages installed via Homebrew
# packages="`brew list -l --formula | wc -l | awk '{print $1 }'`"

## CPU Type
cpu=$(sysctl -n machdep.cpu.brand_string)

## Memory Amount
mem=$(sysctl -n hw.memsize)
ram="$((mem/1073741824)) GB"

## Disk usage
disk=`df -l -H | head -3 | tail -1 | awk '{print $5}'`

ponies=("twilight", "trixie", "pinkie", "fluttershy", "rainbow", "pinkiecannon")
paste -d' ' <(ponysay --pony-only --pony ${ponies[$(jot -r 1 0) % ${#ponies[@]} ]}) <(echo "
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
expressions=("Notice me senpai", "dessu dessu", "baka baka baka", "nani")
#say -v Kyoko "${expressions[$(jot -r 1 0) % ${#expressions[@]} ]}"

#say -v Kyoko Notice me senpai

function gprunemerged() {
    main=$(git remote show origin | sed -n "/HEAD branch/s/.*: //p")
    git checkout "$main" && git fetch --all --prune && git pull && git branch -vv | grep -v "$main" | grep ": gone" | awk '{print $1}' | xargs -n 1 git branch -D
}

alias updatefork='git fetch --all --prune && git rebase upstream/master && git push'
alias updateforkmain='git fetch --all --prune && git rebase upstream/main && git push'

# Run twolfson/sexy-bash-prompt
# Run twolfson/sexy-bash-prompt
. "$HOME/.cargo/env"
source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
source /opt/homebrew/opt/chruby/share/chruby/auto.sh
chruby ruby-3.4.1

. "$HOME/.local/bin/env"
