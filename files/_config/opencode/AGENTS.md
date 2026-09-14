## The "bash" tool

- Use tools over bash.
- Keep diversity of bash tools small
  - use `sed` instead of grep, head, tail, and-so-on. These are examples,
    complete the list yourself.
  - use `uv run` over `python3`
  - global options a forbdden - use `cd ~/foo && git status` over
    `git -C ~/foo status`. The same for all other git commands.

## User Interaction

- When providing commands for copy/paste, use clean one-line command lines, no
  line contiuation with `\\`

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
- **Auto-formatting is enabled.** Do not fight the formatters, accept the standard
  format.
