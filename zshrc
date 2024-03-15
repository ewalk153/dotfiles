# Oh-my-zsh
ZSH=$HOME/.oh-my-zsh
plugins=(zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# Pure theme
source ~ZSH_CUSTOM/plugins/pure/async.zsh
source ~ZSH_CUSTOM/plugins/pure/pure.zsh
PURE_GIT_PULL=0

# setup rust, cargo
PATH="$HOME/.cargo/bin:$PATH"

# setup go
export GOPATH=$HOME
export PATH=$GOPATH/bin:$PATH


# aliases
alias vim='nvim'

# Set editor
export EDITOR=nvim

# exports for build env
export PATH="/usr/local/opt/libxml2/bin:$PATH"

[[ -x /opt/homebrew/bin/brew ]] && eval $(/opt/homebrew/bin/brew shellenv)

[ -f /opt/dev/dev.sh ] && source /opt/dev/dev.sh

[[ -f /opt/dev/sh/chruby/chruby.sh ]] && { type chruby >/dev/null 2>&1 || chruby () { source /opt/dev/sh/chruby/chruby.sh; chruby "$@"; } }
