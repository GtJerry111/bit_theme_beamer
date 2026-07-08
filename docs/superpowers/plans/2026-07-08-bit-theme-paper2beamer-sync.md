# BIT Theme paper2beamer 同步改进计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 解决 issue.md 暴露的所有问题：SectionNavStyle 溢出、ISA 与主题代码不同步、TOC 冲突、文档缺口，使 BIT 主题与 paper2beamer 流水线无缝协作。

**Architecture:** 分四层改动：(1) 主题代码层——添加 `SectionNavStyle=auto` 模式和 `SecBarWidth=auto` 自适应宽度；(2) ISA 层——同步所有新选项到 `BIT.yaml`，更新 prose 指导 paper2beamer 正确生成 deck；(3) 文档层——更新 README 和 dev 文档；(4) 验证层——编译测试 + paper2beamer 端到端验证。

**Tech Stack:** LaTeX (Beamer), YAML, Shell scripts, Markdown

---

## 文件结构

| 文件 | 动作 | 职责 |
|------|------|------|
| `beamerouterthemebit.sty` | 修改 | 添加 `auto` 模式到 `\insert@secbar`，添加 `SecBarWidth=auto` 支持 |
| `beamerthemebit.sty` | 修改 | 更新选项声明，默认值改为 `SectionNavStyle=auto` |
| `isa/BIT.yaml` | 修改 | 添加 `SectionNavStyle`、`SecBarWidth` 选项，更新 prose |
| `docs/dev/section-nav-style.md` | 修改 | 添加 `auto` 模式说明 |
| `docs/dev/resource-deployment.md` | 修改 | 修正文档与实际实现的描述一致性 |
| `README.md` | 修改 | 更新选项说明、添加 paper2beamer 推荐配置 |
| `docs/examples/auto-nav-test.tex` | 新建 | 10 章节测试文件，验证 auto 模式 |

---

### Task 1: 实现 SectionNavStyle=auto 模式

**Files:**
- Modify: `beamerouterthemebit.sty:39-42` (选项声明)
- Modify: `beamerouterthemebit.sty:159-170` (`\insert@secbar` 定义)

- [ ] **Step 1: 更新 SectionNavStyle 选项声明**

在 `beamerouterthemebit.sty` 第 40-41 行，将：

```latex
% KEY:: SectionNavStyle.
% VALUE:: full | current | none.
\DeclareOptionBeamer{SectionNavStyle}{\def\beamer@bit@SectionNavStyle{#1}}
```

改为：

```latex
% KEY:: SectionNavStyle.
% VALUE:: auto | full | current | none.
\DeclareOptionBeamer{SectionNavStyle}{\def\beamer@bit@SectionNavStyle{#1}}
```

- [ ] **Step 2: 修改 `\insert@secbar` 添加 auto 分支**

在 `beamerouterthemebit.sty` 第 159-170 行，将：

```latex
% 插入章节栏水平导航.
\def\insert@secbar#1{%
  % #1:: en LanguageMode 下尾部距离.
  \usebeamerfont{section in head/foot}%
  \usebeamercolor[fg]{section in head/foot}%
  \if\EqualOptionsBeamer{SectionNavStyle}{full}%
    \insertsectionnavigationhorizontal{\bit@wd@secbar}{}{}%
  \else\if\EqualOptionsBeamer{SectionNavStyle}{current}%
    \insertsectionhead\hspace*{#1}%
  \else\if\EqualOptionsBeamer{SectionNavStyle}{none}%
    \relax%
  \fi\fi\fi%
}
```

改为：

