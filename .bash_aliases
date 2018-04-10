alias grep='grep --exclude-dir=.git'
alias g=git
alias man='PAGER=less man'
gd() {
    godoc "$@" | less
}
dgc() {
    docker ps -aq | xargs docker rm
}
