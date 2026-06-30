# Paper2Beamer 集成到 BIT Beamer Skill 实施计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 把 `paper2beamer` 的论文转 Slides 能力以轻度合并的方式接入 `beamer-bit` skill，通过 BIT ISA manifest + 更新 SKILL.md/docs 实现。

**Architecture:** 轻度合并：`beamer-bit` skill 的 `skill` 分支新增 `isa/BIT.yaml`（BIT 主题的 paper2beamer ISA manifest）+ `docs/paper-conversion.md`（BIT 专属转换指南），并更新 `docs/workflow.md` 和 `SKILL.md` 的模块表。`paper2beamer` skill 本身不改动。

**Tech Stack:** Claude Code Skill（SKILL.md + Markdown docs）、paper2beamer ISA YAML、YAML Schema 验证（Python jsonschema）

---

## 前置知识

### 当前仓库结构（`skill` 分支）
```
skill/
├── SKILL.md              # 技能定义，含 8 个模块的表格
├── README.md             # 项目说明
└── docs/
    ├── config-detail.md
    ├── config-overview.md
    ├── customization.md
    ├── mwe.md
    ├── templates.md
    ├── troubleshooting.md
    ├── typography.md
    └── workflow.md       # 已有 4 个 Task，本次加 Task 5
```

### paper2beamer ISA manifest 结构（参考 Simple.yaml）
- `meta`：主题名、sty 文件、engine、aspectratio
- `provides`：标准扩展列表（Base、Zsem、SpecialFrames、Theorems、Columns 等）
- `options`：`\usetheme[...]` 选项及允许值
- `capacity`：每帧容量（需 probe 测量，初始值标注待校准）
- `custom_instructions`：主题特有命令（schema 中只有 `cmd`/`args`/`optional_args`/`numbered`，不含 `env`）
- `structural_idioms`：可检查的规则
- `prose`：判断性风格指南（自由文本）

### Schema 约束（isa.schema.json）
- `custom_instructions` 仅接受 `instruction` 对象（`cmd` 字段），不接受 `environment` 对象
- BIT 的定理/代码环境作为指令记录（`cmd: bittheorem` 等），详细环境 API 文档写入 `docs/paper-conversion.md` 和 `prose`

---

## 文件职责

| 文件 | 类型 | 职责 |
|------|------|------|
| `isa/BIT.yaml` | 新建 | BIT 主题的 paper2beamer ISA manifest，声明 15 个选项、定理环境、代码环境、容量、风格 |
| `docs/paper-conversion.md` | 新建 | BIT 专属论文转 Slides 指南：环境选择、颜色使用、编译约束 |
| `docs/workflow.md` | 修改 | 加 Task 5「论文转 Slides」，指向 paper-conversion.md |
| `SKILL.md` | 修改 | 模块表加一行；加一段简短的 paper 转换能力描述 |

---

### Task 1: 切换到 skill 分支并确认状态

**Files:**
- None (环境准备)

- [ ] **Step 1: 切换到 skill 分支**

Run:
```bash
git checkout skill
git status
```

Expected: `On branch skill`，`nothing to commit, working tree clean`

- [ ] **Step 2: 确认 skill 分支当前文件**

Run:
```bash
ls -la && ls docs/
```

Expected: 只有 `SKILL.md`、`README.md` 和 `docs/` 下 8 个 markdown 文件，无 `isa/` 目录

---

### Task 2: 创建 isa/BIT.yaml

**Files:**
- Create: `isa/BIT.yaml`

- [ ] **Step 1: 创建 isa/ 目录**

Run:
```bash
mkdir -p isa
```

Expected: 目录创建成功

- [ ] **Step 2: 写入 BIT ISA manifest**

写入 `isa/BIT.yaml`，完整内容如下：

