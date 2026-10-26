---
description: Create or change agent instructions in AGENTS.md and OpenSpec config.yaml; keep AGENTS.md general and OpenSpec-agnostic, config.yaml OpenSpec-specific, and no rule stated twice. Use when updating AGENTS.md, openspec/config.yaml, or instruction files.
---

Create or change `AGENTS.md` and `openspec/config.yaml` according to $ARGUMENTS. While doing so, refer to:

- https://agents.md/
- https://aaif.io/blog/writing-an-effective-agents-md
- https://openspec.dev/docs/project-config

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

## The split: AGENTS.md vs openspec/config.yaml

- `AGENTS.md`: general standing rules for the whole repo, loaded by every agent. Must stay OpenSpec-agnostic: never mention changes, artifacts, tasks, apply, or archive.
- `openspec/config.yaml` `context`: OpenSpec-specific instructions and standing rules. Injected into every artifact creation and into apply and archive. This field is what lets AGENTS.md stay agnostic.
- `rules.<artifact>`: rules applied only when that artifact (proposal, specs, design, tasks) is created. One short line each.
- `operations.<step>.guidance`: how to carry out `apply` and `archive`.

## Store-backed config

- A repository that declares `store: <id>` in its `openspec/config.yaml` has that file ignored; the store's own `openspec/config.yaml` is the only OpenSpec config read. Edit the store file, never the repository's.
- The store file serves every repository that declares it, so it stays repo-neutral: no repository, stack or environment names. Repo-specific text goes into that repository's instructions.
- Repo instructions may live out of tree, in `OPENCODE_CONFIG_DIR` (see "Where instructions live"). Never edit a team-owned `AGENTS.md` in the repository for personal workflow text.
- Append `--store <id>` to every `openspec` command in the verify step.

## No duplication

- State every rule in exactly one file. Whatever is in `AGENTS.md` must NOT be restated in `config.yaml` `context`: both reach the agent's prompt, so a repeated rule appears twice.
- When config.yaml needs an AGENTS.md rule, reference it by name ("the project's verification split"), never rephrase it.
- Triage question per rule: does it bind agent behavior in this repo generally (AGENTS.md), or only OpenSpec workflows and artifacts (config.yaml)?
- Apply standing rules to the files being edited too: if the repo demands pure ASCII, the edits and the edited file comply.

## Gotchas

- config.yaml plain scalars: a value starting with a double quote is parsed as a quoted string and breaks the whole file (openspec warns "could not parse ... ignoring it"). A colon-space inside a plain scalar turns the item into a mapping and openspec drops that rule ("must be an array of strings"). Multi-line text goes into a block scalar (`context: |`).
- openspec silently ignores a config.yaml that fails to parse: the only sign is the warning on the next `openspec instructions` call.
- AGENTS.md edits reach agents only in a new session; config.yaml edits reach openspec commands on the next invocation.

## Verify before finishing

1. Run `openspec instructions <artifact> --change <change> --json` (with `--store <id>` when the store is used) and check: no parse warning in stderr, the new context and rules appear in the output, and nothing from AGENTS.md appears twice.
2. If the repo has a pure-ASCII rule, search the edited files for non-ASCII and convert your own edits.
3. Report which file holds which rule, so a future edit does not move or duplicate it.

## Worked example (from the AiTooling session)

- Privacy boundary and pure-ASCII artifacts: general rules -> `AGENTS.md`.
- "Changes touching the pipeline scripts record the verification split in their artifacts" and "change artifacts contain no document content or docroot paths": OpenSpec-specific -> `config.yaml` `context`.
- The markers "Verify (user)" / "Verify (agent, sandbox)": artifact mechanics -> `rules.tasks`.
- "For Verify (user) tasks, hand the command to the user and mark complete only after their report" and the archive gate: workflow execution -> `operations.apply` / `operations.archive`.
