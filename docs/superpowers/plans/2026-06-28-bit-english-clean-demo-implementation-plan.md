# BIT English Clean Demo Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Turn `main-en.tex` into a short, publishable English clean demo for BIT Beamer Theme that follows the SCU English demo flow while keeping BIT branding and reliable standard builds.

**Architecture:** Treat `main-en.tex` as the primary artifact. Keep the theme code unchanged unless a comment directly misleads English demo users. Use the existing `bitcode`/`bittheorem` APIs and standard `latexmk main-en.tex`; because `minted.sty` is not currently available and `.latexmkrc` does not enable shell escape, keep `CodeTheme=listing` unless a local probe proves minted is usable.

**Tech Stack:** LaTeX Beamer, XeLaTeX, latexmk, listings/tcolorbox, biblatex, ripgrep, Poppler (`pdfinfo`, optionally `pdftotext`).

---

## File Structure

| File | Responsibility |
|---|---|
| `main-en.tex` | English clean demo content, theme options, BIT-facing metadata, source-code demo frames |
| `docs/superpowers/specs/2026-06-28-bit-english-clean-demo-design.md` | Approved design source of truth; do not edit during implementation unless scope changes |
| `scripts/verify-bit-theme.sh` | Existing guardrail for top-level stale branding and verify usage; run but do not expand for this task |
| `main-en.pdf` | Generated output from `latexmk main-en.tex`; update only after the source passes verification |

## Task 1: Establish Build Constraints

**Files:**
- Read: `.latexmkrc`
- Read: `beamerthemebit.sty`
- Modify: none

- [x] **Step 1: Check whether minted is installed**

Run:
```bash
kpsewhich minted.sty
```

Expected for the current environment:
```text
```

Exit code may be `1`, meaning `minted.sty` is unavailable.

- [x] **Step 2: Confirm standard build does not enable shell escape**

Run:
```bash
rg -n "shell-escape|CodeTheme|MintedStyle" .latexmkrc main-en.tex beamerthemebit.sty
```

Expected:
- `.latexmkrc` contains a commented `# '-shell-escape ' .` line, not an active shell-escape flag.
- `beamerthemebit.sty` contains `CodeTheme` branches for `minted`, `minted2`, and `listing`.
- Current `main-en.tex` uses `CodeTheme=listing`.

- [x] **Step 3: Decide the code theme**

Use this rule:
- If Step 1 returns no path, keep `CodeTheme=listing`.
- If Step 1 returns a minted path, run `latexmk main-en.tex` after temporarily switching only a throwaway copy to minted before changing tracked source.
- Do not enable shell escape in `.latexmkrc` for this task.

Expected for the current environment: keep `CodeTheme=listing`.

## Task 2: Rewrite `main-en.tex` as the English Clean Demo

**Files:**
- Modify: `main-en.tex`

- [x] **Step 1: Update theme option comments**

In `main-en.tex`, keep:
```tex
	ColorDisplay=BITB, % BITA ⚙️ | BITB | Custom → theme color display
	CodeTheme=listing, % listing ⚙️ | minted | minted2 → code highlighting engine
	% MintedStyle=dracula, % lightmode ⚙️ | darkmode | ⟨custom⟩ → minted style; active only with CodeTheme=minted or minted2
	LanguageMode=en, % cn ⚙️ | en → language mode
	Miniframes=follow, % follow ⚙️ | separate | none → headline mini-frame behavior
	% NavigationTool=1-2-3, % 1-2-3 ⚙️ | ⟨see manual⟩ | none → footline navigation tools
	% FontTheme=Auto, % Auto ⚙️ | Ubuntu | Win | Mac | Fandol | Source-Han | ... | Custom → font theme
	% MathFont=LM, % LM ⚙️ | XITS | ⟨custom⟩ → math font
	% BIBMode=none, % biber ⚙️ | none → bibliography engine
	% BIBStyle=numeric-comp, % numeric-comp ⚙️ | ⟨custom⟩ → bibliography style; inactive when BIBMode=none
	% ContentMuticols=true, % true ⚙️ | false → two-column table of contents
	Background=BIT-Lite, % BIT-Full ⚙️ | BIT-Lite | Custom | none → background display
```

Do not change `CodeTheme=listing` unless Task 1 proves minted works in the standard build.

- [x] **Step 2: Update title metadata**

