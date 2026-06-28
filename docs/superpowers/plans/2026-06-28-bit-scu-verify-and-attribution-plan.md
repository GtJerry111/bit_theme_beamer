# BIT-SCU Verify and Attribution Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Keep BIT as a derivative of SCU, preserve SCU-Version attribution in README and acknowledgements, and align BIT's verify usage and image logic with the SCU template while allowing small placement adjustments for BIT assets.

**Architecture:** Treat the work as a documentation-and-theme alignment pass, not a visual redesign. `README.md`, `main.tex`, and the acknowledgement section carry the derivative-source statement; `beamerthemebit.sty` and `beamerinnerthemebit.sty` define the actual verify placement and background behavior; `AGENTS.md` and `CLAUDE.md` stay consistent with current option names; the verify script becomes the repeatable guardrail that checks branding and explicit SCU retention rules.

**Tech Stack:** LaTeX Beamer, XeLaTeX, `latexmk`, `rg`, `PIL`/Python for image inspection, shell scripts.

---

### Task 1: Normalize user-facing documentation and source attribution

**Files:**
- Modify: `README.md`
- Modify: `main.tex`
- Modify: `main-en.tex`
- Modify: `docs/CONTRIBUTING.md`
- Modify: `docs/CONTRIBUTING.en.md`
- Modify: `docs/dev/plugins.conf`
- Modify: `docs/install-plugin.sh`
- Modify: `docs/install-plugin.bat`
- Modify: `docs/dev/install-plugin.ps1`
- Modify: `docs/dev/get-manual-tex.sh`
- Modify: `docs/dev/push-manual-tex.sh`

- [ ] **Step 1: Update README source language and keep SCU-Version attribution**

Replace the current SCU-only framing with a BIT-derivative statement that explicitly says the template is based on SCU Beamer Theme, while keeping `SCU-Version` in the README and in the acknowledgements section of the sample document.

- [ ] **Step 2: Update the sample document acknowledgements**

Keep the BIT-facing title/content, but add an acknowledgements paragraph or appendix note that mentions the inherited `SCU-Version` source lineage without making SCU the user-facing project identity.

- [ ] **Step 3: Remove stale SCU branding from plugin and install docs**

Rewrite plugin/doc comments and repository references so they describe BIT or generic “this theme” behavior, while preserving any legitimate upstream-source references only where they matter for lineage.

- [ ] **Step 4: Verify the wording changes**

Run:
```bash
rg -n "SCU Beamer Theme|SCU-Version|SCU_Beamer|SCU-Beamer|四川大学|Sichuan" README.md main.tex main-en.tex docs/CONTRIBUTING.md docs/CONTRIBUTING.en.md docs/dev/plugins.conf docs/install-plugin.sh docs/install-plugin.bat docs/dev/install-plugin.ps1 docs/dev/get-manual-tex.sh docs/dev/push-manual-tex.sh
```
Expected: only the intentional SCU-Version/source-lineage mentions remain, and they appear in README and the acknowledgements text only.

### Task 2: Align verify handling with the SCU placement logic

**Files:**
- Modify: `beamerthemebit.sty`
- Modify: `beamerinnerthemebit.sty`
- Modify: `README.md`
- Modify: `AGENTS.md`
- Modify: `CLAUDE.md`

- [ ] **Step 1: Declare BIT verify as a cover-page asset**

Make `BITverify.png` available in the theme in the same spirit as SCU's `verify` image, but only wire it into the title-page path. Do not use it in subsection TOC backgrounds or footer decorations.

- [ ] **Step 2: Keep background logic parallel to SCU**

Retain the SCU-style separation between cover background and subsection TOC background. Allow BIT asset-size differences to drive small position tweaks, but keep the same roles: cover visual, subsection TOC background, and body watermark behavior.

- [ ] **Step 3: Update the public option docs**

Document that BIT verify is cover-page only, and that the rest of the image logic follows the SCU template structure with BIT assets.

- [ ] **Step 4: Verify the new image usage boundaries**

Run:
```bash
rg -n "BITverify|verify|bgofsubsectoc|bgoftitle|backgroundofsubsectiontocpage" beamerthemebit.sty beamerinnerthemebit.sty README.md AGENTS.md CLAUDE.md
```
Expected: verify is only declared for cover-page use; subsection TOC background logic remains separate; docs match the implementation.

### Task 3: Refresh the repository guidance and local verification script

**Files:**
- Modify: `AGENTS.md`
- Modify: `CLAUDE.md`
- Modify: `scripts/verify-bit-theme.sh`

- [ ] **Step 1: Fix outdated option names in AGENTS.md**

Replace the old SCU-era option text with the current BIT option names and defaults already used by the theme code.

- [ ] **Step 2: Expand the verification script**

Keep the script focused on user-visible guarantees: no stale SCU branding outside the approved source-attribution locations, verify only on the cover page, and no outdated option names in top-level guidance.

- [ ] **Step 3: Run the script and inspect failures or pass**

Run:
```bash
scripts/verify-bit-theme.sh
```
Expected: the script passes once the docs and theme wiring are aligned.

### Task 4: Compile and inspect the outputs

**Files:**
- Modify: generated build artifacts only

- [ ] **Step 1: Compile the Chinese sample**

Run:
```bash
latexmk main.tex
```
Expected: XeLaTeX build succeeds and the PDF reflects the BIT cover, BIT branding, and the approved source attribution.

- [ ] **Step 2: Compile the English sample**

Run:
```bash
latexmk main-en.tex
```
Expected: English sample still builds cleanly after the documentation and theme updates.

- [ ] **Step 3: Scan final outputs for stray SCU user-facing text**

Run:
```bash
rg -n "四川大学|Sichuan|SCU|scu.edu.cn|SCU_Beamer|SCU-Beamer" main.tex main-en.tex README.md AGENTS.md CLAUDE.md docs/CONTRIBUTING.md docs/CONTRIBUTING.en.md
```
Expected: only the intended derivative-source mentions remain.

- [ ] **Step 4: Review the rendered PDF pages**

Open the cover page and one subsection TOC page from the generated PDFs and confirm the verify appears only where intended, with small BIT-specific placement adjustments if the asset proportions require it.
