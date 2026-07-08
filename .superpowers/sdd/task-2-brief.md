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
