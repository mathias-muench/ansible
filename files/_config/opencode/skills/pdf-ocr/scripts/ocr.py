# /// script
# dependencies = ["pymupdf", "pymupdf4llm", "pytesseract"]
# ///
import sys
from pathlib import Path

import pymupdf
import pymupdf4llm
import pytesseract

pdf_path = Path(sys.argv[1])
lang = sys.argv[2]


def has_visible_text(page):
    return any(t.get("type") == 0 for t in page.get_texttrace())


def native_scale(path):
    doc = pymupdf.open(str(path))
    page = doc[0]
    imgs = page.get_images(full=True)
    assert imgs, "scan has no image on first page"
    best = max(imgs, key=lambda t: t[2] * t[3])
    scale = best[2] / page.rect.width
    doc.close()
    return scale


def attach(doc, name, data, mime):
    if name in doc.embfile_names():
        doc.embfile_del(name)
    before = doc.xref_length()
    doc.embfile_add(name, data, filename=name)
    after = doc.xref_length()
    found = None
    for x in range(before, after):
        t = doc.xref_get_key(x, "Type")
        if t[0] == "name" and "EmbeddedFile" in t[1]:
            found = x
            break
    assert found is not None, "no EmbeddedFile stream after embfile_add"
    doc.xref_set_key(found, "Subtype", "/" + mime.replace("/", "#2F"))


def main():
    doc = pymupdf.open(str(pdf_path))
    native = has_visible_text(doc[0])
    doc.close()

    if native:
        data = pymupdf4llm.to_markdown(str(pdf_path), use_ocr=False).encode("utf-8")
        name = pdf_path.stem + ".md"
        mime = "text/markdown"
    else:
        scale = native_scale(pdf_path)
        doc = pymupdf.open(str(pdf_path))
        text = "\n".join(
            pytesseract.image_to_string(
                page.get_pixmap(matrix=pymupdf.Matrix(scale, scale),
                                colorspace=pymupdf.csRGB, alpha=False).pil_image(),
                lang=lang)
            for page in doc
        )
        doc.close()
        data = text.encode("utf-8")
        name = pdf_path.stem + ".txt"
        mime = "text/plain"

    doc = pymupdf.open(str(pdf_path))
    attach(doc, name, data, mime)
    doc.save(str(pdf_path), incremental=True, encryption=pymupdf.PDF_ENCRYPT_KEEP)
    doc.close()


if __name__ == "__main__":
    main()