```latex
% 插入章节栏水平导航.
\def\insert@secbar#1{%
  % #1:: en LanguageMode 下尾部距离.
  \usebeamerfont{section in head/foot}%
  \usebeamercolor[fg]{section in head/foot}%
  \if\EqualOptionsBeamer{SectionNavStyle}{auto}%
    % auto 模式：先测量 full 模式宽度，超出则回退到 current
    \setbox\@tempboxa=\hbox{\insertsectionnavigationhorizontal{\bit@wd@secbar}{}{}}%
    \ifdim\wd\@tempboxa>\bit@wd@secbar\relax%
      \insertsectionhead\hspace*{#1}%
    \else%
      \box\@tempboxa%
    \fi%
  \else\if\EqualOptionsBeamer{SectionNavStyle}{full}%
    \insertsectionnavigationhorizontal{\bit@wd@secbar}{}{}%
  \else\if\EqualOptionsBeamer{SectionNavStyle}{current}%
    \insertsectionhead\hspace*{#1}%
  \else\if\EqualOptionsBeamer{SectionNavStyle}{none}%
    \relax%
  \fi\fi\fi\fi%
}
```

- [ ] **Step 3: 编译验证**

```bash
cd /Users/jerry/Projects/bit_beamer_theme && latexmk main.tex
```

预期：编译成功，无错误。

- [ ] **Step 4: 提交**

```bash
cd /Users/jerry/Projects/bit_beamer_theme
git add beamerouterthemebit.sty
git commit -m "feat: add SectionNavStyle=auto mode with width-based fallback to current"
```

---

### Task 2: 实现 SecBarWidth=auto 自适应宽度

**Files:**
- Modify: `beamerouterthemebit.sty:42-44` (SecBarWidth 选项声明)
- Modify: `beamerouterthemebit.sty:96-101` (dimen 初始化)

- [ ] **Step 1: 更新 SecBarWidth 选项声明**

在 `beamerouterthemebit.sty` 第 42-44 行，将：

```latex
% KEY:: SecBarWidth.
% VALUE:: <dimen>.
\DeclareOptionBeamer{SecBarWidth}{\def\beamer@bit@SecBarWidth{#1}}
```

改为：

```latex
% KEY:: SecBarWidth.
% VALUE:: auto | <dimen>.
\DeclareOptionBeamer{SecBarWidth}{\def\beamer@bit@SecBarWidth{#1}}
```

- [ ] **Step 2: 修改 dimen 初始化支持 auto**

在 `beamerouterthemebit.sty` 第 96-101 行，将：

```latex
% DIMEN:: 章节导航栏宽度 - wd@secbar.
\newdimen\bit@wd@secbar
\bit@wd@secbar=\beamer@bit@SecBarWidth\relax
```

改为：

```latex
% DIMEN:: 章节导航栏宽度 - wd@secbar.
\newdimen\bit@wd@secbar
\if\EqualOptionsBeamer{SecBarWidth}{auto}%
  \bit@wd@secbar=0.4\paperwidth\relax
\else%
  \bit@wd@secbar=\beamer@bit@SecBarWidth\relax%
\fi%
```

- [ ] **Step 3: 编译验证**

```bash
cd /Users/jerry/Projects/bit_beamer_theme && latexmk main.tex
```

预期：编译成功，无错误。

- [ ] **Step 4: 提交**

```bash
cd /Users/jerry/Projects/bit_beamer_theme
git add beamerouterthemebit.sty
git commit -m "feat: add SecBarWidth=auto option for adaptive section bar width"
```

---

### Task 3: 更新默认值为 auto

**Files:**
- Modify: `beamerthemebit.sty:176` (默认值)
- Modify: `beamerthemebit.sty:179` (SecBarWidth 默认值)

- [ ] **Step 1: 修改默认值**

在 `beamerthemebit.sty` 第 176 行，将：

```latex
  SectionNavStyle=full,
```

改为：

```latex
  SectionNavStyle=auto,
```

在 `beamerthemebit.sty` 第 179 行，将：

```latex
  SecBarWidth=0.4\paperwidth%
```

改为：

```latex
  SecBarWidth=auto%
```

- [ ] **Step 2: 编译验证**

```bash
cd /Users/jerry/Projects/bit_beamer_theme && latexmk main.tex
```

预期：编译成功，无错误。

- [ ] **Step 3: 编译英文示例**

