# BIT Beamer Consolidation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Fix P0/P1 issues, migrate ISA manifest to main branch, and align skill branch documentation — making the BIT Beamer Theme a coherent, self-consistent project.

**Architecture:** All changes are in `.sty` files (main branch) and documentation files (skill branch). The ISA manifest moves from skill to main branch so code and its capability description share a single version history. Skill branch documentation is updated to reference main-branch ISA and fix all `NomalTextC` → `NormalTextC` renames.

**Tech Stack:** LaTeX (XeLaTeX), Beamer, biblatex-gb7714-2015, fontspec

---

## File Structure

| File | Responsibility | Action |
|------|---------------|--------|
| `beamerthemebit.sty` | Main theme: BIBStyle default, BIBStyle=biber-gb7714 branch | Modify |
| `beamercolorthemebit.sty` | Color theme: `NomalTextC` → `NormalTextC` | Modify |
| `beamerfontthemebit.sty` | Font theme: Mac SmallCaps fix | Modify |
| `main.tex` | Chinese demo: BIBStyle comment update | Modify |
| `isa/BIT.yaml` | ISA manifest (migrated from skill branch) | Create |
| `SKILL.md` (skill branch) | Skill entry: fix NomalTextC, BIBStyle, ISA path | Modify |
| `docs/config-overview.md` (skill branch) | Config reference: fix BIBStyle default | Modify |
| `docs/config-detail.md` (skill branch) | Config detail: fix BIBStyle description | Modify |
| `docs/customization.md` (skill branch) | Customization guide: fix NomalTextC → NormalTextC | Modify |
| `docs/paper-conversion.md` (skill branch) | Paper conversion: fix BIBStyle reference | Modify |
| `docs/workflow.md` (skill branch) | Workflow: fix ISA extraction instructions | Modify |

---

### Task 1: BIBStyle default → biber-gb7714

**Files:**
- Modify: `beamerthemebit.sty` (lines 25, 133-135, 173, 259-263)
- Modify: `main.tex` (line 19, comment)

- [ ] **Step 1: Update BIBStyle option declaration in beamerthemebit.sty**

Change the option header comment (line 25) from:
```
%   BIBStyle = numeric-comp | <custom>
```
to:
```
%   BIBStyle = biber-gb7714 | <custom>
```

Change the KEY comment (lines 133-134) from:
```
% KEY:: BIBStyle [BASED:: BIBMode].
% VALUE:: numeric-comp | <custom>.
```
to:
```
% KEY:: BIBStyle [BASED:: BIBMode].
% VALUE:: biber-gb7714 | <custom>.
```

Change the default value (line 173) from:
```
  \ExecuteOptionsBeamer{BIBStyle=numeric-comp}
```
to:
```
  \ExecuteOptionsBeamer{BIBStyle=biber-gb7714}
```

- [ ] **Step 2: Replace BIBStyle loading logic with biber-gb7714 branch**

Replace lines 259-263 (the BIBMode=biber block) from:
```
\if\EqualOptionsBeamer{BIBMode}{biber}%
  \PassOptionsToPackage{backend=biber}{biblatex}% 后端 biber 引擎.
  \PassOptionsToPackage{style=numeric-comp,sorting=none,url=false,doi=false,isbn=false}{biblatex}%
  \RequirePackage{biblatex}% biblatex: 参考文献.
\fi
```
to:
```
\if\EqualOptionsBeamer{BIBMode}{biber}%
  \PassOptionsToPackage{backend=biber}{biblatex}% 后端 biber 引擎.
  \if\EqualOptionsBeamer{BIBStyle}{biber-gb7714}%
    \PassOptionsToPackage{autolang=hyphen,%
      style=gb7714-2015,%
      gbalign=gb7714-2015,%
      gbstyle=false, url=false, doi=false, isbn=false,%
      sorting=none}{biblatex}%
  \fi
  \RequirePackage{biblatex}% biblatex: 参考文献.
\fi
```

- [ ] **Step 3: Update main.tex BIBStyle comment**

