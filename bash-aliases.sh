#sudo apt install libsource-highlight-common source-highlight
#dpkg -L libsource-highlight-common | grep lesspipe
if [ "$(command -v src-hilite-lesspipe.sh)" ]; then
    export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
fi
# sudo apt install exa
alias rm="rm -v"
alias less="less -R"
alias reload="cd ~/ansible;ansible-playbook -i hosts update.yml -K -t mojo"
# if [ "$(command -v exa)" ]; then
#    unalias 'll'
#    unalias -m 'l'
#    unalias -m 'la'
#    unalias 'ls'
#    alias ls='exa -G  --color auto --icons -a -s type'
#    alias ll='exa -l --color always --icons -a -s type'
#else
    alias ll="ls -la"
    alias lt="ls -ltr"
#fi
