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

Claude Code agents and skills
-----------------------------

`.claude/agents/` and `.claude/skills/` hold review agents and skills for Claude Code.
`make` does not install them.
Copy them into a project's `.claude/`, or into `$HOME/.claude/` to use them everywhere.
A personal skill overrides a project skill with the same name, so do not install one that a project already has.

* `hunt-bugs` skill, with the `bug-hunter`, `attack-refuter` and `bug-verifier` agents

    Hunts correctness bugs in a code change in three stages.

* `code-quality-reviewer` agent

    Reviews a code change for its long-term cost.

* `architect-reviewer` agent

    Reviews a change or a design from an architect's view.

License
-------

[The Unlicense](http://unlicense.org/).