Change line 19 in `main.tex` from:
```
	% BIBStyle=numeric-comp, % numeric-comp ⚙️ → 参考文献样式设置 (设置 BIBMode=none 时无效)
```
to:
```
	% BIBStyle=biber-gb7714, % biber-gb7714 ⚙️ → 参考文献样式设置 (设置 BIBMode=none 时无效)
```

- [ ] **Step 4: Commit main branch BIBStyle changes**

```bash
git add beamerthemebit.sty main.tex
git commit -m "feat: default BIBStyle to biber-gb7714 (GB/T 7714-2015)"
```

---

### Task 2: NomalTextC → NormalTextC full-chain rename

**Files:**
- Modify: `beamercolorthemebit.sty` (lines 137, 148, 161, 179, 203)

- [ ] **Step 1: Rename all 5 occurrences in beamercolorthemebit.sty**

Line 137 (comment table header):
```
% | NomalTextC | AlertedTextC | BackgroundC | BlockExampleC  |
```
→
```
% | NormalTextC | AlertedTextC | BackgroundC | BlockExampleC  |
```

Line 148 (BITA branch):
```
	\colorlet{NomalTextC}         {black}
```
→
```
	\colorlet{NormalTextC}         {black}
```

Line 161 (BITB branch):
```
	\colorlet{NomalTextC}         {black}
```
→
```
	\colorlet{NormalTextC}         {black}
```

Line 179 (Custom branch):
```
	\beamer@bit@colorprovide{NomalTextC}         {black}
```
→
```
	\beamer@bit@colorprovide{NormalTextC}         {black}
```

Line 203 (palette secondary):
```
\setbeamercolor{palette secondary} {fg=NomalTextC}
```
→
```
\setbeamercolor{palette secondary} {fg=NormalTextC}
```

- [ ] **Step 2: Commit color theme rename**

```bash
git add beamercolorthemebit.sty
git commit -m "fix: rename NomalTextC → NormalTextC (typo fix)"
```

---

### Task 3: Mac FontTheme SmallCaps fix

**Files:**
- Modify: `beamerfontthemebit.sty` (lines 87-89)

- [ ] **Step 1: Add SmallCaps features to Helvetica in Mac branch**

Replace lines 87-89 from:
```
\else\if\EqualOptionsBeamer{FontTheme}{Mac}%
  \setsansfont{Helvetica}%                             sans      - Helvetica
  \setmonofont{Menlo}%                                 mono      - Menlo
```
to:
```
\else\if\EqualOptionsBeamer{FontTheme}{Mac}%
  \setsansfont{Helvetica}%                             sans      - Helvetica
    [%
      UprightFeatures = {%
        SmallCapsFont = {TeX Gyre Heros},%             (sc)      - TeX Gyre Heros
        SmallCapsFeatures = {Letters = SmallCaps}%
      },%
      ItalicFeatures = {%
        SmallCapsFont = {TeX Gyre Heros Italic},%      (it-sc)   - TeX Gyre Heros Italic
        SmallCapsFeatures = {Letters = SmallCaps}%
      },%
      BoldFeatures = {%
        SmallCapsFont = {TeX Gyre Heros Bold},%        (bold-sc) - TeX Gyre Heros Bold
        SmallCapsFeatures = {Letters = SmallCaps}%
      },%
      BoldItalicFeatures = {%
        SmallCapsFont = {TeX Gyre Heros Bold Italic},% (bf-itsc) - TeX Gyre Heros Bold Italic
        SmallCapsFeatures = {Letters = SmallCaps}%
      }%
    ]%
  \setmonofont{Menlo}%                                 mono      - Menlo
```

- [ ] **Step 2: Commit font fix**

```bash
git add beamerfontthemebit.sty
git commit -m "fix: add SmallCaps support for Helvetica in Mac FontTheme"
```

---

### Task 4: ISA manifest migration to main branch

**Files:**
- Create: `isa/BIT.yaml`

- [ ] **Step 1: Create isa/ directory and BIT.yaml with corrected content**

```bash
mkdir -p isa
```

Create `isa/BIT.yaml` with the following content (corrected from skill branch version):