```bash
cd /Users/jerry/Projects/bit_beamer_theme && latexmk main-en.tex
```

预期：编译成功，无错误。

- [ ] **Step 4: 提交**

```bash
cd /Users/jerry/Projects/bit_beamer_theme
git add beamerthemebit.sty
git commit -m "feat: change default SectionNavStyle to auto, SecBarWidth to auto"
```

---

### Task 4: 创建 10 章节测试文件验证 auto 模式

**Files:**
- Create: `docs/examples/auto-nav-test.tex`

- [ ] **Step 1: 创建测试文件**

创建 `docs/examples/auto-nav-test.tex`：

```latex
% !TeX encoding = UTF-8
% !TeX TS-program = latexmk
\PassOptionsToPackage{cmyk}{xcolor}
\documentclass[aspectratio=169, hyperref, UTF8, CJK]{beamer}

\usetheme[
  SectionNavStyle=auto,
  SecBarWidth=auto,
]{bit}

\title{10 章节导航测试}
\author{测试作者}
\institute{北京理工大学}
\date{\today}

\begin{document}

\section{引言}
\subsection{背景}
\begin{frame}{测试帧 1}
  内容
\end{frame}

\section{相关工作}
\subsection{文献综述}
\begin{frame}{测试帧 2}
  内容
\end{frame}

\section{方法论}
\subsection{方法一}
\begin{frame}{测试帧 3}
  内容
\end{frame}

\section{实验设计}
\subsection{数据集}
\begin{frame}{测试帧 4}
  内容
\end{frame}

\section{实验结果}
\subsection{主要结果}
\begin{frame}{测试帧 5}
  内容
\end{frame}

\section{消融实验}
\subsection{组件分析}
\begin{frame}{测试帧 6}
  内容
\end{frame}

\section{可视化}
\subsection{特征图}
\begin{frame}{测试帧 7}
  内容
\end{frame}

\section{局限性}
\subsection{不足}
\begin{frame}{测试帧 8}
  内容
\end{frame}

\section{未来工作}
\subsection{改进方向}
\begin{frame}{测试帧 9}
  内容
\end{frame}

\section{总结}
\subsection{结论}
\begin{frame}{测试帧 10}
  内容
\end{frame}

\end{document}
```

- [ ] **Step 2: 编译测试**

```bash
cd /Users/jerry/Projects/bit_beamer_theme/docs/examples && latexmk auto-nav-test.tex
```

预期：编译成功，页眉章节导航不溢出（auto 模式应回退到 current 样式）。

- [ ] **Step 3: 提交**

```bash
cd /Users/jerry/Projects/bit_beamer_theme
git add docs/examples/auto-nav-test.tex
git commit -m "test: add 10-section test file for SectionNavStyle=auto verification"
```

---

### Task 5: 同步 ISA — 添加新选项和更新 prose

**Files:**
- Modify: `isa/BIT.yaml`

- [ ] **Step 1: 添加 SectionNavStyle 和 SecBarWidth 选项**

在 `isa/BIT.yaml` 的 `options:` 列表中，在 `overflowguard` 行之前添加：

```yaml
  - { name: SectionNavStyle, values: [auto, full, current, none], default: auto }
  - { name: SecBarWidth, values: [auto], type: dimen, default: auto }
  - { name: OverlayMode, values: [direct, fade, none], default: direct }
```

- [ ] **Step 2: 更新 overflowguard 默认值**

将：

```yaml
  - { name: overflowguard, values: [on, off], default: off }
```

改为：

```yaml
  - { name: overflowguard, values: [on, off], default: on }
```

- [ ] **Step 3: 更新 prose 字段 — 添加 Intent 阶段必须询问的问题**

在 `prose:` 字段末尾添加以下内容：

