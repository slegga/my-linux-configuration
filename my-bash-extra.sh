export PATH=$PATH:~/bin
alias perldebug='/usr/bin/env perl -S -d:ptkdb'
source ~/git/my-linux-configuration/bash-functions.sh
source ~/git/my-linux-configuration/bash-aliases.sh

alias realias="${EDITOR:-vim} ~/git/my-linux-configuration/bash-aliases.sh; source ~/git/my-linux-configuration/bash-aliases.sh"
