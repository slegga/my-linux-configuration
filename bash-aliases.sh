#sudo apt install libsource-highlight-common source-highlight
#dpkg -L libsource-highlight-common | grep lesspipe
export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
# sudo apt install exa
alias rm="rm -v"
alias less="less -R"
alias reload="cd ~/ansible;ansible-playbook -i hosts update.yml -K -t mojo"
if [ "$(command -v exa)" ]; then
    unalias -m 'll'
    unalias -m 'l'
    unalias -m 'la'
    unalias -m 'ls'
    alias ls='exa -G  --color auto --icons -a -s type'
    alias ll='exa -l --color always --icons -a -s type'
else
    alias ll="ls -la"
fi
