# -*- mode: sh -*-

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

git_branch() {
        echo $(git branch 2>/dev/null | sed -rn "s/^\* (.*)$/\1/p")
}
PS1='\[\033[32m\]\h\[\033[00m\]:\[\033[01;34m\]$(git_branch)\[\033[00m\]:\w\$ '