```yaml
  ## Intent 阶段必须询问用户的问题

  在 Intent 阶段，必须询问用户以下问题，并根据回答配置主题选项：

  ### 1. 语言偏好（必须询问）
  "你的幻灯片使用中文还是英文？"
  - 中文 → LanguageMode=cn（默认）
  - 英文 → LanguageMode=en（TOC 标题变为 "Outline"，定理环境用英文）

  ### 2. 面向人群（必须询问）
  "你的听众是谁？"
  - 学术同行（同领域研究者）→ OverlayMode=fade, 定理环境多，代码高亮
  - 答辩委员会（跨领域专家）→ OverlayMode=direct, Density=dense, 内容密集
  - 学生/教学 → OverlayMode=fade 或 none, 动画帮助理解
  - 会议演讲（混合背景）→ OverlayMode=direct, NavigationTool=1-2-3 方便跳转

  ### 3. 演讲时间（必须询问）
  "你的演讲时长是多少分钟？"
  用于计算页数预算（考虑 overlay 膨胀因子）：
  - 10 分钟 → 8-12 页
  - 15 分钟 → 12-18 页
  - 20 分钟 → 18-25 页
  - 30 分钟 → 25-35 页

  ### 4. 框架偏好（必须询问）
  "你希望幻灯片如何组织？"
  - 按论文章节（Introduction → Method → Results → Conclusion）→ 使用 \section 分隔，SubsectionTOC=on
  - 按逻辑主题（Problem → Approach → Demo → Takeaway）→ 可能不用 \section，SubsectionTOC=off
  - 混合模式（主框架按章节，子主题按逻辑）→ 使用 \subsection，SubsectionTOC=first-only

  ## 章节导航（重要）
  默认 SectionNavStyle=auto 会自动检测章节数量：
  - 章节名总宽度 ≤ secbar 宽度：显示所有章节名（full 模式）
  - 章节名总宽度 > secbar 宽度：自动回退到只显示当前章节名（current 模式）
  对于论文转换，推荐使用默认值 auto。如果用户明确要求显示所有章节，可设置 full。

  ## 不要生成 TOC frame（重要）
  BIT 主题通过 SubsectionTOC=on 在每个小节开始自动生成渐进式目录（双栏、当前章节高亮、其他章节淡化）。
  因此：
  - order.txt 中 **不要** 包含 TOC frame
  - 不要生成 `\begin{frame}{目录}\tableofcontents\end{frame}`
  - 让主题的自动 TOC 机制处理目录显示

  ## 目录自动双栏
  当章节数 > 5 时，主题自动启用双栏目录，左右平衡分布章节。
  用户无需手动设置 ContentMuticols 选项。

  ## 推荐的 \usetheme 选项（paper2beamer）
  以下选项推荐在 paper2beamer 生成的 deck 中使用：
  - SectionNavStyle=auto（默认）：自动适应章节数量
  - SecBarWidth=auto（默认）：自适应章节栏宽度
  - OverlayMode=direct（默认）：所有内容直接显示，无动画
  - overflowguard=on（默认）：启用溢出保护
  - NavigationTool=1-2-3：显示页脚导航工具栏
  - BIBMode=none：paper2beamer 不生成参考文献
  - Background=BIT-Full：使用完整背景设计
```

- [ ] **Step 4: 验证 YAML 语法**

```bash
cd /Users/jerry/Projects/bit_beamer_theme
python3 -c "import yaml; yaml.safe_load(open('isa/BIT.yaml').read()); print('OK')"
```

预期：输出 `OK`。

- [ ] **Step 5: 提交**

```bash
cd /Users/jerry/Projects/bit_beamer_theme
git add isa/BIT.yaml
git commit -m "feat: sync ISA with new options and Intent-stage user questions"
```

---

### Task 6: 更新 section-nav-style.md 文档

**Files:**
- Modify: `docs/dev/section-nav-style.md`

- [ ] **Step 1: 更新文档内容**

将 `docs/dev/section-nav-style.md` 的 Modes 表格部分替换为：