```yaml
meta:
  theme: BIT
  sty: beamerthemebit.sty
  isa_version: 1
  engine: xelatex
  aspectratio: "169"

provides: [Base@1, Zsem@1, SpecialFrames@1, Density@1, OverflowGuard@1, Theorems@1, Columns@1]

# 注意：BIT 主题目前尚未实现 overflowguard 选项。
# 此处声明 OverflowGuard@1 是为了与 paper2beamer 流水线对齐。
# 后续需在 main 分支的 beamerthemebit.sty 中添加 overflowguard 选项支持。

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
  - { name: BIBStyle, values: [numeric-comp], default: numeric-comp }
  - { name: ContentMuticols, values: [true, false], default: true }
  - { name: Background, values: [BIT-Full, BIT-Lite, none, Custom], default: BIT-Full }
  - { name: VI, values: [BIT, Custom], default: BIT }
  - { name: overflowguard, values: [on, off], default: off, required_value: on }

# 待 capacity_probe 校准：首次论文转换后应运行
#   uv run python -m scripts.capacity_probe --theme BIT
# 并更新此处数值。
capacity:
  normal: { bullets_per_frame: 8, figure_plus_bullets: 3, blocks_per_frame: 2 }
  dense:  { bullets_per_frame: 8, figure_plus_bullets: 3, blocks_per_frame: 2 }
  measured_at: { bullet_words: 8 }

custom_instructions:
  # 定理/证明环境（作为指令记录，详细 API 见 docs/paper-conversion.md）
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
  # 代码环境（作为指令记录，详细 API 见 docs/paper-conversion.md）
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
  - bitd（信息黄）：用于条件类 block（BlockConditionC）
  - bite（中性灰）：用于辅助/弱化内容

  ## 定理与证明
  永远使用 BIT 专属环境：bittheorem、bitlemma、bitcorollary、bitproposition、bitdefinition、bitproperty、bitexample、bitremark、bitalgorithm、bitproof、bitaxiom、bitcondition、bitconclusion、bitassumption。永远不要使用 Beamer 的通用 theorem/definition 环境。

  ## 代码高亮
  永远使用 BIT 专属环境：bitcode、bitcode*、bitcodeinput、bitcodeinputnocounter。默认 CodeTheme=listing，不需要 -shell-escape。仅在用户明确要求时才切换为 minted。

  ## 参考文献
  默认使用 BIBMode=biber + BIBStyle=numeric-comp。

  ## 帧密度
  每帧保持一个核心观点。节标题控制在 20 字符以内。每个 block 必须有标题。
```

- [ ] **Step 3: 用 paper2beamer 的 schema 验证 ISA**

Run:
```bash
cd /Users/jerry/Projects/bit_beamer_theme
python3 -c "
import json, yaml, jsonschema
schema = json.load(open('/Users/jerry/.cc-switch/skills/paper2beamer/isa/isa.schema.json'))
isa = yaml.safe_load(open('isa/BIT.yaml'))
jsonschema.validate(isa, schema.get('\$defs', {}).get('theme', {}))
print('✓ isa/BIT.yaml 通过 schema 验证')
"
```

Expected: 打印 `✓ isa/BIT.yaml 通过 schema 验证`，无异常

如果验证失败：根据报错修正 `isa/BIT.yaml` 后重试。常见问题：
- `args` 不是整数 → 改为整数
- `optional_args` 不是整数 → 改为整数
- 缺少必填字段 → 补充

- [ ] **Step 4: 提交 ISA manifest**

Run:
```bash
git add isa/BIT.yaml
git commit -m "feat(isa): add BIT ISA manifest for paper2beamer integration"
```

Expected: 提交成功，commit hash 显示

---

### Task 3: 创建 docs/paper-conversion.md

**Files:**
- Create: `docs/paper-conversion.md`

- [ ] **Step 1: 写入 BIT 专属论文转 Slides 指南**

写入 `docs/paper-conversion.md`，完整内容如下：

```markdown
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

如果用户的工作目录中没有 `isa/BIT.yaml`，需要从 skill 分支拷贝：

```bash
# 从 skill 分支的 isa/BIT.yaml 拷贝到当前工作目录
cp /Users/jerry/Projects/bit_beamer_theme/isa/BIT.yaml ./isa/BIT.yaml
```

或在 skill 分支内直接引用：

```bash
cp isa/BIT.yaml ./isa/BIT.yaml
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
```

- [ ] **Step 2: 提交 paper-conversion.md**

Run:
```bash
git add docs/paper-conversion.md
git commit -m "docs: add BIT-specific paper-to-slides conversion guide"
```

Expected: 提交成功

---

### Task 4: 更新 docs/workflow.md 加入 Task 5

**Files:**
- Modify: `docs/workflow.md`

- [ ] **Step 1: 读取现有 workflow.md 末尾**

Run:
```bash
tail -30 docs/workflow.md
```

Expected: 看到 Task 4 的结尾部分，记下最后几行的内容

- [ ] **Step 2: 在 workflow.md 末尾追加 Task 5**

在文件末尾追加以下内容：

```markdown

---

## 任务 5：论文转 Slides

> 将学术论文 PDF 转换为 BIT Beamer Theme 风格的 slides。
> 配合 paper2beamer skill 使用，BIT ISA manifest 位于 `isa/BIT.yaml`。

### 触发条件

用户要求"论文转 slides"、"paper to slides"、"用 BIT 模板做论文报告"。

### 步骤

1. **确认 paper2beamer skill 已安装**：如未安装，提示用户安装（位于 `/Users/jerry/.cc-switch/skills/paper2beamer/` 或通过 CC Switch 从 GitHub 安装）。

2. **拷贝 BIT ISA 到工作目录**：
   ```bash
   cp isa/BIT.yaml ./isa/BIT.yaml
   ```

