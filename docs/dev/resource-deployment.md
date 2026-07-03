# Resource File Deployment

BIT Beamer Theme requires image resources (`resources/` and `image/` directories) to render the cover page, backgrounds, and visual identity elements. This guide explains how to deploy these resources for different use cases.

## Problem

`\pgfdeclareimage` does not respect `\graphicspath`. When compiling from a subdirectory, the hardcoded `./resources/...` paths resolve to the wrong location.

## Solutions

### Strategy 1: Copy resources into project directory (simplest)

Copy the `resources/` and `image/` directories into your project root:

```bash
cp -r /path/to/bit_beamer_theme/resources ./
cp -r /path/to/bit_beamer_theme/image ./
```

This is the simplest approach and works for single-project use.

### Strategy 2: Use TEXINPUTS environment variable

Set `TEXINPUTS` to include the theme's resource directory:

```bash
export TEXINPUTS="/path/to/bit_beamer_theme//:./"
latexmk main.tex
```

The `//` suffix tells TeX to search subdirectories recursively. The theme's `\bit@resolve@resource` macro first checks `./resources/` (local), then falls back to the bare filename, which TeX will find via `TEXINPUTS`.

### Strategy 3: Install into TeX tree (best for repeated use)

Run the provided install script to copy resources into your local TeX tree:

```bash
./scripts/install-resources.sh
sudo mktexlsr  # Update TeX file database
```

This installs resources to `$TEXMF_HOME/tex/latex/bit-beamer-theme/resources/`, making them available to all projects without per-project copies.

## How it works

The theme defines a `\bit@resolve@resource` macro:

```latex
\def\bit@resolve@resource#1{%
  \IfFileExists{./resources/#1}{./resources/#1}{#1}%
}
```

All `\pgfdeclareimage` calls use this macro. When compiling from the project root, `./resources/` exists and is used. When compiling from a subdirectory with `TEXINPUTS` set, the fallback bare filename is found via TeX's search path.

## Troubleshooting

**"I can't find image file" errors:**
- Verify `resources/` and `image/` directories exist in your project root, or
- Set `TEXINPUTS` to include the theme directory, or
- Run `scripts/install-resources.sh` and `mktexlsr`

**Resources work from root but not subdirectories:**
- Use Strategy 2 or 3 above
- Ensure `TEXINPUTS` includes the theme directory with `//` suffix