Use this BIT-facing metadata:
```tex
\title[A brief English demo for BIT Beamer Theme]{A brief English demo}
\subtitle{BIT Beamer Theme}
\author[BIT Beamer Theme]{BIT Beamer Theme}
\institute{%
	School of Management and Economics\\
	Beijing Institute of Technology\\
	\mailbit{lr.wu.interact@outlook.com}
}
\date{\today}
```

Expected: `pdfinfo main-en.pdf` later reports a BIT-facing title and author.

- [x] **Step 3: Make the Info frame concise**

Replace the body of the `Info.` frame with:
```tex
\begin{frame}{Info.}
	\faShare*\enspace{\color{bitb}lr.wu.interact@outlook.com}
	\faGithub\enspace{\color{bitb}\url{https://github.com/FvNCCR228/bit_beamer_theme}}

	\vspace{2ex}
	\begin{itemize}
		\item A compact English demo for BIT Beamer Theme.
		\item Built with XeLaTeX and the Beamer theme system.
		\item Derived from SCU Beamer Theme with BIT visual identity.
	\end{itemize}
\end{frame}
```

Expected: no SCU repository link or Sichuan institution text.

- [x] **Step 4: Clean English in math blocks**

Within the `Math Blocks` frame:
- Change `A Defintion` to `A Definition`.
- Change `A lemma` to `A Lemma`.
- Replace the Chinese sentence `其中$h$为普朗克常数.` with:
```tex
		where $h$ is Planck's constant.
```

Expected: the frame remains short and English-facing.

- [x] **Step 5: Keep starred blocks unchanged except wording**

In the starred-block frame:
- Keep both `bittheorem` examples and overlays.
- Change the second title from `Another Stared Theorem Block` to `Another Starred Theorem Block`.

Expected: overlay behavior remains inherited from the SCU demo.

- [x] **Step 6: Make code labels unique and clear**

Use these labels:
- C++ overlay example: `[cppcode]`
- Python overlay example: `[pythoncode]`
- Starred C++ block: `[starredcode]`
- Starred Python block: `[starredpythoncode]`
- Highlight C++ block: `[highlightcpp]`
- Highlight Python block: `[highlightpython]`
- Comment C++ block: `[commentcpp]`
- Comment Python block: `[commentpython]`
- Overlay C++ block: `[overlaycpp]`
- Overlay Python block: `[overlaypython]`

Expected: no duplicate `pythoncode` label and references target the new labels.

- [x] **Step 7: Restore honest line-emphasis behavior**

Because the default implementation uses `listings`, do not use SCU's minted-only-looking `highlightlines` unless a compile probe confirms it is accepted. For a reliable listing-based demo, change the Highlight Line frame to emphasize keywords and keep the title honest:
```tex
\begin{frame}[fragile]{Line Emphasis}
	\begin{bitcode}{Emphasized C++ lines.}[highlightcpp]{c}[emph={main,cin},emphstyle=\color{PrimaryC}\bfseries]
		#include <iostream>
		int main()
		{
			std::cout << "Hello World!" << std::endl;
			std::cin.get();
		}
	\end{bitcode}
	\begin{bitcode}{Emphasized Python lines.}[highlightpython]{python}[emph={range,print},emphstyle=\color{PrimaryC}\bfseries]
		for i in range(1,5):
			for j in range(1,5):
				for k in range(1,5):
					if( i != k ) and (i != j) and (j != k):
						print(i,j,k)
	\end{bitcode}
	Reference to~\vref{code:highlightcpp,code:highlightpython}.
\end{frame}
```

Expected: the frame demonstrates a real visual emphasis under `listings`.

- [x] **Step 8: Tighten escape-inline prose**

Replace:
```tex
If you wanna add comments to the back of the line, it is recommended to use the corresponding language comment directly.
```
with:
```tex
Use native language comments for ordinary notes; use escape delimiters only when inline \LaTeX{} is needed.
```

Expected: concise, neutral English.

- [x] **Step 9: Preserve overlay and label demo**

In the `Overlay & Label` frame:
- Keep `\only<1>{Value 1}\only<2>{Value 2}`.
- Keep `@\label{line:qg}@`.
- If using listing-based options, use:
```tex
\begin{bitcode}{Comment}[overlaypython]{python}[emph={if},emphstyle=\color{PrimaryC}\bfseries]'@@'
```