3. **按 paper2beamer 的 8 步 pipeline 执行**：
   - Intent → Ingest → Narrative IR → Review gate → Slide IR → Emission → Compile → Repair

4. **在 Slide IR 和 Emission 阶段**，严格遵守 `docs/paper-conversion.md` 中的 BIT 专属规则：
   - 使用 `bittheorem`/`bitlemma` 等 BIT 定理环境
   - 使用 `bitcode`/`bitcode*` 等 BIT 代码环境
   - 使用 `bita`/`bitb` 等语义颜色
   - 编译前添加 `\PassOptionsToPackage{cmyk}{xcolor}`

5. **容量校准**（可选，首次使用时建议运行）：
   ```bash
   uv run python -m scripts.capacity_probe --theme BIT
   ```

### 详细指南

见 `docs/paper-conversion.md`。
```

- [ ] **Step 3: 提交 workflow.md 更新**

Run:
```bash
git add docs/workflow.md
git commit -m "docs(workflow): add Task 5 paper-to-slides with BIT ISA"
```

Expected: 提交成功

---

### Task 5: 更新 SKILL.md

**Files:**
- Modify: `SKILL.md`

- [ ] **Step 1: 读取现有 SKILL.md 的模块表**

Run:
```bash
grep -n '^\|.*\|.*\|' SKILL.md | head -20
```

Expected: 看到 8 行模块表，记下表格位置

- [ ] **Step 2: 在模块表末尾加一行**

在表格最后一行之后追加：

```markdown
| 论文转 Slides | `docs/paper-conversion.md` + paper2beamer skill | 用户要求论文/报告 PDF 转 BIT 风格 slides 时 |
```

- [ ] **Step 3: 在 SKILL.md 的"快速开始"或适当位置加简短说明**

在 SKILL.md 的"快速开始"之后、"全局设置"之前，追加一段：

```markdown
## 论文转 Slides

本 skill 配合 `paper2beamer` skill 提供学术论文 PDF 到 BIT 风格 slides 的转换能力。
BIT ISA manifest 位于 `isa/BIT.yaml`，工作流详见 `docs/paper-conversion.md`。

使用前请确认 `paper2beamer` skill 已安装。
```

- [ ] **Step 4: 提交 SKILL.md 更新**

Run:
```bash
git add SKILL.md
git commit -m "docs(skill): add paper-to-slides module and BIT ISA reference"
```

Expected: 提交成功

---

### Task 6: 最终验证

**Files:**
- None (验证步骤)

- [ ] **Step 1: 确认 skill 分支的 commit 历史**

Run:
```bash
git log --oneline
```

Expected: 看到 4 个新 commit（ISA、paper-conversion、workflow、SKILL.md）

- [ ] **Step 2: 用 paper2beamer schema 再次验证 ISA**

Run:
```bash
python3 -c "
import json, yaml, jsonschema
schema = json.load(open('/Users/jerry/.cc-switch/skills/paper2beamer/isa/isa.schema.json'))
isa = yaml.safe_load(open('isa/BIT.yaml'))
jsonschema.validate(isa, schema.get('\$defs', {}).get('theme', {}))
print('✓ isa/BIT.yaml 通过 schema 验证')
"
```

Expected: `✓ isa/BIT.yaml 通过 schema 验证`

- [ ] **Step 3: 切换到 main 分支确认主题文件完好**

Run:
```bash
git checkout main
ls *.sty main.tex main-en.tex
git status
```

Expected:
- 5 个 `.sty` 文件、`main.tex`、`main-en.tex` 均存在
- `nothing to commit, working tree clean`

- [ ] **Step 4: 切回 skill 分支**

Run:
```bash
git checkout skill
```

Expected: `Switched to branch 'skill'`

- [ ] **Step 5: 列出 skill 分支最终文件树**

Run:
```bash
find . -type f -not -path './.git/*' | sort
```

Expected: 输出包含：
```
./docs/config-detail.md
./docs/config-overview.md
./docs/customization.md
./docs/mwe.md
./docs/paper-conversion.md
./docs/templates.md
./docs/troubleshooting.md
./docs/typography.md
./docs/workflow.md
./isa/BIT.yaml
./README.md
./SKILL.md
```

---

## 后续工作（不在本计划范围内）

以下任务作为后续独立计划：

1. **在 main 分支的 `beamerthemebit.sty` 中实现 `overflowguard` 选项**：使 ISA manifest 中声明的 `OverflowGuard@1` 真正生效。需要修改 `beamerthemebit.sty` 添加 `overflowguard` 选项和对应的 TeX 逻辑。

2. **首次论文转换的 capacity 校准**：用一篇真实论文跑一遍 pipeline，运行 `capacity_probe`，更新 `isa/BIT.yaml` 的 `capacity:` 字段。

3. **配置 GitHub 远程**：将 `main` 和 `skill` 两个分支推送到 GitHub，使 CC Switch 可以安装。
