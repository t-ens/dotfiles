#!/usr/bin/env bash

INSTALL_PACKAGES=1
UPDATE_FILES=1
UPDATE_GIT=1
INIT_GIT=1
INSTALL_FONT=1

while getopts asfuimp opt
do
  case $opt in 
    a)
      INSTALL_PACKAGES=0
      UPDATE_FILES=0
      INIT_GIT=0
      INSTALL_FONT=0
      ;;
    s)
      SETUP_SHELL=0
      ;;
    f)
      UPDATE_FILES=0
      ;;
    u)
      UPDATE_GIT=0
      ;;
    i)
      INIT_GIT=0
      ;;
    m)
      INSTALL_FONT=0
      ;;
    p)
      INSTALL_PACKAGES=0
      ;;
  esac
done

if [ "$INSTALL_PACKAGES" -eq 0 ]
then
  info=$(uname -a)
  if [ -n "$(echo $info | grep arch)" ]
  then
    INSCMD="sudo pacman --noconfirm -S"
  elif [ -n "$(echo $info | grep cachyos)" ]
  then
    INSCMD="sudo pacman --noconfirm -S"
  elif [ -n "$(echo $info | grep omv)" ]
  then
    INSCMD="sudo dnf --assumeyes install"
  fi
  $INSCMD git kitty neovim qutebrowser tmux zsh
  sudo chsh -s /bin/zsh $USER
fi

if [ "$INSTALL_FONT" -eq 0 ]
then
  echo "Installing Meslo Nerd Font patched for Powerlevel10k"
  mkdir -p "$HOME/.local/share/fonts/truetype/MesloLG NF"
  cur_dir=$(pwd)
  cd "$HOME/.local/share/fonts/truetype/MesloLG NF"
  wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
  wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
  wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
  wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
  cd "$cur_dir"
  fc-cache
fi

if [ "$INIT_GIT" -eq 0 ]
then
  echo "Cloning git repositories..."
  IFS=$'\n' #newline only separator
  for line in $(cat < git_repos)
  do 
    cur_dir=$(pwd)
    full_dir=${line%" "*}
    name=$(basename $full_dir)
    base_dir=${full_dir%/*}
    url=${line#*" "}
    if [ ! -d "$full_dir" ]
    then
      mkdir -p "$HOME/$base_dir"
      cd $HOME/$base_dir
      git clone $url
    fi
    cd "$cur_dir"
  done

  # Manual install of zenburn theme since the git repo needs to be copied
  git clone https://github.com/phha/zenburn.nvim.git /tmp/zenburn.nvim
  if [ ! -d "$HOME/.config/nvim/lua" ]
  then
    mkdir -p "$HOME/.config/nvim/lua"
  fi
  cp -r /tmp/zenburn.nvim/lua/zenburn "$HOME/.config/nvim/lua/zenburn"
  if [ ! -d "$HOME/.config/nvim/colors" ]
  then
    mkdir -p "$HOME/.config/nvim/colors"
  fi
  cp /tmp/zenburn.nvim/colors/zenburn.lua "$HOME/.config/nvim/colors/zenburn.lua"
  rm -rf "/tmp/zenburn.nvim"

  # Manual installation steps for Thumbfast in MPV
  ln -s "$HOME/.config/mpv/scripts/thumbfast/thumbfast.lua" "$HOME/.config/mpv/scripts/thumbfast/main.lua"
  curl -o "$HOME/.config/mpv/scripts/osc.lua" 'https://raw.githubusercontent.com/po5/thumbfast/refs/heads/vanilla-osc/player/lua/osc.lua'
fi

if [ "$UPDATE_GIT" -eq 0 ]
then
  echo "Updating git repositories..."
  IFS=$'\n'
  for line in $(cat < git_repos)
  do
    cur_dir=$(pwd)
    dir=${line%" "*}
    url=${line#*" "}
    cd "$HOME/$dir"
    git pull
    cd "$cur_dir"
  done

  # Manual install of zenburn theme since the git repo needs to be copied
  git clone https://github.com/phha/zenburn.nvim.git /tmp/zenburn.nvim
  if [ ! -d "$HOME/.config/nvim/lua" ]
  then
    mkdir -p "$HOME/.config/nvim/lua"
  fi
  cp -r /tmp/zenburn.nvim/lua/zenburn "$HOME/.config/nvim/lua/zenburn"
  if [ ! -d "$HOME/.config/nvim/colors" ]
  then
    mkdir -p "$HOME/.config/nvim/colors"
  fi
  cp /tmp/zenburn.nvim/colors/zenburn.lua "$HOME/.config/nvim/colors/zenburn.lua"
  rm -rf "/tmp/zenburn.nvim"

  # Manual update steps for Thumbfast in MPV
  ln -s "$HOME/.config/mpv/scripts/thumbfast/thumbfast.lua" "$HOME/.config/mpv/scripts/thumbfast/main.lua"
  curl -o "$HOME/.config/mpv/scripts/osc.lua" 'https://raw.githubusercontent.com/po5/thumbfast/refs/heads/vanilla-osc/player/lua/osc.lua'
fi

if [ "$UPDATE_FILES" -eq 0 ]
then
  echo "Copying files and folders to home directory..."
  IFS=$'\n'
  for file in $(find . -name git_repos -o -name dotfiles.sh -o -path ./.git -prune -o -type f -print)
  do
    path=${file/%$(basename $file)/""}
    target=$HOME/${path:2}
    if [ ! -d "$target" ]
    then
      mkdir -p "$target"
    fi
    rsync -r --progress "$file" "$target"
  done
fi
