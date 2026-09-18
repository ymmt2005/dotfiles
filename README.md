dotfiles
========

This is my private (but not secret) dot files.

`Makefile` is included to setup them.

Make targets
------------

* `make setup`

    Install debian packages.

* `make all`

    Install dot files under $HOME. This also runs `make claude`.

* `make claude`

    Install the Claude Code status line: symlinks
    `.claude/statusline-command.sh` into `$HOME/.claude/` and merges
    `.claude/statusline.json` into `$HOME/.claude/settings.json`
    (requires `jq`).

Usage
-----

Run `make setup` and `make` on Debian or Ubuntu systems.

You must be able to use `sudo`.

There are some optional files you may create to write per-host configurations.

* `$HOME/.profile.local`

    If exists, read from `$HOME/.profile` upon logon.

* `$HOME/.gitconfig.private`

    If exists, read from `$HOME/.gitconfig`.

License
-------

[The Unlicense](http://unlicense.org/).
