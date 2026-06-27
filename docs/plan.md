# BIT-Beamer-Theme Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 将 SCU Beamer Theme 改造为北京理工大学（BIT）Beamer Theme，保留原 Beamer 主题 5 层架构，全套替换为 BIT 视觉识别系统。

**Architecture:** 保持 Beamer 主题标准分层结构（主/颜色/字体/内部/外部 5 个 `.sty` 文件），通过文件重命名（`scu`→`bit`）、颜色值替换、图片资源替换实现视觉迁移。编译体系（latexmk + XeLaTeX）不变。

**Tech Stack:** LaTeX Beamer, XeLaTeX, latexmk, TikZ, PGF

---

## 前提条件

素材已就位（用户已放入 `resources/`）：
- `resources/BITlogo+name.pdf` — 校徽+校名 ✓
- `resources/BITname.pdf` — 校名单体 ✓
- `resources/BITbuilding.pdf` — 校园建筑（PDF 格式，非 PNG）✓
- `resources/background.png` — 正文背景 ✓
- `resources/backgroundofsubsectiontocpage.png` — 子节目录页背景 ✓
- `resources/backgroundoftitlepage(Empty).png` — 空白封面背景 ✓

跳过（用户未制作，不影响编译）：
- `resources/backgroundoftitlepage.png` — 默认封面背景 → 跳过
- `resources/backgroundoftitlepage(Light).png` — 浅色封面背景 → 跳过

## 文件变更总览

| 文件 | 操作 | 职责 |
|------|------|------|
| `beamerthemescu.sty` → `beamerthemebit.sty` | 重命名+修改 | 主入口：选项声明、子主题加载、通用命令/环境 |
| `beamercolorthemescu.sty` → `beamercolorthemebit.sty` | 重命名+修改 | 颜色主题：BIT 5 色体系定义 |
| `beamerfontthemescu.sty` → `beamerfontthemebit.sty` | 重命名 | 字体主题：仅文件名和包名变更 |
| `beamerinnerthemescu.sty` → `beamerinnerthemebit.sty` | 重命名+修改 | 内部主题：颜色引用名、背景图引用更新 |
| `beamerouterthemescu.sty` → `beamerouterthemebit.sty` | 重命名+修改 | 外部主题：颜色引用名、Logo 引用更新 |
| `main.tex` | 修改 | 调整封面信息、演示内容、颜色名引用 |
| `main-en.tex` | 修改 | 同步英文版 |
| `README.md` | 修改 | 替换为 BIT 说明 |
| `CLAUDE.md` | 修改 | 更新项目名为 BIT |
| `resources/` | 已替换 | 用户已完成替换 |

---

### Task 1: 新建 BIT 颜色主题文件 `beamercolorthemebit.sty`

**Files:**
- Create: `beamercolorthemebit.sty`（基于 `beamercolorthemescu.sty` 修改）
- Remove: `beamercolorthemescu.sty`

- [ ] **Step 1: 从 SCU 原文件复制并重命名**

```bash
cd /Users/jerry/Projects/bit_beamer_theme
cp beamercolorthemescu.sty beamercolorthemebit.sty
```

- [ ] **Step 2: 替换包声明和注释**

将文件头部 `\ProvidesPackage{beamercolorthemescu}` 替换为 `\ProvidesPackage{beamercolorthemebit}`，所有 "SCU Beamer Theme" → "BIT Beamer Theme"、"四川大学" → "北京理工大学"。

- [ ] **Step 3: 替换颜色定义体系**

将原 5 色 CMYK 定义替换为 BIT 配色（基于校徽 `logo_01.svg` 提取）：

具体替换对应关系：

| 原 SCU 颜色名 | 新 BIT 颜色名 | 原色值 (CMYK) | 新色值 (CMYK) |
|---|---|---|---|
| `scured` | `bita` | `0.12,0.92,0.95,0.20` | `0.00,0.53,0.76,0.44` |
| `scugrey` | `bite` | `0.47,0.37,0.37,0.00` | 保留原灰色值 |
| `scublue` | `bitb` | `1.00,0.60,0.00,0.15` | `0.98,0.00,0.48,0.59` |
| `scugreen` | `bitc` | `1.00,0.00,0.90,0.15` | `1.00,0.00,0.56,0.40` |
| `scuyellow` | `bitd` | `0.00,0.25,1.00,0.00` | `0.00,0.20,0.32,0.14` |

每色派生出 10 级淡色变体（`bita10` ~ `bita90`，同理 bitb/bitc/bitd/bite）。

- [ ] **Step 4: 更新选项宏名前缀**

```
\DeclareOptionBeamer{ColorDisplay}{\def\beamer@scu@ColorDisplay{#1}}
→ \DeclareOptionBeamer{ColorDisplay}{\def\beamer@bit@ColorDisplay{#1}}
```

- [ ] **Step 5: 删除原文件**

```bash
rm beamercolorthemescu.sty
```

---

### Task 2: 全局文本级替换（scu → bit）— 4 个 sty 文件

**Files:**
- Create: `beamerthemebit.sty`, `beamerfontthemebit.sty`, `beamerinnerthemebit.sty`, `beamerouterthemebit.sty`
- Remove: `beamerthemescu.sty`, `beamerfontthemescu.sty`, `beamerinnerthemescu.sty`, `beamerouterthemescu.sty`

- [ ] **Step 1: 从 SCU 原文件复制 4 个文件**

