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
PS1='[\u@\h \W]\$ '
