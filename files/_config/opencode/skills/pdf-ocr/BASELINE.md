# pdf-ocr baseline

Hard knowledge extracted from session context, so the pymupdf migration can be
evaluated against a reproducible reference and rolled back if it dead-ends.

## Migration outcome (pymupdf adopted)

The migration to `pymupdf` + `pymupdf4llm` + `pytesseract` (dropping `pypdfium2`
+ `pikepdf`) was accepted. Key results:

- Render parity (pymupdf vs pypdfium2, mean abs pixel diff /255): invoice 0.98,
  merkblatt (CMYK) 0.27–0.43, neues 0.76–1.83 — MuPDF CMYK→RGB ≈ PDFium.
- OCR parity (SequenceMatcher): invoice 0.9753 @300, merkblatt 0.9953 @417,
  neues 0.9718 @300 — no quality regression.
- Detection is deterministic via render mode, not heuristics (see below).

## Detection (the key discovery)

The invoice is a **searchable scan**: the Canon scanner (`IJ Scan Utility`,
`Canon SC1011`) wrote an *invisible* OCR text layer (`3 Tr` render mode, garbled
`"SraNi:i*lraber: llr. l\{arkus lihrl"`). This defeated any text-length /
image-coverage heuristic. The deterministic probe is render mode:

- `page.get_texttrace()` → `type == 0` = visible (native), `type == 3` =
  invisible (OCR layer). `any(t.get("type") == 0 ...)` ⇒ native.

## Current skill state (the baseline)

- Committed: `12e9d11` "pdf-ocr: pypdfium2 at native DPI (drop Poppler)".
- Dependencies: `pypdfium2` (render), `pytesseract` (OCR), `pikepdf` (attach +
  native-DPI detect). No native deps except Tesseract (PDFium + qpdf bundled).
- `scripts/ocr.py` flow: detect native scale (pikepdf) → render (pypdfium2) →
  OCR (pytesseract) → attach `<stem>.txt` (pikepdf, in-place via BytesIO).
- Attachment: `<stem>.txt`, MIME `text/plain`. Overwrites same-name attachment
  (pikepdf `Attachments` assignment replaces, no duplicate).

## Corpus (project `AXA/`)

| file | bytes | pages | nature | notes |
|---|---|---|---|---|
| `IMG_20260728_0001-1.pdf` | 637357 | 1 | scanned RGB | 2550×3300 JPEG, native 300 dpi; invisible garbled OCR layer (Canon `3 Tr`, 1789 chars); has embedded golden `IMG_20260728_0001-1.txt` (1809 chars) |
| `merkblatt-vorsorgeuntersuchungen-axa.pdf` | 4359738 | 3 | scanned CMYK | 0 fonts, 385 DeviceCMYK images, bioPDF/AXA producer; no text layer |
| `Neues zu Ihren Leistungsangelegenheiten_20260826_0156.pdf` | 87752 | 4 | native text | text layer: pages 0–2 = 1752/1382/975 chars, page 3 = 0 chars |

## Baseline OCR numbers (pypdfium2 + pytesseract `deu`)

Metric: `difflib.SequenceMatcher.ratio()` vs the native-DPI output (whitespace
normalized). Native scale = `largest_image_width_px / page_width_pt` (fallback
300/72).

### invoice (RGB, native 300 dpi, 1809 chars)
| dpi | chars | sim vs native |
|---|---|---|
| 72 | 1131 | 0.2084 |
| 150 | 1813 | 0.8311 |
| 200 | 1806 | 0.9747 |
| 300 | 1809 | 1.0000 |
| 400 | 1795 | 0.9422 |
| 600 | 1821 | 0.9908 |

### merkblatt (CMYK, native 417 dpi via largest-image, 8373 chars)
| dpi | chars | sim vs native |
|---|---|---|
| 72 | 5987 | 0.1632 |
| 150 | 8224 | 0.6353 |
| 200 | 8377 | 0.9352 |
| 300 | 8369 | 0.9237 |
| 400 | 8334 | 0.9409 |
| 600 | 8448 | 0.9540 |

Note: merkblatt "native 417 dpi" is an artifact of largest-image detection on a
fragmented CMYK doc (fragments ~300 dpi); it is not a meaningful native DPI.

## Golden content (key lines)

- invoice (`IMG_20260728_0001-1.txt`): `6 UROLOGIE`, `Praxisinhaber: Dr. Markus
  Ehrl`, `erlaube ich mir € 286,80 zu berechnen.`, `Ariane Hartmann`,
  `Tel: 08031 32200`, `Rechnung Nr. 75059`, `SWOP/ERSPC`.
- merkblatt body (after decorative-header garbage): `Informationen zum Thema
  Vorsorgeuntersuchungen`, `Als Versicherter der AXA können Sie umfangreiche
  Vorsorge-…`. Header garbage (`in\nN\na\nQS…`) is scale-independent — it is the
  decorative AXA logo rasterized as CMYK, not a detection bug.

## Encoding fact

OCR output is valid UTF-8 (proper `ö`/`ü`/`€`, no U+FFFD). The `�` seen in
console output is PowerShell console display mangling, not file corruption.

## Prior renderer-divergence knowledge (historical, Poppler now uninstalled)

- pypdfium2 (PDFium) vs pdf2image (Poppler): CMYK parity 0.9853 @300 vs 0.9036
  @200 — native DPI minimizes renderer divergence.
- Stability (vs @600): merkblatt 0.9001@200, 0.9263@300, 0.9056@400.
- These are not reproducible (Poppler removed); recorded for context only.