```bash
cd /Users/jerry/Projects/bit_beamer_theme
cp beamerthemescu.sty beamerthemebit.sty
cp beamerfontthemescu.sty beamerfontthemebit.sty
cp beamerinnerthemescu.sty beamerinnerthemebit.sty
cp beamerouterthemescu.sty beamerouterthemebit.sty
```

- [ ] **Step 2: 在 4 个文件中执行系统替换**

每个文件执行以下替换模式（可以用 sed 批量处理）：

| 搜索 | 替换 |
|------|------|
| `beamerthemescu` | `beamerthemebit` |
| `beamercolorthemescu` | `beamercolorthemebit` |
| `beamerfontthemescu` | `beamerfontthemebit` |
| `beamerinnerthemescu` | `beamerinnerthemebit` |
| `beamerouterthemescu` | `beamerouterthemebit` |
| `beamer@scu@` | `beamer@bit@` |
| `\scu@` | `\bit@` |
| `SCU Beamer Theme` | `BIT Beamer Theme` |
| `SCU frametitle theme` | `BIT frametitle theme` |
| `SCU title page theme` | `BIT title page theme` |
| `Background=SCU-Full` | `Background=BIT-Full` |
| `Background=SCU-Lite` | `Background=BIT-Lite` |
| `VI=SCU` | `VI=BIT` |
| `SCUlogo+name` | `BITlogo+name` |
| `SCUname` | `BITname` |
| `SCUbuilding` | `BITbuilding` |
| `SCUverify` | 移除引用（BIT 无对应文件） |

- [ ] **Step 3: 处理颜色名替换**

`beamerthemebit.sty` 中的颜色引用：
- `\textcolor{scugreen}{}` → `\textcolor{bitb}{}`
- `\textcolor{scugrey}{}` → `\textcolor{bite}{}`
- `scured` → `bita`
- `scugrey` → `bite`
- `scublue` → `bitb`
- `scugreen` → `bitc`
- `scuyellow` → `bitd`

- [ ] **Step 4: 处理 `BITbuilding.pdf` — 注意文件格式**

原 SCU 引用 `SCUbuilding.png`，用户提供的是 `BITbuilding.pdf`（PDF 格式）。在 `beamerthemebit.sty` 中，LaTeX 的 `\pgfdeclareimage` 和 `\includegraphics` 都能自动处理 PDF，但需要确保文件名无扩展名或写为 `.pdf`：

```
\pgfdeclareimage[width=.35\paperwidth]{landmark}{./resources/BITbuilding.pdf}
```

- [ ] **Step 5: 处理 `SCUverify.png` 的删除**

原模板引用了 `SCUverify.png`（验证图），BIT 没有对应文件。检查该引用在模板中的用途，如果是装饰性元素则直接注释或删除。

- [ ] **Step 6: 删除原 SCU 文件**

```bash
rm beamerthemescu.sty beamerfontthemescu.sty beamercolorthemescu.sty beamerinnerthemescu.sty beamerouterthemescu.sty
```

---

### Task 3: 更新主文档 `main.tex`

**Files:**
- Modify: `main.tex`
- Modify: `main-en.tex`

- [ ] **Step 1: 修改文档类调用**

```
\usetheme[...]{scu}  →  \usetheme[...]{bit}
```

- [ ] **Step 2: 更新背景选项**

```
Background=SCU-Full  →  Background=BIT-Full
```

- [ ] **Step 3: 更新封面信息**

- `\title` 内容改为 BIT 相关的演示标题
- `\institute` 改为北京理工大学
- 更新演示内容中的 SCU 特定文字、URL 引用（GitHub 仓库地址等）

- [ ] **Step 4: 更新颜色名引用**

所有 `\textcolor{scured}{}` → `\textcolor{bita}{}`
所有 `\textcolor{scublue}{}` → `\textcolor{bitb}{}`
以此类推。

- [ ] **Step 5: 更新 README.md 和 CLAUDE.md**

将所有 SCU 相关说明替换为 BIT 版本。

---

### Task 4: 编译验证

**Files:**
- Run: `latexmk main.tex`

- [ ] **Step 1: 首次编译检查错误**

```bash
cd /Users/jerry/Projects/bit_beamer_theme
latexmk main.tex
```

- [ ] **Step 2: 修复编译错误**

如果编译失败，检查：
1. `.sty` 文件中的宏名是否全部正确替换
2. 包名 `\ProvidesPackage` 是否正确
3. 图片路径是否存在（尤其是 `BITbuilding.pdf` 和已删除的 `SCUverify.png`）
4. 颜色名是否已定义

- [ ] **Step 3: 清理并最终编译**

```bash
latexmk -c main.tex
latexmk main.tex
```

- [ ] **Step 4: 提交**

```bash
git add -A
git commit -m "feat: replace SCU theme with BIT theme"
```

---

## 配色方案明细（基于 BIT 校徽 logo_01.svg）

```
主色 bita  —— 红褐色 #904423  CMYK(0,53,76,44)  ← 校徽外圈
辅助色 bitb —— 深绿色 #026937  CMYK(98,0,48,59)  ← 校徽内圈
辅助色 bitc —— 亮绿色 #009944  CMYK(100,0,56,40) ← 校徽叶片
辅助色 bitd —— 金褐色 #DCB095  CMYK(0,20,32,14)  ← 校徽描边
辅助色 bite —— 灰色   保留原值                    ← 中性色
```

每色派生出 10 级淡色变体：`bita10` ~ `bita90`，`bitb10` ~ `bitb90`，以此类推。
