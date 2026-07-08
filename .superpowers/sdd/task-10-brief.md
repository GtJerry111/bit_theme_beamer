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
