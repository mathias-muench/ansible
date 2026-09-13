---
name: pdf-ocr
description: Extract text from a PDF and attach it in place — native PDFs (visible text layer) to markdown (.md), scanned PDFs to OCR text (.txt). Uses pymupdf + pymupdf4llm + pytesseract.
compatibility: Requires uv and Tesseract with language data (scoop install tesseract tesseract-languages) for OCR. pymupdf, pymupdf4llm (incl. pymupdf-layout/onnxruntime), and pytesseract resolve via uv; no native deps beyond Tesseract.
---

# pdf-ocr

Full loop: extract text from a PDF and embed it as an attachment in the same PDF. Only the target PDF changes — no new or deleted files.

## Detection (deterministic, no heuristics)

- **Native** = first page has visible text (`get_texttrace()` `type == 0`). Extract markdown.
- **Scanned** = no visible text (no text, or only an invisible OCR layer, e.g. Canon `3 Tr`). Render + OCR.

## Run

The script is `scripts/ocr.py` relative to this SKILL.md (i.e. `<skill-dir>/scripts/ocr.py`). Resolve it from this file's own directory — the skill may live in `.opencode/skills/` (project) or `~/.config/opencode/skills/` (global), so never hardcode a project-relative path.

```bash
uv run <skill-dir>/scripts/ocr.py <input.pdf> <lang>
```

`<lang>` is a Tesseract 3-letter code (`deu`, `eng`), not the 2-letter ISO code (`de`).

Example:
```bash
uv run <skill-dir>/scripts/ocr.py IMG_20260728_0001-1.pdf deu
```

- Native PDF → attaches `<stem>.md` (MIME `text/markdown`), via `pymupdf4llm.to_markdown(use_ocr=False)`.
- Scanned PDF → attaches `<stem>.txt` (MIME `text/plain`), via render at native DPI + pytesseract.

## Retrieve

```bash
uv run --with pymupdf python -c "import pymupdf; print(pymupdf.open('file.pdf').embfile_get('stem.md').decode())"
```

## Validated working (do not deviate)

- Detection: `any(t.get("type") == 0 for t in page.get_texttrace())` — render mode 0 = visible, 3 = invisible (OCR layer). No thresholds, no fallbacks.
- Native DPI for OCR: `largest_image_width_px / page.rect.width` (1:1, no resampling).
- Native → `to_markdown(use_ocr=False)` — layout engine yields clean tables; core `find_tables` garbles borderless tables.
- Scanned → `get_pixmap(matrix=Matrix(scale, scale), colorspace=csRGB)` + pytesseract default segmentation.
- Attach: `embfile_add` then set `/Subtype` via `xref_set_key` on the new EmbeddedFile stream (the xref range added by `embfile_add`). `embfile_upd` is buggy — use del+add.
- Save: `incremental=True, encryption=PDF_ENCRYPT_KEEP` (in-place; default `encryption=1` errors with "changing encryption").
- Fail fast: `assert` on missing scan image / missing EmbeddedFile stream.

## Validated NOT working (do not repeat)

- tesseract CLI directly on `pdfimages` extracts — JPEG artifacts produce garbage.
- `--psm 6` — worse than default auto segmentation.
- pdfplumber on pure scans — mangled output.
- `embfile_upd` with bytes — crashes (`m_internal` AttributeError).
- Full save to the opened path without `incremental=True` — raises "save to original must be incremental".
- Heuristic detection (image-coverage ratio / text-length threshold) — the invoice's invisible Canon OCR layer defeats it; use render-mode instead.
