alias grep='grep --exclude-dir=.git'
alias g=git
alias man='PAGER=less man'
gd() {
    godoc "$@" | less
}
dgc() {
    docker ps -aq | xargs docker rm
    docker rmi $(docker images -f dangling=true -q)
}
alias mssh='ssh -o UserKnownHostsFile=/dev/null'
