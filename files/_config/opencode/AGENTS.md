## The "bash" tool

Use tools over bash.

- edit every file with Edit or Write, never yq -i, sed -i or redirects.
- use bash only for read-only checks such as kustomize build and yq queries.

- Keep diversity of bash tools small
  - use `sed` instead of grep, head, tail, and-so-on. These are examples,
    complete the list yourself.
  - use `uv run` over `python3`
  - global options a forbdden - use `cd ~/foo && git status` over
    `git -C ~/foo status`. The same for all other git commands.

## User Interaction

- When providing commands for copy/paste, use clean one-line command lines, no
  line contiuation with `\\`
- Decisions come back as short numbered options with one-line, mechanism-level
  consequences. Do the legwork first; expect terse rulings ("opt 1", "confirm")
  and act on them.
- Material prepared for review ships minimal and default-aligned: review
  means deleting what you don't want enforced, not approving values. Flag the
  risk-bearing entries; do not demand line-by-line approval.
- A file the user has reviewed and signed off is read-only afterward. When a
  declared action fails (a device, tool, or API refuses it), report and ask;
  never substitute or narrow the user's decision to keep work moving.
- Git belongs to the user: prepare and verify read-only (status, diff, log);
  commit only on explicit instruction.

## Code Style

- **Minimal, minimal, minimal.** Avoid all boilerplate that does not belong to
  funcionality. No pretty output, no error handling, no elaborate arg parsing.
- **Minimal does not mean obfuscated.** Code shall be idiomatic, not verbose,
  but obfuscating tricks to save lines of code are a no go.
- **Avoid useless variables and functions.** A variable that is referred only
  once, a short function called only once, all this only requests cross
  reference look up from the reader. Instead use perfect Structured Programming.
  No early returns, breaks, exits. Large code block are no problem as long as
  they do not contain surprises.
- **Dependencies express intent idiomatically** — they are welcome when they
  make the code say _what_ happens instead of _how_:
  - `mistralai`: typed content chunks (`DocumentURLChunk`, `ImageURLChunk`),
    `client.chat.parse(response_format=<pydantic model>)`.
  - `pydantic`: `Split`/`Booking` are the parse-time contract — JSON schema for
    Mistral, parse-back type, raw-number cross-checks on construction.
    `Entry`/`Zeile` is the plain ledger shape; a `TypeAdapter(list[Entry])`
    validates the ledger array on every load.
- **Let it crash** (Erlang mantra). No `try/except` anywhere; the original
  exception with its traceback is the error report. No fallback, no graceful
  degradation, no retry. If behavior deviates from the expectation: fail.
  Predictability first.
- **No error handling ≠ no error visibility.** pydantic `ValidationError`
  pinpoints the offending field; the SDK raises precise HTTP errors; the run
  stops at the exact document. The user fixes or removes the file and reruns —
  the ledger (saved after every document) resumes losslessly. The one sanctioned
  `try/except` wraps only the model answer: it records a stub, it never swallows
  (ADR-0016). Everything else — API, network, Belegjahr, unprocessable file
  types — still crashes.
- **Atomic ledger writes.** Temp file + `os.replace` — two lines that make a
  crash mid-write impossible to corrupt the ledger.
- **Constants over configuration.** Model, system prompt, form dicts, GWG
  threshold: top-of-file constants. No CLI options at all — fixed positional
  argv (`process YEAR DIR`, `report YEAR`); the ledger name is the rule
  `ledgerYYYY.json`, wrong invocations crash. The VAT opt-in is a hard-coded
  fact, not a setting.
- **No comments unless the code cannot say it.** Section comments structure the
  file; the rest is code.
- **Comments as memory.** A comment must match the value or code it annotates.
  Anything that once failed carries the failure evidence (error, refusal,
  cause) in its comment, so a future edit does not retry it.
- **Auto-formatting is enabled.** Do not fight the formatters, accept the standard
  format.
