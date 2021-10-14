# Enable Powerlevel10k instant prompt. Should stay at the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export EDITOR=vim
export TERM="xterm-256color"
export PATH=$PATH:~/.scripts/:~/documents/notebook/scripts:~/.local/bin:/opt/rocm/bin:/opt/rocm/rocprofiler/bin:/opt/rocm/opencl/bin:~/code/source/sage/local/bin:/home/travis/code/source/opentrack/build/install/bin
export PYTHONPATH=$PYTHONPATH:/home/travis/code/temp

export HISTFILE=~/.zsh_history
export HISTSIZE=50000
export SAVEHIST=10000
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt share_history          # share command history data

autoload -Uz compinit $$ compinit

if [ -f ~/.aliases ]; then
  . ~/.aliases;
fi


####################################Plugins####################################
source ~/.zsh_plugins/powerlevel10k/powerlevel10k.zsh-theme

source ~/.zsh_plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey '^[OA' history-substring-search-up
bindkey '^[OB' history-substring-search-down


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

# Finalize Powerlevel10k instant prompt. Should stay at the bottom of ~/.zshrc.
(( ! ${+functions[p10k-instant-prompt-finalize]} )) || p10k-instant-prompt-finalize