```yaml
meta:
  theme: BIT
  sty: beamerthemebit.sty
  isa_version: 2
  engine: xelatex
  aspectratio: "169"

provides: [Base@1, Zsem@1, SpecialFrames@1, Density@1, OverflowGuard@1, Theorems@1, Columns@1]

options:
  - { name: ColorDisplay, values: [BITA, BITB, Custom], default: BITA }
  - { name: BlockDisplay, values: [colorful, followtheme, allgrey], default: colorful }
  - { name: CodeTheme, values: [listing, minted, minted2], default: listing }
  - { name: MintedStyle, values: [lightmode, darkmode], default: lightmode }
  - { name: LanguageMode, values: [cn, en], default: cn }
  - { name: Miniframes, values: [follow, separate, none], default: follow }
  - { name: NavigationTool, values: [1-2-3, 1-2, 1-3, 2-3, 1, 2, 3, none], default: 1-2-3 }
  - { name: LogoWidth, type: dimen, default: 48pt }
  - { name: FontTheme, values: [Auto, Ubuntu, Win, Mac, Fandol, Source-Han, Source-Han(Local), ZhongYi(Local), Custom], default: Auto }
  - { name: MathFont, values: [LM, XITS], default: LM }
  - { name: BIBMode, values: [biber, none], default: biber }
  - { name: BIBStyle, values: [biber-gb7714], default: biber-gb7714 }
  - { name: ContentMuticols, values: [true, false], default: true }
  - { name: Background, values: [BIT-Full, BIT-Lite, none, Custom], default: BIT-Full }
  - { name: VI, values: [BIT, Custom], default: BIT }
  - { name: overflowguard, values: [on, off], default: off }

capacity:
  normal: { bullets_per_frame: 11, figure_plus_bullets: 4, blocks_per_frame: 4 }
  measured_at: { bullet_words: 8 }

custom_instructions:
  # 定理/证明环境
  - { cmd: bittheorem, args: 2, optional_args: 1 }
  - { cmd: bitlemma, args: 2, optional_args: 1 }
  - { cmd: bitcorollary, args: 2, optional_args: 1 }
  - { cmd: bitproposition, args: 2, optional_args: 1 }
  - { cmd: bitdefinition, args: 2, optional_args: 1 }
  - { cmd: bitproperty, args: 2, optional_args: 1 }
  - { cmd: bitexample, args: 2, optional_args: 1 }
  - { cmd: bitremark, args: 2, optional_args: 1 }
  - { cmd: bitalgorithm, args: 2, optional_args: 1 }
  - { cmd: bitproof, args: 2, optional_args: 1 }
  - { cmd: bitaxiom, args: 2, optional_args: 1 }
  - { cmd: bitcondition, args: 2, optional_args: 1 }
  - { cmd: bitconclusion, args: 2, optional_args: 1 }
  - { cmd: bitassumption, args: 2, optional_args: 1 }
  # 代码环境
  - { cmd: bitcode, args: 3, optional_args: 2 }
  - { cmd: "bitcode*", args: 3, optional_args: 2 }
  - { cmd: bitcodeinput, args: 4, optional_args: 2 }
  - { cmd: bitcodeinputnocounter, args: 4, optional_args: 2 }
  # 文档辅助命令
  - { cmd: mailbit, args: 1 }
  - { cmd: cmd, args: 1 }
  - { cmd: env, args: 1 }
  - { cmd: pkg, args: 1 }
  - { cmd: cls, args: 1 }
  - { cmd: marg, args: 1 }
  - { cmd: oarg, args: 1 }
  # 导航命令
  - { cmd: bitgoto, args: 1 }
  - { cmd: bitgoback, args: 1 }

structural_idioms:
  - { rule: deck_requires_short_title, severity: error }
  - { rule: block_requires_title, severity: error }
  - { rule: section_name_max_chars, value: 20, severity: warn }
  - { rule: use_cmyk_xcolor, severity: error }

prose: |
  BIT Beamer Theme 是北京理工大学的专属模板。默认语言为中文（LanguageMode=cn），仅在用户明确要求时才切换为英文（LanguageMode=en）。

  ## 编译约束
  编译前必须在 \documentclass 之前添加：
    \PassOptionsToPackage{cmyk}{xcolor}
  以避免 PDF 色彩偏移。

  ## 语义颜色
  - bita（校徽红褐色）：主强调色，用于关键概念、核心结论
  - bitb（校徽深蓝色）：用于定义类 block（BlockDefinitionC）
  - bitc（校徽叶绿色）：用于引理类 block（BlockLemmaC）
  - bitd（校徽描边金褐色）：用于条件类 block（BlockConditionC）
  - bite（中性灰）：用于辅助/弱化内容

  ## 定理与证明
  永远使用 BIT 专属环境：bittheorem、bitlemma、bitcorollary、bitproposition、bitdefinition、bitproperty、bitexample、bitremark、bitalgorithm、bitproof、bitaxiom、bitcondition、bitconclusion、bitassumption。永远不要使用 Beamer 的通用 theorem/definition 环境。

  ## 代码高亮
  永远使用 BIT 专属环境：bitcode、bitcode*、bitcodeinput、bitcodeinputnocounter。默认 CodeTheme=listing，不需要 -shell-escape。仅在用户明确要求时才切换为 minted。

  ## 参考文献
  默认使用 BIBMode=biber + BIBStyle=biber-gb7714（GB/T 7714-2015 国标）。

  ## 帧密度
  每帧保持一个核心观点。节标题控制在 20 字符以内。每个 block 必须有标题。
```

