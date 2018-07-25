#!/bin/bash

echo "Solus Alias Linker"



########
# DEBIAN
########


alias 'apt-get'=eopkg
alias 'sudo apt-get'='sudo eopkg'	#not working


######
# ARCH
######

alias 'pacman -S'=eopkg


#######
# DOS
#######

alias dir=ls
alias copy=cp
alias move=mv
alias rename=mv
alias md=mkdir
alias rd=rmdir
alias del="rm -i"
alias cls=clear


#######
#NOTES
#######

# View all current aliases:
# alias -p

# Remove all aliases:
# unalias -a









