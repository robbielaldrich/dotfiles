---
name: review-diff
description: Open a TUI for the user to review Claude's uncommitted diff. When the user finishes their review and exports it, implement their requested changes. Use when the user says "review-diff", "let me review", "open review TUI", or wants to inspect and comment on the current diff before committing. Also invoke automatically whenever you have just finished implementing all of your planned code changes — give the user a chance to review the diff before you consider the task done.
---

`tuicr` draws its TUI to a terminal (`/dev/tty`) and writes the exported review to stdout. The Bash tool runs without a controlling TTY, so launching `tuicr` directly there fails with "Device not configured (os error 6)". Use the approach below.

## Inside tmux (preferred)

Check `$TMUX`. If set, run `tuicr` in a fresh tmux window (its own TTY), capture the export to a file, and block until the user finishes.

1. Write the wrapper script `/tmp/tuicr_review.sh` (set the working directory to the repo being reviewed):

```bash
#!/bin/bash
cd <REPO_DIR> || exit 1
rm -f /tmp/tuicr_done /tmp/tuicr_result.txt /tmp/tuicr_err.txt
tuicr -w --stdout --theme tokyo-night-storm > /tmp/tuicr_result.txt 2> /tmp/tuicr_err.txt
echo "EXIT:$?" > /tmp/tuicr_done
```

2. Open it in a new tmux window (this focuses the window so the user can review). The tmux socket is often blocked by the Bash sandbox ("Operation not permitted"), so run this with the sandbox disabled:

```bash
rm -f /tmp/tuicr_done; tmux new-window -n tuicr-review 'bash /tmp/tuicr_review.sh'
```

3. Tell the user the TUI is open, then block here until they export (Bash timeout 900000 ms):

```bash
for i in $(seq 1 900); do [ -f /tmp/tuicr_done ] && break; sleep 1; done
[ -f /tmp/tuicr_done ] && cat /tmp/tuicr_result.txt || echo "TIMEOUT"
```

## Outside tmux (fallback)

If `$TMUX` is not set, ask the user to run it themselves so the TUI gets a real terminal:

```
! tuicr -w --stdout --theme tokyo-night-storm
```

Its stdout (the exported review) lands in the conversation.

## After the review

Read the output carefully — it contains the user's inline comments and change requests on the diff. Comments typed NOTE are observations and may need no change. Implement every requested change.

After implementing all changes, give a concise summary of what you changed and why (one line per change).
