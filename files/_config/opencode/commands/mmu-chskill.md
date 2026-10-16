---
description: Create or change a skill
---

Create or change a skill according to $ARGUMENTS. While doing so, refer to:

- https://agentskills.io/specification
- https://agentskills.io/skill-creation/optimizing-descriptions
- https://agentskills.io/skill-creation/best-practices#patterns-for-effective-instructions
- https://agentskills.io/skill-creation/using-scripts

## Mandatory rules

1. **Scripts are relative to the skill directory.** If the skill has a `scripts/` directory, its `SKILL.md` MUST
   state that script paths are relative to the skill directory (the folder containing `SKILL.md`), and MUST list
   each script with a one-line purpose. Show commands as `<skill-dir>/scripts/<name>` and tell the agent to resolve
   them to absolute paths before running. Do not hardcode absolute paths or assume the working directory is the
   skill directory (scripts often need the user's repository as the working directory).
2. **Validate with `skills-ref` through uvx** after every create or change, and fix every reported error before
   finishing. The directory name must equal the frontmatter `name`:
   ```bash
   uvx --from "git+https://github.com/agentskills/agentskills#subdirectory=skills-ref" skills-ref validate <skill-dir>
   ```
   Expect `Valid skill: <skill-dir>` and exit code 0. Do not pin a version or commit; always use the latest.
3. **Never write credentials to files.** Scripts read secrets from environment variables and exit with code != 0

## Script checks

- Run `uv run <skill-dir>/scripts/<name> --help` and one real invocation; confirm JSON/data goes to stdout and
  diagnostics to stderr.
- Scripts must not prompt interactively and must document exit codes in `--help`.
