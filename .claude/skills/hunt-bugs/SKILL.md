---
name: hunt-bugs
description: Hunt for correctness bugs in a code change in three stages, the bug-hunter agent, the attack-refuter agent on the hunter's "Attacks that failed" and "Unconfirmed", and the bug-verifier agent on every finding, and report the bugs that hold. Use whenever the user asks to hunt bugs, bug-check, or find bugs in a commit range, branch, PR or uncommitted change, and after each implementation step in place of a lone bug-hunter run. Not for maintainability (code-quality-reviewer) or design (architect-reviewer).
---

# Hunt bugs

One bug hunter reaches many bugs and then talks itself out of some of them: it lists them under "Attacks that failed" with an argument that sounds safe but is wrong.
A second agent that starts fresh and attacks only that list overturns many of those arguments.
A third agent then checks every finding, because the first two also report bugs that are false or not worth fixing.

## 1. Write the brief

Every stage gets the same brief, which names these:

- **What to review**: a commit range in a worktree (`<base>..HEAD`), a PR's head commit, or the uncommitted diff.
  For a PR, check out its head in a detached worktree so the agents read the code as it is.
- **Where the intent is**: the commit messages, the PR body (`gh pr view <n> --json body`), a linked issue, the design doc.
- **What to follow**: the project's instructions (CLAUDE.md and the references it names, such as a list of common pitfalls).
- **What to skip**: generated files, such as `*.pb.go`, `*_gen.go`, and generated docs and manifests.
  Do not skip a generated file that runs or ships and may be edited by hand, such as a database migration.
- **Constraints**: the worktree stays unedited, and probe files go in a scratchpad directory you name.
  Say which tests may run, from the project's instructions.
  The agents run in parallel, so a test that uses shared state, such as fixed container names or ports, a shared test database, or a paid external API, may run in at most one of them.
  Check what a test does when its setup is missing: it may skip, or it may fall back to a shared or real system.

The brief carries no conclusions: no suspected bugs, no "this part is fine", no hints.
A hint anchors the agent on your view, and an independent read is the point of running it.

## 2. Stage 1: bug-hunter

Launch the `bug-hunter` agent with the brief, in the background.
For a step of your own work, launch the `code-quality-reviewer` agent with the same brief at the same time; it covers a different job.
Its findings skip the next two stages, except its one-line bug notes, which go to the verifier with the other bugs.

## 3. Stage 2: attack-refuter

When the hunter reports, copy its **Attacks that failed** and **Unconfirmed** sections verbatim.
Launch the `attack-refuter` agent with the brief and those lists.
Leave out the rest of the hunter's report, so the refuter judges each claim on its own.
If both lists are empty, skip this stage.

## 4. Stage 3: bug-verifier

The first two stages find many real bugs, and also some that are false or not worth fixing.
An independent verifier filters those out.

Collect the Blocking and Should fix bugs from both stages, each once: when both stages report the same bug, keep the version with the stronger trigger or proof.
Give each an id, and copy each report's file, line, trigger and claimed effect as the agent wrote them.
Launch the `bug-verifier` agent with the brief and that list.
Leave out your own view of which reports hold.
For a PR, also give it the maintainers' decisions from its resolved review threads, such as "by design" answers (`gh api graphql` on `reviewThreads`), quoted as they wrote them: a report that a maintainer already declined is not a bug for this change.
Give these to the verifier only, never to the first two stages, which must judge the code without them.

## 5. Report

- Report only the bugs the verifier rated REAL, as **Blocking** or **Should fix**, each with its file and line, trigger, effect and fix, and which stage found it.
- List the TRIVIAL ones in one line each, with the verifier's reason, so the user can overrule it.
  Leave out the ones that a maintainer already declined.
- Leave out the FALSE ones, but say how many there were.
- Add the hunter's **Unconfirmed** items that the refuter neither triggered nor showed false, and say which parts the hunter said got less attention.
- For a step of your own work, add the code-quality-reviewer's findings in their own section.
- Before you act on a Blocking bug, read the code it points at and check the trigger yourself.