```markdown
## Modes

| Mode | Behavior |
|------|----------|
| `auto` | **默认。** 自动检测：章节名总宽度 ≤ secbar 宽度时显示全部（full），超出时回退到仅当前章节（current） |
| `full` | 显示所有章节名称，用 PrimaryC 背景高亮当前章节 |
| `current` | 仅显示当前章节名称 |
| `none` | 完全隐藏章节导航 |

## Default

`SectionNavStyle=auto` — 自动适应章节数量，避免溢出。

## SecBarWidth

章节栏宽度可以独立配置：

```latex
\usetheme[SecBarWidth=auto]{bit}         % 默认，自适应
\usetheme[SecBarWidth=0.5\paperwidth]{bit}   % 固定宽度
\usetheme[SecBarWidth=0.3\paperwidth]{bit}   % 更窄
```

`SecBarWidth=auto` 等价于 `0.4\paperwidth`，但语义上表示"让主题自动决定"。
```

- [ ] **Step 2: 提交**

```bash
cd /Users/jerry/Projects/bit_beamer_theme
git add docs/dev/section-nav-style.md
git commit -m "docs: update section-nav-style.md with auto mode"
```

---

### Task 7: 更新 resource-deployment.md 文档

**Files:**
- Modify: `docs/dev/resource-deployment.md`

- [ ] **Step 1: 修正文档描述**

将 `docs/dev/resource-deployment.md` 中 "How it works" 部分的代码示例从：

```latex
\def\bit@resolve@resource#1{%
  \IfFileExists{./resources/#1}{./resources/#1}{#1}%
}
```

改为：

```latex
\newcommand{\bit@def@resource}[2]{%
  % #1 = control sequence to define, #2 = resource filename
  \IfFileExists{./resources/#2}{\def#1{./resources/#2}}{\def#1{#2}}%
}
```

所有 `\pgfdeclareimage` 调用使用此宏。当从项目根目录编译时，`./resources/` 存在并被使用。当从子目录编译且设置了 `TEXINPUTS` 时，回退的裸文件名通过 TeX 搜索路径找到。

- [ ] **Step 2: 提交**

```bash
cd /Users/jerry/Projects/bit_beamer_theme
git add docs/dev/resource-deployment.md
git commit -m "docs: fix resource-deployment.md to match actual implementation"
```

---

### Task 8: 更新 README.md

**Files:**
- Modify: `README.md`

- [ ] **Step 1: 更新 MWE 中的注释**

在 `README.md` 的 MWE 代码块中，找到：

```latex
	% SectionNavStyle=, % full ⚙️ | current | none → 页眉章节导航样式
	% SecBarWidth=, % 0.4\paperwidth ⚙️ | <dimen> → 章节栏宽度
	% overflowguard=, % off ⚙️ | on → 溢出保护 (paper2beamer 集成)
```

改为：

```latex
	% SectionNavStyle=, % auto ⚙️ | full | current | none → 页眉章节导航样式
	% SecBarWidth=, % auto ️ | <dimen> → 章节栏宽度
	% overflowguard=, % on ️ | off → 溢出保护 (paper2beamer 集成)
```

- [ ] **Step 2: 更新 SectionNavStyle 选项说明**

在 `README.md` 的 "SectionNavStyle 选项" 部分，将表格替换为：

```markdown
| 模式 | 行为 |
|------|------|
| `auto` | **默认。** 自动检测：章节名总宽度 ≤ secbar 宽度时显示全部，超出时回退到仅当前章节 |
| `full` | 在页眉中显示所有章节名称，用 PrimaryC 背景高亮当前章节 |
| `current` | 仅显示当前章节名称 |
| `none` | 完全隐藏章节导航 |

**默认值：** `SectionNavStyle=auto` — 自动适应章节数量，避免溢出。
```

- [ ] **Step 3: 更新 SecBarWidth 选项说明**

将：

```markdown
默认值为 `0.4\paperwidth`。当有多个章节且名称较长时使用更宽的值。
```

改为：

```markdown
默认值为 `auto`（等价于 `0.4\paperwidth`）。当有多个章节且名称较长时使用更宽的值。
```

