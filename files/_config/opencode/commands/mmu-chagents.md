---
description: Create or change instructions in AGENTS.md or similar places
---

Create or change a `AGENTS.md` like file according to $ARGUMENTS. While doing so, refer to:

- https://agents.md/
- https://aaif.io/blog/writing-an-effective-agents-md

## Where instructions live

Find the file that is actually loaded before editing. Instruction files are combined, not replaced. On conflict the closest `AGENTS.md` to the edited file wins, and explicit user prompts override all.

1. `~/.config/opencode/AGENTS.md`: global, personal rules. Preferred over `~/.claude/CLAUDE.md`.
2. `AGENTS.md` in the repo, found by walking up from the working directory. `CLAUDE.md` counts only if no `AGENTS.md` exists.
3. `AGENTS.md` in `OPENCODE_CONFIG_DIR`, if set. opencode treats that directory like `~/.config/opencode`, and it loads after the global config and `.opencode/`. Check the environment, shell aliases and wrapper scripts for where it points. It may belong to a repo other than the working directory.
4. Files listed in `instructions` in any `opencode.json(c)`: paths, globs or URLs, relative to the config file. Edit the referenced file instead of copying its content.

## Writing rules

- Keep an instruction only if it changes what the agent does. Drop what the repo already shows.
- Be specific: name exact paths and commands, not "run the tests".
- Point to existing docs instead of copying them. State each rule in one place.
- Leave rules that a formatter, linter or CI enforces to that tool. `AGENTS.md` only names it.
- Add a nested `AGENTS.md` only at a real boundary, such as a different language, build or owner.
- No secrets. Remove instructions that have gone stale.
