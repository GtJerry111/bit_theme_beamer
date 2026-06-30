# 论文转 Slides（BIT 专属指南）

> 本指南用于将学术论文 PDF 转换为 BIT Beamer Theme 风格的 slides。
> 配合 paper2beamer skill 的 pipeline 使用，ISA manifest 位于 `isa/BIT.yaml`。

## 触发条件

当用户要求：
- "帮我把这篇论文转成 slides"
- "用 BIT 模板做一份论文报告"
- "论文转 slides"
- "paper to slides"
- "paper to beamer"

## 前置步骤：拷贝 ISA 到工作目录

如果用户的工作目录中没有 `isa/BIT.yaml`，需要从仓库的 skill 分支提取：

```bash
# 从 skill 分支提取 ISA manifest 到当前工作目录
mkdir -p isa
git show skill:isa/BIT.yaml > isa/BIT.yaml
```

或从已克隆的仓库直接拷贝：

```bash
cp <repo>/isa/BIT.yaml ./isa/BIT.yaml
```

## BIT 专属环境选择规则

### 定理/证明环境

| 内容类型 | 使用环境 | 示例 |
|----------|----------|------|
| 定理 | `bittheorem` | `\begin{bittheorem}{定理名}[标签]\end{bittheorem}` |
| 引理 | `bitlemma` | 同上 |
| 推论 | `bitcorollary` | 同上 |
| 命题 | `bitproposition` | 同上 |
| 定义 | `bitdefinition` | 同上 |
| 性质 | `bitproperty` | 同上 |
| 例 | `bitexample` | 同上 |
| 注 | `bitremark` | 同上 |
| 算法 | `bitalgorithm` | 同上 |
| 证明 | `bitproof` | 同上 |
| 公理 | `bitaxiom` | 同上 |
| 条件 | `bitcondition` | 同上 |
| 结论 | `bitconclusion` | 同上 |
| 假设 | `bitassumption` | 同上 |

**禁止使用：** `\begin{theorem}`、`\begin{definition}` 等 Beamer 通用环境。

### 代码环境

| 场景 | 使用环境 |
|------|----------|
| 内联代码块（带计数） | `bitcode` |
| 内联代码块（无计数） | `bitcode*` |
| 从文件加载代码 | `bitcodeinput` |
| 从文件加载（无计数） | `bitcodeinputnocounter` |

**默认：** `CodeTheme=listing`（无需 `-shell-escape`）。
**仅在用户明确要求时** 才使用 `CodeTheme=minted`。

### 颜色使用

```latex
\textcolor{bita}{关键概念}    % 主强调（红褐）
\textcolor{bitb}{定义内容}    % 定义类（深蓝）
\textcolor{bitc}{引理内容}    % 引理类（叶绿）
\textcolor{bitd}{条件内容}    % 条件类（黄）
\textcolor{bite}{辅助内容}    % 弱化（灰）
```

## 编译约束

`main.tex` 必须在 `\documentclass` 之前添加：

```latex
\PassOptionsToPackage{cmyk}{xcolor}
\documentclass[aspectratio=169, hyperref, UTF8, CJK]{beamer}
\usetheme[...]{bit}
```

## 参考文献

默认配置：
```latex
BIBMode=biber
BIBStyle=numeric-comp
```

使用 `\footfullcite{key}` 在帧内引用。

## 封面页格式

```latex
\title[短标题]{完整标题}
\subtitle{副标题}
\author[作者简称]{作者全名\inst{1}}
\institute{
  \inst{1} 北京理工大学
  \vspace*{-6pt} \and
  \inst{1} \mailbit{your.email@bit.edu.cn}
}
\date{\today}
```

## 中英文切换

- **默认：** `LanguageMode=cn`（中文页眉导航）
- **切换为英文：** 仅在用户明确要求时设置 `LanguageMode=en`

## 容量指南（初始值，待 probe 校准）

- 每帧 bullet 数：≤ 8
- 每帧图 + bullet：≤ 3 项
- 每帧 block 数：≤ 2

首次论文转换后应运行：
```bash
uv run python -m scripts.capacity_probe --theme BIT
```
根据输出更新 `isa/BIT.yaml` 的 `capacity:` 字段。

## 工作流集成

本指南配合 `paper2beamer` 的 8 步 pipeline 使用：

1. **Intent** → 询问用户意图（报告长度、重点）
2. **Ingest** → Docling 提取论文内容和图片
3. **Narrative IR** → 写出 narrative.md（独立于主题）
4. **Review gate** → 用户审核 narrative
5. **Slide IR** → 写出 slides.md（BIT ISA-aware）
6. **Emission** → 生成 main.tex（使用 bitcode/bittheorem 等 BIT 环境）
7. **Compile & verify** → latexmk 编译
8. **Repair** → 按层级修复问题（tex < slide < narrative）
