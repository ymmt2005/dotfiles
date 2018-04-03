# -*- mode: sh -*-

export EDITOR=vi
export PAGER=less

git_branch() {
        echo $(git branch 2>/dev/null | sed -rn "s/^\* (.*)$/\1/p")
}
PS1='\[\033[32m\]\h\[\033[00m\]:\[\033[01;34m\]$(git_branch)\[\033[00m\]:\w\$ '