- [ ] **Step 2: Commit ISA manifest**

```bash
git add isa/BIT.yaml
git commit -m "feat: add ISA manifest (migrated from skill branch, corrected)"
```

---

### Task 5: Skill branch documentation updates

**Files (all on skill branch):**
- Modify: `SKILL.md`
- Modify: `docs/config-overview.md`
- Modify: `docs/config-detail.md`
- Modify: `docs/customization.md`
- Modify: `docs/paper-conversion.md`
- Modify: `docs/workflow.md`
- Delete: `isa/BIT.yaml`

- [ ] **Step 1: Switch to skill branch**

```bash
git checkout skill
```

- [ ] **Step 2: Update SKILL.md**

Change line 97 from:
```
- 配色基色 (CMYK)：`bita`(校徽外圈红褐 0,53,76,44)、`bitb`(校徽内圈深绿 98,0,48,59)、`bitc`(校徽叶片亮绿 100,0,56,40)、`bitd`(信息黄 13,0,83,0)、`bite`(中性灰 47,37,37,0)，每色有 10%-90% 共 9 级色调（如 `bita40`）
```
to:
```
- 配色基色 (CMYK)：`bita`(校徽外圈红褐 0,53,76,44)、`bitb`(校徽内圈深绿 98,0,48,59)、`bitc`(校徽叶片亮绿 100,0,56,40)、`bitd`(校徽描边金褐 0,20,32,14)、`bite`(中性灰 47,37,37,0)，每色有 10%-90% 共 9 级色调（如 `bita40`）
```

Change line 101 from:
```
- 语义颜色 `NomalTextC` 是源码中的拼写（缺少 'r'），Custom 配色时**必须**使用此拼写
```
to:
```
- 语义颜色 `NormalTextC` 用于普通文本色，Custom 配色时必须定义此 token
```

- [ ] **Step 3: Update docs/config-overview.md**

Change line 20 from:
```
| `BIBStyle` | 12 | `numeric-comp` | `numeric-comp` | 参考文献样式（仅 `BIBMode=biber` 时生效） | 微调 |
```
to:
```
| `BIBStyle` | 12 | `biber-gb7714` | `biber-gb7714` | 参考文献样式（仅 `BIBMode=biber` 时生效） | 微调 |
```

- [ ] **Step 4: Update docs/config-detail.md**

Change line 7 from:
```
| 方案 | PrimaryC | IntersperseC | AlertedTextC | AuxiliaryC | NomalTextC | BackgroundC |
```
to:
```
| 方案 | PrimaryC | IntersperseC | AlertedTextC | AuxiliaryC | NormalTextC | BackgroundC |
```

