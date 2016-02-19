#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias aslrar='rar a -m0 -rr3p'
alias cp='cp --reflink=auto'
alias nano='nano -w'
alias wine32='WINEPREFIX=/home/azure/.wine32 wine'
alias ssh-zacate='ssh -p 12310 192.168.178.2'
alias ssh-vault='ssh -p 12311 192.168.178.222'

PATH="$(ruby-1.9 -e 'print Gem.user_dir')/bin:$PATH"

# Load in the git branch prompt script.
source ~/.scripts/git-prompt.sh
PS1="\[$(tput bold)\]\[$(tput setaf 4)\][\[$(tput setaf 6)\]\u\[$(tput setaf 4)\]@\[$(tput setaf 7)\]\h \[$(tput setaf 2)\]\W\[$(tput setaf 4)\]]\[$MAGENTA\]\$(__git_ps1)\\$ \[$(tput sgr0)\]"
