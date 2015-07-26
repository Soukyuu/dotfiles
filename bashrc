#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias aslrar='rar a -m0 -rr3p'
alias cp='cp --reflink=auto'
alias nano='nano -w'
alias wine32='WINEPREFIX=/home/azure/.local/share/wineprefixes/win32 wine'
PS1='[\u@\h \W]\$ '