Change lines 91-93 from:
```
| `biber` (默认) | 加载 biblatex + biber，`numeric-comp` 样式，自动读取 `ref.bib` |
| `none` | 不加载参考文献 |

`BIBStyle` 仅 `BIBMode=biber` 时生效，默认 `numeric-comp`。
```
to:
```
| `biber` (默认) | 加载 biblatex + biber，`biber-gb7714` 样式（GB/T 7714-2015），自动读取 `ref.bib` |
| `none` | 不加载参考文献 |

`BIBStyle` 仅 `BIBMode=biber` 时生效，默认 `biber-gb7714`。
```

- [ ] **Step 5: Update docs/customization.md**

Change line 23 from:
```
\definecolor{NomalTextC}{RGB}{34, 34, 34}%
```
to:
```
\definecolor{NormalTextC}{RGB}{34, 34, 34}%
```

Change line 35 from:
```
注意：语义颜色名 `NomalTextC` 是源码中的拼写（缺少 'r'），**必须**使用此拼写。
```
to:
```
注意：语义颜色名 `NormalTextC` 用于普通文本色，**必须**定义此 token。
```

Change line 121 from:
```
\definecolor{NomalTextC}{RGB}{34, 34, 34}%
```
to:
```
\definecolor{NormalTextC}{RGB}{34, 34, 34}%
```

- [ ] **Step 6: Update docs/paper-conversion.md**

Change line 100 from:
```
  默认使用 BIBMode=biber + BIBStyle=numeric-comp。
```
to:
```
  默认使用 BIBMode=biber + BIBStyle=biber-gb7714。
```

- [ ] **Step 7: Update docs/workflow.md**

Replace the ISA extraction section (around lines 23-28) from:
```
2. **拷贝 BIT ISA 到工作目录**：
   ```bash
   cp isa/BIT.yaml ./isa/BIT.yaml
   ```
```
to:
```
2. **确认 BIT ISA 在工作目录中**：
   ISA manifest 位于 main 分支的 `isa/BIT.yaml`。如当前工作目录无此文件，从 main 分支提取：
   ```bash
   git show main:isa/BIT.yaml > isa/BIT.yaml
   ```
```

- [ ] **Step 8: Delete isa/BIT.yaml from skill branch**

```bash
git rm isa/BIT.yaml
```

- [ ] **Step 9: Commit skill branch changes**

```bash
git add -A
git commit -m "docs: align skill docs with main branch (BIBStyle, NormalTextC, ISA path)"
```

- [ ] **Step 10: Switch back to main branch**

```bash
git checkout main
```

---

### Task 6: Compile verification on main branch

**Files:**
- Run only

- [ ] **Step 1: Compile main.tex**

```bash
latexmk main.tex
```

Expected: Exit code 0. No `NomalTextC` undefined control sequence errors.

- [ ] **Step 2: Compile main-en.tex**

```bash
latexmk main-en.tex
```

Expected: Exit code 0.

- [ ] **Step 3: Verify no NomalTextC remains anywhere**

```bash
rg -n "NomalTextC" *.sty main.tex main-en.tex
```

Expected: No matches.

- [ ] **Step 4: Verify BIBStyle default**

```bash
rg -n "BIBStyle" beamerthemebit.sty
```

Expected: Default is `biber-gb7714`, loading logic uses `gb7714-2015` style.

- [ ] **Step 5: Final commit if any cleanup needed**

```bash
git status
```

Expected: Clean working tree.

---

## Execution Order

1. Task 1 (BIBStyle) — independent, no dependencies
2. Task 2 (NormalTextC rename) — independent, no dependencies
3. Task 3 (Mac SmallCaps) — independent, no dependencies
4. Task 4 (ISA manifest) — independent, but should come after Task 1 since ISA references BIBStyle
5. Task 5 (Skill branch docs) — depends on Tasks 1-4 being committed to main
6. Task 6 (Compile verification) — depends on Tasks 1-3

Tasks 1-3 can be done in parallel. Task 4 should follow Task 1. Task 5 must come after 1-4 are committed. Task 6 validates 1-3.