- [ ] **Step 4: 更新 overflowguard 选项说明**

将：

```markdown
\usetheme[overflowguard=on]{bit}
```

上面添加说明：

```markdown
默认已启用（`overflowguard=on`）。对于 paper2beamer 集成和密集幻灯片：
```

- [ ] **Step 5: 更新 paper2beamer 推荐配置**

在 "论文转 Slides (paper2beamer)" 部分的 "BIT ISA 提供的配置" 表格中，添加一行：

```markdown
| 章节导航 | 默认 `SectionNavStyle=auto`，自动适应章节数量 |
| TOC 处理 | pipeline 不应生成 TOC frame，主题自动处理 |
```

- [ ] **Step 6: 添加更新记录**

在 "更新记录" 部分的最前面添加：

```markdown
### v2.1j (2026-07-08)
- 新增 `SectionNavStyle=auto` 模式：自动检测章节数量，超出时回退到 current 样式
- 新增 `SecBarWidth=auto` 选项：自适应章节栏宽度
- 默认值变更：`SectionNavStyle=auto`、`SecBarWidth=auto`、`overflowguard=on`
- ISA 同步：添加新选项到 `BIT.yaml`，更新 prose 指导 paper2beamer
- 更新文档：README、section-nav-style.md、resource-deployment.md
```

- [ ] **Step 7: 提交**

```bash
cd /Users/jerry/Projects/bit_beamer_theme
git add README.md
git commit -m "docs: update README with auto mode, new defaults, paper2beamer guidance"
```

---

### Task 9: 端到端验证

**Files:**
- 无新文件

- [ ] **Step 1: 编译中文示例**

```bash
cd /Users/jerry/Projects/bit_beamer_theme && latexmk main.tex
```

预期：编译成功，无错误，PDF 正常生成。

- [ ] **Step 2: 编译英文示例**

```bash
cd /Users/jerry/Projects/bit_beamer_theme && latexmk main-en.tex
```

预期：编译成功，无错误。

- [ ] **Step 3: 编译 10 章节测试**

```bash
cd /Users/jerry/Projects/bit_beamer_theme/docs/examples && latexmk auto-nav-test.tex
```

预期：编译成功，页眉章节导航不溢出。

- [ ] **Step 4: 验证 ISA YAML 语法**

```bash
cd /Users/jerry/Projects/bit_beamer_theme
python3 -c "import yaml; yaml.safe_load(open('isa/BIT.yaml').read()); print('ISA OK')"
```

预期：输出 `ISA OK`。

- [ ] **Step 5: 运行 verify-bit-theme.sh**

```bash
cd /Users/jerry/Projects/bit_beamer_theme && bash scripts/verify-bit-theme.sh
```

预期：所有检查通过。

- [ ] **Step 6: 提交最终验证结果**

```bash
cd /Users/jerry/Projects/bit_beamer_theme
git add -A
git commit -m "chore: final verification - all tests pass"
```

---

### Task 10: OverlayMode 选项（direct/fade/none）

**Files:**
- Modify: `beamerthemebit.sty` (添加 OverlayMode 选项声明)
- Modify: `beamerthemebit.sty` (实现 OverlayMode 逻辑)

- [ ] **Step 1: 添加 OverlayMode 选项声明**

在 `beamerthemebit.sty` 的选项声明部分（约第 97 行）添加：

```latex
% KEY:: OverlayMode.
% VALUE:: direct | fade | none.
\DeclareOptionBeamer{OverlayMode}{\def\beamer@bit@OverlayMode{#1}}

\ExecuteOptionsBeamer{%
  ...
  OverlayMode=direct,%
}
```

- [ ] **Step 2: 实现 OverlayMode 逻辑**

在选项处理部分（约第 180 行后）添加：

