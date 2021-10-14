#!/bin/bash

SETUP_SHELL=0
UPDATE_FILES=1
UPDATE_GIT=1
INIT_GIT=1
INSTALL_FONT=1

GIT=`dirname "$(readlink -f "$0")"`
PM="sudo apt install"

if [ "$SETUP_SHELL" -eq 0 ]
then
  echo "Install ZSH using your package manager."
  read -n 1 -s -r -p "Press any key to continue.."
  chsh -s /bin/zsh $USER
fi


if [ "$UPDATE_FILES" -eq 0 ]
then
  echo "Copying files and folders to home directory..."
  ### copy files/folders
  IFS=$'\n' #newline only separator
  for file in $(cat < in_home)
  do
    path=${file/$(basename $file)/""}
    echo $path
    if [ ! -d "/home/$USER/$path" ]
    then
      echo "mkdir -p "/home/$USER/$path""
    fi
    rsync -r $GIT/$file $HOME/$file
  done
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
    cd "/home/$USER/$dir"
    git pull
    cd $cur_dir
  done
fi

if [ "$INIT_GIT" -eq 0 ]
then
  echo "Cloning git repositories..."
  IFS=$'\n'
  for line in $(cat < git_repos)
  do 
    cur_dir=$(pwd)
    full_dir=${line%" "*}
    name=$(basename $full_dir)
    base_dir=${full_dir%/*}
    url=${line#*" "}
    if [ -! -d "$full_dir" ]
    then
      mkdir -p "/home/$USER/$base_dir"
      cd /home/$USER/$base_dir
      git clone $url
    fi
  done
fi

if [ "$INSTALL_FONT" -eq 0 ]
then
  echo "Installing Meslo Nerd Font patched for Powerlevel10k"
  mkdir -p "/home/$USER/.local/share/fonts/truetype/MesloLG NF"
  cur_dir=$(pwd)
  cd "/home/$USER/.local/share/fonts/truetype/MesloLG NF"
  wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
  wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
  wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
  wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
  cd "$cur_dir"
  fc-cache
fi

