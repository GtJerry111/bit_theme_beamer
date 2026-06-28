# BIT English Clean Demo Design

## Goal

Revise `main-en.tex` into a short, publishable English demo for BIT Beamer Theme. The English sample should be clean, international-facing, and easy to scan. It should follow the structure and demonstration rhythm of the upstream SCU English demo, while presenting BIT branding, BIT resources, and BIT-facing project information.

The English sample is not a full translation of `main.tex`. The Chinese sample remains the fuller manual-style document; the English sample is a compact smoke-test and feature showcase.

## Scope

In scope:

- Keep `main-en.tex` short and close to the upstream SCU `main-en.tex` flow.
- Preserve the core demo pages: cover, outline, info, theorem blocks, starred blocks, source code blocks, highlighted lines, escape-inline examples, overlay and label examples, source code from file, acknowledgement, and closing thanks.
- Restore any SCU English demo behavior that was accidentally dropped during BIT conversion, especially source-code highlighting options such as `highlightlines`.
- Replace SCU-facing text, links, colors, commands, institutions, and visible identifiers with BIT equivalents.
- Keep the source-lineage acknowledgement that BIT Beamer Theme is derived from SCU Beamer Theme and intentionally keeps `SCU-Version` attribution.
- Align option comments in `main-en.tex` with the current BIT theme behavior where they are plainly outdated.

Out of scope:

- Translating every page from `main.tex`.
- Adding the long Chinese-style teaching sections for font size, color commands, figure pedagogy, long equations, full bibliography walkthroughs, or appendices.
- Redesigning the theme layout, title page, footer, background watermark, or color system.
- Changing SCU upstream files.

## Page Structure

The target `main-en.tex` structure should be:

1. Cover
2. Outline
3. Info
4. Math Blocks
5. Starred Blocks
6. Source Code Block
7. Starred Source Code Block
8. Highlight Line
9. LaTeX Comment / Escapeinline
10. Overlay & Label
11. Source Code From File
12. Acknowledgement
13. Thanks

The exact output page count may differ from SCU because overlays and BIT theme internals can produce different frame counts. Page count parity with SCU is not a requirement.

## Theme Options

The preferred English demo options are:

- `ColorDisplay=BITB`, matching the SCU English demo's use of the secondary blue-style variant.
- `LanguageMode=en`.
- `Background=BIT-Lite`, keeping the English demo visually light.
- Source-code highlighting should follow the SCU English demo where feasible.

If `CodeTheme=minted` works in this repository's normal `latexmk main-en.tex` workflow, use `CodeTheme=minted` and `MintedStyle=dracula` to match SCU's English demo behavior. If it requires unavailable shell-escape behavior or otherwise makes the standard build unreliable, keep `CodeTheme=listing` and make the demo text and comments honest about listing-based highlighting.

## Content Rules

- Use concise, neutral English.
- Avoid Chinese tutorial voice in the English sample.
- Avoid stale SCU user-facing identity except in the intentional lineage acknowledgement.
- Use BIT commands and colors: `\mailbit`, `bitb`, `bitc`, `bitcode`, `bittheorem`, and related BIT-prefixed environments.
- Keep labels unique in `main-en.tex`; avoid accidental duplicate labels inherited from SCU.
- Keep the sample institution generic but BIT-facing: Beijing Institute of Technology and a plausible school or department name.

## Acceptance Criteria

- `main-en.tex` compiles with `latexmk main-en.tex`.
- `scripts/verify-bit-theme.sh` still passes.
- The rendered English PDF title and author metadata are BIT-facing.
- The English sample does not contain stale SCU project identity, Sichuan University institution text, SCU repository links, or `mailscu` / `scucode` / `scutheorem` commands outside intentional source-lineage acknowledgement text.
- The Highlight Line and Overlay & Label frames actually demonstrate their advertised behavior, either through minted `highlightlines` or an honest listing-compatible alternative.
- Existing generated PDF changes from unrelated compile runs are not staged with the design or implementation unless explicitly requested.

## Implementation Boundaries

The implementation should primarily edit `main-en.tex`. Small comment-only fixes in adjacent files are acceptable if they directly correct misleading English-demo guidance, but theme behavior changes are not part of this design.

Any broader issue found during implementation, such as theme-level minted incompatibility or background rendering differences, should be reported separately instead of expanding this scope silently.
