FILES = .gitconfig .bash_aliases .screenrc .tmux.conf .vimrc

PACKAGES = build-essential manpages-dev glibc-doc linux-doc git jq \
	gdb debconf-utils fakeroot devscripts
	

PWD := $(shell pwd)

all: claude
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

claude:
	@echo Installing Claude Code status line...
	mkdir -p $$HOME/.claude
	rm -f $$HOME/.claude/statusline-command.sh
	ln -s $(PWD)/.claude/statusline-command.sh $$HOME/.claude/statusline-command.sh
	if [ -f $$HOME/.claude/settings.json ]; then \
		jq -s '.[0] * .[1]' $$HOME/.claude/settings.json $(PWD)/.claude/statusline.json >$$HOME/.claude/settings.json.tmp; \
	else \
		cp $(PWD)/.claude/statusline.json $$HOME/.claude/settings.json.tmp; \
	fi
	mv $$HOME/.claude/settings.json.tmp $$HOME/.claude/settings.json

setup:
	@echo Install packages...
	sudo apt-get -y install --no-install-recommends $(PACKAGES)

.PHONY:	all claude setup
