#!/usr/bin/env bash

set -e

log(){ 
  echo -e "$(tput setaf 2)> $*$(tput sgr0)" 
}

warn(){ 
  echo -e "$(tput setaf 1)> $*$(tput sgr0)" 
}

header(){
  echo
  echo -e "$(tput bold)$(tput setaf 6)### $* ###$(tput sgr0)"
  echo
}

ensure_symlink(){
  local source=$1
  local destination=$2

  if [ -f "$destination" ]
  then
    log "$destination is already symlinked"
  else
    log "Symlinking $source to $destination"
    ln -s "$source" "$destination"
  fi
}

ensure_directory(){
  local dir_path=$1

  if [ -d "$dir_path" ]
  then
    log "$dir_path already exists"
  else
    log "$dir_path does not exist. Creating."
    mkdir -p $dir_path
  fi
}

ensure_repo(){ 
  local repo_path=$1
  local repo_url=$2
  local repo_branch${3-master}
  
  ensure_directory $repo_path
  
  (
    cd "$repo_path"
    if git rev-parse --is-inside-work-tree > /dev/null && [ "$repo_path" =  "$(git rev-parse --show-toplevel)" ]
    then
      log "$repo_path is a already a git repository. Updating."
      git pull origin $repo_branch
    else
      log "$repo_path isn't a git repository. Creating."
      git clone "$repo_url" "$repo_path"
    fi
  )
}

header "Setting up config files"

# Config files
ensure_symlink ~/dotfiles/vimrc ~/.vimrc
ensure_directory ~/.config/nvim
ensure_symlink ~/dotfiles/nvimrc ~/.config/nvim/init.vim
ensure_symlink ~/dotfiles/ideavimrc ~/.ideavimrc
ensure_symlink ~/dotfiles/zshrc ~/.zshrc
ensure_symlink ~/dotfiles/gitconfig ~/.gitconfig
ensure_symlink ~/dotfiles/gitconfig-macos ~/.gitconfig-macos
ensure_symlink ~/dotfiles/gitignore ~/.gitignore
ensure_symlink ~/dotfiles/gemrc ~/.gemrc
ensure_symlink ~/dotfiles/tmux.conf ~/.tmux.conf
# ensure_symlink ~/dotfiles/vscode.json ~/Library/Application\ Support/Code/User/settings.json

header "Setting up packages"

# Shell
ensure_repo ~/.oh-my-zsh https://github.com/robbyrussell/oh-my-zsh.git
ensure_repo ~/.oh-my-zsh/custom/plugins/pure https://github.com/sindresorhus/pure.git main
ensure_repo ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting.git 

# Vim
ensure_repo ~/.vim/bundle/Vundle.vim https://github.com/VundleVim/Vundle.vim.git

# NeoVim
ensure_repo ~/.config/nvim/bundle/Vundle.vim https://github.com/VundleVim/Vundle.vim.git

# PlugInstall, I haven't removed vundle yet
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# Ruby
ensure_repo ~/.rbenv https://github.com/sstephenson/rbenv.git
ensure_repo ~/.rbenv/plugins/ruby-build https://github.com/sstephenson/ruby-build.git

if [ "$(uname -s)" = "Darwin" ]; then
  ensure_repo ~/src/github.com/burke/minidev https://github.com/burke/minidev.git
fi
# Node
#ensure_repo ~/.nvm https://github.com/creationix/nvm.git

# extra local configs
touch  ~/dotfiles/zshrc_extra
