# Release Readiness Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 清理项目中的调试产物、修复过时引用、补全文档，使 BIT Beamer Theme 达到可对外推广的状态。

**Architecture:** 分为三个阶段：(1) 删除无用文件并更新 .gitignore；(2) 修复代码和文档中的过时内容；(3) 补全 README 的编译依赖说明和更新记录。

**Tech Stack:** Git, LaTeX, Markdown

---

## File Structure

| 文件 | 职责 | 操作 |
|------|------|------|
| `tmp/review/` | 开发调试产物 | 删除 |
| `docs/plan.md` | 已完成的迁移计划 | 删除 |
| `docs/superpowers/` | AI 工作流中间文件 | 删除 |
| `.gitignore` | Git 忽略规则 | 添加 `tmp/review/` |
| `main-en.tex` | 英文示例 | 修复 GitHub 链接和"用户手册"引用 |
| `main.tex` | 中文示例 | 修复"用户手册"引用 |
| `beamerouterthemebit.sty` | 外部主题 | 修复过时注释 |
| `docs/dev/plugins.conf` | 插件配置 | 修复 GitHub 链接 |
| `README.md` | 项目说明 | 删除"用户手册"引用，添加编译依赖，补全更新记录 |

---

### Task 1: 删除无用文件

**Files:**
- Delete: `tmp/review/`
- Delete: `docs/plan.md`
- Delete: `docs/superpowers/`

- [ ] **Step 1: 删除 tmp/review/ 目录**

```bash
rm -rf tmp/review/
```

- [ ] **Step 2: 删除 docs/plan.md**

```bash
rm docs/plan.md
```

- [ ] **Step 3: 删除 docs/superpowers/ 目录**

```bash
rm -rf docs/superpowers/
```

- [ ] **Step 4: 提交删除**

```bash
git add -A
git commit -m "chore: remove debug artifacts and completed plans"
```

---

### Task 2: 更新 .gitignore

**Files:**
- Modify: `.gitignore`