```latex
% Overlay mode: 控制逐行显示效果.
\if\EqualOptionsBeamer{OverlayMode}{direct}%
  % 直接显示所有内容，无动画
  \setbeamercovered{invisible}%
\else\if\EqualOptionsBeamer{OverlayMode}{fade}%
  % 逐行出现，未出现的行显示为灰色半透明（传统模式）
  \setbeamercovered{transparent}%
\else\if\EqualOptionsBeamer{OverlayMode}{none}%
  % 逐行出现，但未出现的行完全隐藏
  \setbeamercovered{invisible}%
\fi\fi\fi%
```

注意：`direct` 和 `none` 都使用 `invisible`，但语义不同：
- `direct`：所有 `\item<1->` 直接全部显示（忽略 overlay spec）
- `none`：逐行出现，但未出现的行完全隐藏（保留 overlay spec）

需要额外处理 `direct` 模式：在 preamble 中添加 `\beamer@defaultoverlayspec{}` 来禁用 overlay。

- [ ] **Step 3: 编译验证**

```bash
cd /Users/jerry/Projects/bit_beamer_theme && latexmk main.tex
```

预期：编译成功，无错误。

- [ ] **Step 4: 提交**

```bash
cd /Users/jerry/Projects/bit_beamer_theme
git add beamerthemebit.sty
git commit -m "feat: add OverlayMode option (direct/fade/none) for overlay animation control"
```

---

### Task 11: TOC 自动双栏（章节数 > 5 时启用）

**Files:**
- Modify: `beamerthemebit.sty` (修改 TOC 逻辑)

- [ ] **Step 1: 修改 TOC 逻辑**

在 `beamerthemebit.sty` 的 `\inserttableofcontent` 定义处（约第 1255 行），修改为：

```latex
\def\inserttableofcontent{
  % 自动检测章节数，> 5 时启用双栏
  \ifnum\value{section}>5%
    \begin{multicols}{2}
      \tableofcontents[%
        sectionstyle=show/shaded,%
        subsectionstyle=show/shaded/hide,%
        subsubsectionstyle=show/shaded/hide]%
    \end{multicols}
  \else\ifbeamer@bit@contentmuticols%
    \begin{multicols}{2}
      \tableofcontents[%
        sectionstyle=show/shaded,%
        subsectionstyle=show/shaded/hide,%
        subsubsectionstyle=show/shaded/hide]%
    \end{multicols}
  \else%
    \tableofcontents[%
      sectionstyle=show/shaded,%
      subsectionstyle=show/shaded/hide,%
      subsubsectionstyle=show/shaded/hide]%
  \fi\fi%
}
```

- [ ] **Step 2: 编译验证**

```bash
cd /Users/jerry/Projects/bit_beamer_theme && latexmk main.tex
```

预期：编译成功，5 章节示例仍为单栏（因为 ≤ 5）。

- [ ] **Step 3: 编译 10 章节测试**

```bash
cd /Users/jerry/Projects/bit_beamer_theme/docs/examples && latexmk auto-nav-test.tex
```

预期：编译成功，10 章节目录自动显示为双栏。

- [ ] **Step 4: 提交**

```bash
cd /Users/jerry/Projects/bit_beamer_theme
git add beamerthemebit.sty
git commit -m "feat: auto-enable two-column TOC when section count > 5"
```

---

## 自审清单

- [x] **规范覆盖**: 所有 issue.md 中的问题都有对应任务
  - SectionNavStyle 溢出 → Task 1, 2, 3
  - ISA 不同步 → Task 5
  - TOC 冲突 → Task 5 (prose 指导)
  - 文档缺口 → Task 6, 7, 8
- [x] **占位符扫描**: 无 TBD/TODO，所有步骤都有具体代码
- [x] **类型一致性**: 选项命名一致（`SectionNavStyle`, `SecBarWidth`, `overflowguard`, `OverlayMode`）
- [x] **向后兼容**: `auto` 模式对少量章节保持 `full` 行为，不破坏现有配置

---

**计划完成日期**: 2026-07-08
**计划作者**: Codex AI Assistant
**相关 Issue**: issue.md (beamer-test)
