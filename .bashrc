# -*- mode: sh -*-

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

git_branch() {
        echo $(git branch 2>/dev/null | sed -rn "s/^\* (.*)$/\1/p")
}
kube_prompt() {
   kubectl_current_context=$(kubectl config current-context 2>/dev/null || true)
   kubectl_project=$(echo $kubectl_current_context | cut -d '_' -f 2)
   echo "k8s($kubectl_project)"
}

#PS1='\[\033[32m\]\h\[\033[00m\]:\[\033[01;34m\]$(git_branch)\[\033[00m\]:$(kube_prompt):\w\$ '
PS1='\[\033[32m\]\h\[\033[00m\]:\[\033[01;34m\]$(git_branch)\[\033[00m\]:\w\$ '

#export LESS="-XF"
export EDITOR=vi
export GOPATH=$HOME/go
export GO111MODULE=on
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
export ANDROID_HOME=$HOME/android-sdk
export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH
PATH=$HOME/flutter/bin:$HOME/go/bin:/usr/local/go/bin:$HOME/.local/bin:$PATH
umask 022

if [ -n "$WSL_DISTRO_NAME" ]; then
    export BROWSER='/mnt/c/Windows/System32/rundll32.exe url.dll,FileProtocolHandler'
fi

if [ -f $HOME/.bashrc.local ]; then
    . $HOME/.bashrc.local
fi
