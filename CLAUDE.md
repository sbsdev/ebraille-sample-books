# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This project produces eBraille sample books (EPUB-based digital braille publications) by converting DTBook XML source documents using the DAISY Pipeline 2. It is maintained by SBS (Schweizerische Bibliothek für Blinde, Seh- und Lesebehinderte).

Sample books:
- **defaultbook** — artificial sample covering all DTBook XML schema elements
- **kleinere_novellen** — Goethe short stories from Project Gutenberg
- **weltklasse_gotthard** — additional sample; **copyrighted, not committed to git** (built locally for testing only)

## Build Commands

The project uses `just` as the task runner. Run `just help` to list all recipes.

```sh
# Create zip package for a title (required before building)
just zip <title>

# Build single-rendition eBraille (braille only)
just build <title>

# Build multi-rendition eBraille (braille + original text)
just build-multi-rendition <title>

# Filter braille contraction hints from a DTBook XML
# Reads dtbook/<name>/<name>_original.xml, writes dtbook/<name>/<name>_filtered.xml
just filter <xml>
```

Common build targets:
```sh
just build kleinere_novellen
just build defaultbook
```

To read/preview the generated `.epub` or `.ebrl` files:
```sh
/opt/Thorium/thorium --no-sandbox
```

## Architecture

**Input:** DTBook XML files under `dtbook/<title>/` — each title has its own subdirectory with a `<title>.xml` file.

**Processing pipeline:**
1. `just zip <title>` bundles the DTBook XML with `css/sbs.css` into `zip/<title>.zip`
2. `just build <title>` calls `/opt/daisy-pipeline2-cli/dp2 dtbook-to-ebraille` with the zip as data, applying the SBS stylesheet and generating German grade 2 braille via LibLouis (`de-g2.ctb`)

**Output directories:**
- `ebraille/result/` — single-rendition `.epub`/`.ebrl` files
- `ebraille-multi-rendition/result/` — multi-rendition files (braille + original text side by side)

**Stylesheets (`css/`):**
- `sbs.css` — primary SBS braille stylesheet; defines braille cell indentation conventions (cell 1/5/7 for body/h2/h3), blank-line spacing via `margin`, and boxed text with braille separator characters
- `bana.css` — BANA braille stylesheet (reference/alternative)

CSS changes directly affect braille formatting. The stylesheet follows the [eBraille Best Practices](https://daisy.github.io/ebraille/best-practices/styling/index.html). Braille uses `ch` units for cell-width indentation and `rem` for line-height spacing.

## Runtime Dependencies

- **DAISY Pipeline 2 CLI:** `/opt/daisy-pipeline2-cli/dp2`
- **LibLouis** with German grade 2 table `de-g2.ctb`
- **Saxon-HE:** `/usr/share/java/Saxon-HE.jar` (for `filter` recipe)
- **just** task runner
- **Thorium Reader** at `/opt/Thorium/thorium` (for reading output)