- [ ] **Step 1: 在 .gitignore 末尾添加 tmp/review/**

在 `.gitignore` 文件的 `# tmp files:` 部分后添加：

```
# review/debug artifacts
tmp/review/
```

- [ ] **Step 2: 提交 .gitignore 更新**

```bash
git add .gitignore
git commit -m "chore: add tmp/review/ to .gitignore"
```

---

### Task 3: 修复 GitHub 链接

**Files:**
- Modify: `main-en.tex`
- Modify: `docs/dev/plugins.conf`

- [ ] **Step 1: 修复 main-en.tex 中的 GitHub 链接**

将第 85 行：
```tex
\faGithub\enspace{\color{bitb}\url{https://github.com/FvNCCR228/bit_beamer_theme}}
```

改为：
```tex
\faGithub\enspace{\color{bitb}\url{https://github.com/GtJerry111/bit_theme_beamer}}
```

- [ ] **Step 2: 修复 plugins.conf 中的 GitHub 链接**

将第 18 行：
```
repo = FvNCCR228/bit_beamer_theme
```

改为：
```
repo = GtJerry111/bit_theme_beamer
```

- [ ] **Step 3: 提交链接修复**

```bash
git add main-en.tex docs/dev/plugins.conf
git commit -m "fix: update GitHub links to current username"
```

---

### Task 4: 修复过时注释

**Files:**
- Modify: `beamerouterthemebit.sty`

- [ ] **Step 1: 修复第 76 行注释**

将：
```tex
% 于 v2.1c(2026/05/20) 缩减 DIMEN, BOX 等变量名的长度 (由 beamer@bit@xxx 改为 scu@xxx, 更直观); 使用曲线函数重绘原直角梯形图形, 部分采用渐变过渡.
```

改为：
```tex
% 于 v2.1c(2026/05/20) 缩减 DIMEN, BOX 等变量名的长度 (由 beamer@bit@xxx 改为 bit@xxx, 更直观); 使用曲线函数重绘原直角梯形图形, 部分采用渐变过渡.
```

- [ ] **Step 2: 修复第 371 行注释**

将：
```tex
% 于 v2.1c(2026/05/20) 缩减 DIMEN, BOX 等变量名的长度 (由 beamer@bit@xxx 改为 scu@xxx, 更直观).
```

改为：
```tex
% 于 v2.1c(2026/05/20) 缩减 DIMEN, BOX 等变量名的长度 (由 beamer@bit@xxx 改为 bit@xxx, 更直观).
```

- [ ] **Step 3: 修复第 410 行注释**

将：
```tex
% 于 v2.1c(2026/05/20) 缩减 DIMEN, BOX 等变量名的长度 (由 beamer@bit@xxx 改为 scu@xxx, 更直观), Logo 相关长度重新调整, 且支持自定义 Logo 区宽度; 使用曲线函数重绘原直角梯形图形, 部分采用渐变过渡.
```

改为：
```tex
% 于 v2.1c(2026/05/20) 缩减 DIMEN, BOX 等变量名的长度 (由 beamer@bit@xxx 改为 bit@xxx, 更直观), Logo 相关长度重新调整, 且支持自定义 Logo 区宽度; 使用曲线函数重绘原直角梯形图形, 部分采用渐变过渡.
```

- [ ] **Step 4: 提交注释修复**

```bash
git add beamerouterthemebit.sty
git commit -m "fix: correct outdated scu@xxx references in comments"
```

---

### Task 5: 删除"用户手册"引用

**Files:**
- Modify: `main.tex`
- Modify: `main-en.tex`
- Modify: `README.md`

- [ ] **Step 1: 修复 main.tex 第 4 行**

将：
```tex
% !使用前请阅读用户手册. Copyright (C) 2021-2026 by Linrong Wu.
```

改为：
```tex
% Copyright (C) 2021-2026 by Linrong Wu.
```

- [ ] **Step 2: 修复 main-en.tex 第 4 行**

将：
```tex
% !Read the user manual before use. Copyright (C) 2021-2026 by Linrong Wu.
```

改为：
```tex
% Copyright (C) 2021-2026 by Linrong Wu.
```

- [ ] **Step 3: 修复 README.md 第 52 行 MWE 注释**

将：
```latex
% UTF-8 格式 + latexmk 编译, 使用前请阅读用户手册!
```

改为：
```latex
% UTF-8 格式 + latexmk 编译
```

- [ ] **Step 4: 修复 README.md 第 228 行**

将：
```markdown
> - 模板已内置丰富的配置选项, 建议先查阅用户手册 (配置选项见「基础设置」章节, 项目结构见「附录B」); 如确需修改 `.sty` 文件, 请先了解模板结构, 保留备份后参照文件内注释进行实验性修改;
```

改为：
```markdown
> - 模板已内置丰富的配置选项 (配置选项见下方「基础设置」章节); 如确需修改 `.sty` 文件, 请先了解模板结构, 保留备份后参照文件内注释进行实验性修改;
```

- [ ] **Step 5: 提交"用户手册"引用删除**

```bash
git add main.tex main-en.tex README.md
git commit -m "docs: remove references to non-existent user manual"
```

---

### Task 6: 添加编译依赖说明

**Files:**
- Modify: `README.md`

- [ ] **Step 1: 在 README.md 的"快速开始"章节前添加"编译依赖"章节**

在"## 快速开始"之前插入：

```markdown
## 编译依赖

本模板需要以下 LaTeX 宏包（通常已包含在 TeX Live 完整版中）：

- **基础依赖**：`beamer`, `tikz`, `tcolorbox`, `fontspec`, `ctex`
- **参考文献**：`biblatex`, `biber`, `biblatex-gb7714-2015`（GB/T 7714-2015 国标）
- **其他**：`xstring`, `fontawesome5`, `tabularx`

如果使用 TeX Live Basic 或 MiKTeX，可能需要手动安装 `biblatex-gb7714-2015`：

```bash
tlmgr install biblatex-gb7714-2015
```

```

- [ ] **Step 2: 提交编译依赖说明**

```bash
git add README.md
git commit -m "docs: add compilation dependencies section"
```

---

### Task 7: 补全更新记录

**Files:**
- Modify: `README.md`

- [ ] **Step 1: 替换 README.md 的"更新记录"章节**

将：
```markdown
## 更新记录

v1.0a - 初始版本
```

改为：
```markdown
## 更新记录

### v2.1g (2026-06-26)
- 重新设计封面底栏图形与标题布局
- 添加 `overflowguard` 选项用于 paper2beamer 集成
- 修复封面元素间距和视觉对齐

### v2.1e (2026-06-16)
- 修复 draft 模式下文件名下划线导致的编译错误
- 统一选项命名规范

### v2.1c (2026-05-20)
- 字体主题独立为 `beamerfontthemebit.sty`
- 使用曲线函数重绘页眉页脚图形
- 支持自定义 VI（视觉识别系统）
- 添加多种字体方案（Ubuntu/Win/Mac/Fandol/Source-Han）

### v2.1b (2025-10-06)
- 优化页眉页脚间距
- 使用 picture 环境替代 tikz 环境定位

### v1.3e (2024-10-31)
- 迷你帧布局移至外部主题
- 改进 cleveref 中文支持

### v1.3d (2024-05-18)
- 改进 minted 代码高亮支持

### v1.3c (2024-04-16)
- 内部主题独立为 `beamerinnerthemebit.sty`
- 页眉页脚与 TikZ 绘图合并

### v1.0a (2021-12-03)
- 初始版本，基于 SCU Beamer Theme 派生
```

- [ ] **Step 2: 提交更新记录**

```bash
git add README.md
git commit -m "docs: add version history to README"
```

---

### Task 8: 验证与最终提交

**Files:**
- Run only

- [ ] **Step 1: 验证项目结构**

```bash
git status
```

Expected: 工作区干净，所有更改已提交。

- [ ] **Step 2: 验证编译**

```bash
latexmk main.tex
latexmk main-en.tex
```

Expected: 两个文档均编译成功，无错误。

- [ ] **Step 3: 验证无 SCU 残留**

```bash
rg -n "scu@" *.sty
rg -n "FvNCCR228" . --type=tex --type=md
```

Expected: 无输出。

- [ ] **Step 4: 推送到远程仓库**

```bash
git push origin main
```

---

## Execution Order

1. Task 1: 删除无用文件
2. Task 2: 更新 .gitignore
3. Task 3: 修复 GitHub 链接
4. Task 4: 修复过时注释
5. Task 5: 删除"用户手册"引用
6. Task 6: 添加编译依赖说明
7. Task 7: 补全更新记录
8. Task 8: 验证与最终提交

所有任务按顺序执行，每个任务完成后立即提交。
