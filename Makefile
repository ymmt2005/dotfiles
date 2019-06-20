FILES = .emacs .gitconfig .bash_aliases .screenrc .tmux.conf .vimrc .Xdefaults

PACKAGES = build-essential manpages-dev glibc-doc git \
	gdb debconf-utils fakeroot devscripts \
	aspell aspell-en jq fonts-ricty-diminished

PWD := $(shell pwd)

all:
	@echo Making symlinks to dotfiles...
	for f in $(FILES); do \
		rm -f $$HOME/$$f; \
		ln -s $(PWD)/$$f $$HOME/$$f; \
	done

	@echo Insert hooks...
	if ! grep -q '^. $(PWD)/.bashrc' $$HOME/.bashrc; then \
		echo ". $(PWD)/.bashrc" >>$$HOME/.bashrc; \
	fi
	if ! grep -q '^. $(PWD)/.profile' $$HOME/.profile; then \
		echo ". $(PWD)/.profile" >>$$HOME/.profile; \
	fi
	if ! grep -q '^    . $$HOME/.profile.local' $$HOME/.profile; then \
		echo 'if [ -f $$HOME/.profile.local ]; then' >>$$HOME/.profile; \
		echo '    . $$HOME/.profile.local' >>$$HOME/.profile; \
		echo 'fi' >>$$HOME/.profile; \
	fi

setup:
	@echo Install packages...
	sudo apt-get -y install --no-install-recommends $(PACKAGES)

.PHONY:	all setup
