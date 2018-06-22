install () {
    prove -l 2>&1 >/tmp/git-install.txt
    SUCCESS=$(grep successful /tmp/git-install.txt)
    if [ -z $SUCCESS ]; then
        cat /tmp/git-install.txt
    else
        git push
    fi
}

_cdg_complete () {
  local cur prev
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"

  if [ $prev = "cdg" ]; then
    COMPREPLY=( $(compgen -W "$(ls -d $HOME/git/*/| perl -pe 's/^.+?\/([^\/]+)\/*$/$1/')" -- $cur) );
    return 0
  fi
}

complete -F _cdg_complete cdg

cdg () {
    cd $HOME/git/$1;
    git config credential.helper 'store'
    git status >/tmp/git-status.txt
    UMERGE=$(grep Unmerge /tmp/git-status.txt)
    if [ -z $UNMERGE ]; then
        git pull
        prove -l
    else
        cat /tmp/git-status.txt
   fi
}
