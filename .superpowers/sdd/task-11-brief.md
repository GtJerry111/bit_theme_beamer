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
