export PATH=""

# Load default PATH
if [ -x /usr/libexec/path_helper ]; then eval "$(/usr/libexec/path_helper -s)"; fi
if [ -f /etc/environment ]; then source /etc/environment; fi


# command to burn nix
# sudo diskutil apfs deleteVolume disk1s7 <-- replace that with the disk
# listed in diskutil list

# Oh-my-zsh
ZSH=$HOME/.oh-my-zsh
plugins=(zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# Pure theme
source ~ZSH_CUSTOM/plugins/pure/async.zsh
source ~ZSH_CUSTOM/plugins/pure/pure.zsh
PURE_GIT_PULL=0

# For local customizations
if [ -f ~/.profile ] || [ -h ~/.profile ]; then source ~/.profile; fi

export MONO_GAC_PREFIX="/usr/local"

# Mac-specifics
if [ "$(uname -s)" = "Darwin" ]
then
  # Rebuild the Launch Services database
  # (Gets rid of duplicates in the "Open With" submenu)
  alias fixopenwith='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user'

  # Aliases
  alias core-only='dev integration disable web ShopifyUS/cardsink ShopifyUS/cardserver ShopifyUS/hosted-fields payment-service online-store-web'
  alias core-subs='dev integration enable web ShopifyUS/cardsink ShopifyUS/cardserver ShopifyUS/hosted-fields payment-service online-store-web'
  alias mou='open -a mou'
  alias subl='open -a "Sublime Text"'
  alias marked='open -a "Marked 2"'
  alias gitbox='open -a "Gitbox"'
  alias open-audacity='open /Applications/Audacity.app/Contents/MacOS/Audacity'
  alias ff='vim $(fzf)'
  # Add Homebrew to PATH
  if [ -d "/usr/local/Cellar" ]
  then
    PATH="/usr/local/bin:/usr/local/sbin:$PATH"
  fi

  # Add Postgres.app to PATH
  if [ -d /Applications/Postgres.app ]
  then
    PATH="/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH"
  fi
fi

# Add Cargo binaries to PATH
PATH="$HOME/.cargo/bin:$PATH"

# Add Yarn binaries to PATH
PATH="$HOME/.yarn/bin:$PATH"

# setup go stuff
export GOPATH=$HOME
export PATH=$GOPATH/bin:$PATH

# Git commands
alias gitroot='cd "$(git rev-parse --show-toplevel)"'
function strip-diff {
  (
    set -e
    cd "$(git rev-parse --show-toplevel)"
    git diff-files --name-only -0 | while read line; do
      target="/tmp/$(git hash-object -- $line)-stripped"
      git stripspace < "$line" > "$target"
      cat "$target" > "$line"
      rm "$target"
    done
  )
}

# Simpler Bundler
function b {
  { bundle check > /dev/null || bundle install } && bundle exec $*
}
function bundle-show {
  bundle info $1 --path
}
function vim-bundle {
  cd $(bundle-show $1); vim
}

function jzf {
  jq . $* | fzf
}

# Misc
alias serve='ruby -run -e httpd . -p 9090'
alias venv='source ./virtualenv/bin/activate'
alias runtest='b ruby -I ./test'
alias volmer='b rubocop $(git diff-files --name-only -0)'
alias irb='irb -r "irb/completion"'
alias wat='TDD=0 SKIP_BOOTSTRAP=1 PRY=1 DONT_HELP_MY_COWORKERS_MAKE_EVIDENCE_BASED_DECISIONS=1 DISABLE_SPRING=1 DISABLE_PEEK=1'
alias clear-elasticsearch='curl -X DELETE "http://localhost:9200/*/"'
alias kill-railgun='railgun status -a | tail -n +2 | cut -d " " -f1 | xargs -n 1 railgun stop'
alias kill-dev-sv="dev sv status | awk '{ if (NR!=1) { print $1 } }' | xargs -n1 bash /opt/dev/dev.sh sv stop"
alias vim='nvim'
alias clear-yarn="ruby -r json -r fileutils -e \"JSON.parse(File.read('config/npm_packages.json')).each { |dir| FileUtils.rm_rf(dir + '/node_modules') }\" && yarn cache clean"
alias update-tags="git ls-files | rg '\.rb$' | xargs ctags"
alias test-branch="git diff --name-only --diff-filter=AMR origin/master | grep _test.rb | xargs bin/rails test"
function inspect-cert {
  openssl x509 -noout -text -in $1
}

function inspect-csr {
  openssl req -noout -text -in $1
}

# Get rid of autocorrection
unsetopt correct_all

# switching to manual dev init
# run load-dev
# if [ -f /opt/dev/dev.sh ]
# then
#   source /opt/dev/dev.sh
# else
#   load-rbenv
#   load-nvm
# fi

# Set editor
export EDITOR=nvim

# Use FZF if it's around
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
# export PATH="$PATH:$HOME/.rvm/bin"
export PATH="/usr/local/opt/libxml2/bin:$PATH"
export SKIP_RAILGUN_CHECK=1

if [ -e /Users/ericwalker/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/ericwalker/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
export PATH="/usr/local/opt/libpq/bin:$PATH"
export PICO_SDK_PATH="/Users/ericwalker/src/github.com/raspberrypi/pico-sdk"

[[ -f /opt/dev/sh/chruby/chruby.sh ]] && type chruby >/dev/null 2>&1 || chruby () { source /opt/dev/sh/chruby/chruby.sh; chruby "$@"; }
if [ -n "$BASH_VERSION" ] || [ -n "$ZSH_VERSION" ]; then
  if [ -f /usr/local/share/chruby/chruby.sh ]; then
    source /usr/local/share/chruby/chruby.sh
  fi
fi
if [ "$(uname -s)" = "Darwin" ]; then
  if [ -f /usr/local/share/chruby/auto.sh ]; then
    source /usr/local/share/chruby/auto.sh
  fi
  if [ -f /opt/dev/dev.sh ]; then
    # dev already handled above
  elif [ -f ~/src/github.com/burke/minidev/dev.sh ]; then
    source ~/src/github.com/burke/minidev/dev.sh
  fi
fi
[[ -x /opt/homebrew/bin/brew ]] && eval $(/opt/homebrew/bin/brew shellenv)

[ -f /opt/dev/dev.sh ] && source /opt/dev/dev.sh


eval "$(pyenv init --path)"
eval "$(pyenv init -)"