Expected: the frame demonstrates both overlay text and a line label.

- [x] **Step 10: Keep source-code input from file**

Keep:
```tex
\begin{frame}[fragile]{Source Code From File}
	\bitcodeinput{Source Code From File}{c}{A cpp.cpp}
\end{frame}
```

Expected: the external source example remains part of the clean demo.

- [x] **Step 11: Keep acknowledgement but polish wording**

Use:
```tex
\section{Acknowledgement}
\subsection{Acknowledgement}
\begin{frame}{Acknowledgement}
	\begin{center}
		BIT Beamer Theme is derived from SCU Beamer Theme, and this sample keeps \texttt{SCU-Version} as source-lineage attribution.\\[1ex]
		Thanks to the authors and maintainers of Beamer, Tcolorbox, BibLaTeX, FontAwesome, and related packages.\\[1ex]
		Thanks to the community discussions that helped shape the original template behavior.\\[1ex]
	\end{center}
\end{frame}
```

Expected: only intentional SCU lineage text remains.

## Task 3: Compile and Fix Source-Level Issues

**Files:**
- Modify: `main-en.tex`
- Generated: `main-en.pdf`

- [x] **Step 1: Compile the English demo**

Run:
```bash
latexmk main-en.tex
```

Expected:
- Exit code `0`.
- `main-en.pdf` is generated.
- No undefined references in the latexmk summary.

- [x] **Step 2: If the compile fails on listings options**

If the log reports an unknown listings key from `emph` usage, replace only the problematic optional argument with an empty option:
```tex
[]
```
and change the frame title from `Line Emphasis` to:
```tex
\begin{frame}[fragile]{Source Code References}
```

Expected: the demo remains honest and compiles.

- [x] **Step 3: Check for stale SCU commands and links**

Run:
```bash
rg -n "mailscu|scucode|scutheorem|SCU-Beamer|SCU_Beamer|Sichuan|scu.edu.cn|Business School, Sichuan University" main-en.tex
```

Expected: no output, except `SCU Beamer Theme` and `SCU-Version` are allowed only in the acknowledgement sentence. If the command reports only that intentional acknowledgement, no edit is required.

- [x] **Step 4: Check BIT-facing metadata**

Run:
```bash
pdfinfo main-en.pdf | rg "Title|Author|Pages"
```

Expected:
```text
Title:           A brief English demo - BIT Beamer Theme
Author:          BIT Beamer Theme
Pages:           a positive page count
```

Exact page count is not constrained.

- [x] **Step 5: Run project guardrail**

Run:
```bash
scripts/verify-bit-theme.sh
```

Expected:
```text
OK: no obsolete option names in top-level guidance
OK: no stale SCU branding in top-level guidance
OK: verify image is used on the cover page
OK: verify image is not used outside the cover page
```

## Task 4: Review Diff and Commit

**Files:**
- Modify: `main-en.tex`
- Modify: `main-en.pdf` if regenerated by `latexmk main-en.tex`
- Leave unstaged unless explicitly requested: `main.pdf`

- [x] **Step 1: Inspect working tree**

Run:
```bash
git status --short
```

Expected:
- `main-en.tex` modified.
- `main-en.pdf` modified after compile.
- `main.pdf` may still be modified from earlier compile runs; do not stage it for this task.

- [x] **Step 2: Inspect source diff**

Run:
```bash
git diff -- main-en.tex
```

Expected:
- English demo text is concise and BIT-facing.
- No SCU commands remain.
- Code labels are unique.
- `BIBStyle` comment uses `numeric-comp`.

- [x] **Step 3: Prepare task files for staging**

Controller closeout command:
```bash
git add main-en.tex main-en.pdf docs/superpowers/plans/2026-06-28-bit-english-clean-demo-implementation-plan.md
```

Do not stage `main.pdf` unless the user explicitly asks to refresh the Chinese PDF too. The implementation plan file is included as task documentation because this repository already tracks the matching design spec and prior Superpowers plan files.

- [x] **Step 4: Prepare commit**

Controller closeout command:
```bash
git commit -m "docs: refresh English clean demo"
```

Expected: commit succeeds and includes `main-en.tex`, `main-en.pdf`, and this implementation plan; `main.pdf` remains unstaged.
