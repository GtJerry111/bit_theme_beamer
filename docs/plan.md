# BIT Beamer Visual Refinement Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 把当前 `main.pdf` 从“SCU 模板换皮半成品”推进到可发布的 BIT Beamer 模板示例，保留 SCU 原版成熟版式，但替换为北京理工大学视觉识别、内容语境、徽标和字体策略。

**Architecture:** 不做机械全文搜索替换；按 Beamer 主题职责拆分处理：`beamerinnerthemebit.sty` 负责首页，`beamerouterthemebit.sty` 负责页眉/页脚/右下角视觉锚点，`beamercolorthemebit.sty` 负责 BIT 标准色和派生色阶，`beamerfontthemebit.sty` 负责字体映射，`main.tex`/`main-en.tex` 负责示例内容 BIT 化。每轮改动后编译 `main.tex`，用渲染图与 `/Users/jerry/Projects/SCU-Beamer-Theme-main/main.pdf` 对照。

**Tech Stack:** LaTeX Beamer, XeLaTeX, latexmk, TikZ/PGF, xcolor CMYK, Poppler (`pdftoppm`, `pdftotext`, `pdfinfo`)

---

## 审阅结论

### 当前 `main.pdf` 的主要不足

- 首页问题最大：第一页左上角出现调试/选项串 `1-2-3-, [] ,[] ... mapping=tex-text`，这是必须优先修的硬错误。
- 首页仍沿用 SCU 内容：标题是“四川大学虚拟偶像研究”，作者/学院/email/日期也未改成 BIT 语境。
- 首页视觉不是“SCU 原版基础上的 BIT 模板”：当前使用了 BIT logo，但背景主体变成绿色塔/鸽子图形，缺少 SCU 原版首页的红色底部曲线、右侧建筑线稿、右上校训/书法水印一类成熟层次。
- 正文页总体结构接近原版，但页脚左侧仍只是 BIT 校名字样，右下角背景水印不符合你的要求；原版正文右下角有淡校徽水印，当前应该改为 `resources/BITemblem.png`。
- `main.tex` 仍有大量 SCU 文案：项目地址、联系方式、颜色说明、机构说明、图片页文字、校训页等都还在四川大学语境。
- 颜色页当前写“依据四川大学 VIS 手册”，但色阶已变成 BIT 风格；这页应改成“依据 BIT VI / 标准色规范”，并参考 `/Users/jerry/Projects/素材/ai/COLOR_USAGE/例.ai` 的三组色阶：亮绿、棕金、深绿。
- 字体策略需要明确：`/Users/jerry/Projects/素材/ai/LOGOTYPE_USAGE/9.ai` 给出英文专用字体 Helvetica / Times Roman / Arial；本机已存在 Helvetica、Arial、Times New Roman、PingFang SC、Songti SC、Heiti SC，因此 `FontTheme=Mac` 基本符合，但需要把 BIT 推荐写进文档并检查中文标题粗细。
- PDF 页数当前 44 页，原版 45 页；抽取文本显示当前目录页总页码为 `31`，原版为 `32`，说明 overlay/备份页或正文结构与原版不同，需要确认是有意删减还是误删。
- 当前 PDF metadata 仍是“四川大学虚拟偶像研究 - Beamer模板使用答辩”，需要随着 `main.tex` 信息更新。

### 设计方向

推荐采用“结构保留 + 视觉素材替换 + 内容重写”的路径，而不是继续全局 `scu -> bit` 替换。SCU 原版成熟之处是首页/页眉/页脚的构图和节奏；BIT 版应继承构图比例、留白、导航密度和曲线语言，但替换为 BIT 标准色、BIT emblem、BIT 校名/校徽组合和 BIT 示例内容。

---

## 文件职责

| 文件 | 职责 | 本轮重点 |
|---|---|---|
| `beamerinnerthemebit.sty` | 首页、目录、block 内部样式 | 修首页调试串、重建首页背景/校名/日期/建筑/曲线层 |
| `beamerouterthemebit.sty` | 页眉、页脚、导航、页码、logo 区 | 将正文右下角视觉锚点改为 `resources/BITemblem.png`，校准页脚 |
| `beamercolorthemebit.sty` | 颜色定义和 Beamer 颜色绑定 | 按 `COLOR_USAGE/例.ai` 建立 BIT 标准色与色阶命名 |
| `beamerfontthemebit.sty` | 英文/CJK/mono/math 字体策略 | 明确 Mac 下 Helvetica + PingFang SC，增加可选 Arial/Times 策略 |
| `main.tex` | 中文示例文档 | 将示例内容从 SCU 基础上改写成 BIT 模板说明 |
| `main-en.tex` | 英文示例文档 | 同步英文 BIT 示例，不保留 SCU 链接和机构 |
| `README.md` / `CLAUDE.md` / `AGENTS.md` | 项目说明 | 同步选项名、资源名、构建说明和 BIT 视觉说明 |
| `resources/BITemblem.png` | 正文右下角淡徽标 | 用作正文水印/右下角背景锚点，不压正文文字 |

---

### Task 1: 修复首页硬错误和封面信息

**Files:**
- Modify: `beamerinnerthemebit.sty`
- Modify: `beamerthemebit.sty`
- Modify: `main.tex`

- [ ] **Step 1: 定位调试串来源**

Run:
```bash
rg -n "mapping=tex-text|1-2-3|NavigationTool|fontspec|setkeys|FamilyOptions" beamerthemebit.sty beamerinnerthemebit.sty beamerouterthemebit.sty beamerfontthemebit.sty main.tex
```

Expected: 找到首页输出 `1-2-3-, [] ,[]` 或 fontspec 选项被直接排版的来源。

- [ ] **Step 2: 删除或保护错误输出**

修复原则：任何选项解析、字体配置、导航配置只能进入宏定义或 Beamer template，不能在导言区/首页 template 中直接产生文本节点。修完后第一页左上角不得出现调试串。

- [ ] **Step 3: 改中文封面信息**

将 `main.tex` 中封面改为 BIT 语境。建议初版：

```tex
\title[北京理工大学 Beamer 模板 | 使用说明]{北京理工大学 Beamer 模板}
\subtitle{BIT Beamer Theme 使用说明}
\author[BIT Beamer Theme]{模板维护者\inst{1}}
\institute{\inst{1} 北京理工大学\\\mailbit{your.name@bit.edu.cn}}
\date{\today}
```

- [ ] **Step 4: 重新编译并检查首页文本**

Run:
```bash
latexmk main.tex
pdftotext -layout main.pdf tmp/review/bit-after-title.txt
sed -n '1,40p' tmp/review/bit-after-title.txt
```

Expected: 首页文本不含调试串，不含“四川大学虚拟偶像研究”、`scu.edu.cn`、`Sichuan University`。

---

### Task 2: 重建 BIT 首页视觉

**Files:**
- Modify: `beamerinnerthemebit.sty`
- Modify: `beamerthemebit.sty`
- Use: `resources/BITlogo+name.png`
- Use: `resources/BITbuilding.png`
- Use: `resources/BITemblem.png`

- [ ] **Step 1: 保留 SCU 首页版式骨架**

对照 `/Users/jerry/Projects/SCU-Beamer-Theme-main/main.pdf` 第 1 页，保留以下结构：左上 logo+校名、左侧标题块、标题下渐变分隔线、左下日期、底部弧形色带、右侧淡建筑/视觉图形。

- [ ] **Step 2: 替换视觉元素为 BIT**

在 `beamerinnerthemebit.sty` 的 title page template 中：
- `lg-name` 使用 `resources/BITlogo+name.png`。
- 右侧建筑/地标使用 `resources/BITbuilding.png`，透明度要低于正文内容。
- 若需要右上装饰，不再沿用“海纳百川”，改为 BIT 可接受的校训/精神文字，例如“德以明理 学以精工”，并作为弱水印。

- [ ] **Step 3: 调整首页色带**

用 BIT 棕金/深绿/亮绿替代 SCU 红色曲线，但不要让绿色主体压过标题。推荐首页主色用棕金，点缀深绿，底部曲线保留原 SCU 的成熟动势。

- [ ] **Step 4: 渲染对比首页**

Run:
```bash
latexmk main.tex
mkdir -p tmp/review
pdftoppm -png -r 144 -f 1 -l 1 main.pdf tmp/review/bit-title-v2
pdftoppm -png -r 144 -f 1 -l 1 /Users/jerry/Projects/SCU-Beamer-Theme-main/main.pdf tmp/review/scu-title-ref
```

Expected: `tmp/review/bit-title-v2-1.png` 没有调试串，构图节奏接近 SCU 原版，但颜色/校徽/校名/文字是 BIT。

---

### Task 3: 正文右下角使用 `BITemblem.png`

**Files:**
- Modify: `beamerthemebit.sty`
- Modify: `beamerouterthemebit.sty` or background template code in `beamerthemebit.sty`
- Use: `resources/BITemblem.png`

- [ ] **Step 1: 明确右下角实现层级**

不要把 `BITemblem.png` 塞进页脚文字栏。原版右下角校徽是正文背景/水印层，应该放在 frame background 或 outer theme canvas 层，避免影响导航和页码。

- [ ] **Step 2: 声明 BIT emblem 图像**

在 `beamerthemebit.sty` VI 分支中增加：

```tex
\pgfdeclareimage[width=.26\paperwidth]{emblem}{./resources/BITemblem.png}%
```

实际宽度可在 `.22\paperwidth` 到 `.30\paperwidth` 间微调。

- [ ] **Step 3: 在正文背景右下角绘制淡徽标**

实现要求：
- 位于右下角，中心大约在 `(.82\paperwidth, .12\paperheight)`。
- 透明度低，建议 `opacity=.08` 到 `.14`。
- 不出现在首页，或首页只作为极弱辅助元素。
- 不压住正文页脚页码。

- [ ] **Step 4: 渲染第 2 页和颜色页检查**

Run:
```bash
latexmk main.tex
pdftoppm -png -r 144 -f 2 -l 2 main.pdf tmp/review/bit-page2-emblem
pdftoppm -png -r 144 -f 10 -l 10 main.pdf tmp/review/bit-page10-emblem
```

Expected: 正文右下角显示 BIT 校徽淡水印，位置和原 SCU 页右下角水印相似，不遮挡正文和页脚。

---

### Task 4: 按 BIT 标准色重做颜色体系和颜色页

**Files:**
- Modify: `beamercolorthemebit.sty`
- Modify: `main.tex`
- Reference: `/Users/jerry/Projects/素材/ai/COLOR_USAGE/例.ai`

- [ ] **Step 1: 从 AI 参考确认色阶结构**

`COLOR_USAGE/例.ai` 渲染页显示三组标准色阶：
- 亮绿：100% 到 10%。
- 棕金：100% 到 10%。
- 深绿：100% 到 10%。

- [ ] **Step 2: 重命名颜色语义**

保留现有 `bita`/`bitb`/`bitc`/`bitd`/`bite` 对外接口以减少破坏，但在注释和文档中明确语义：
- `bita`: BIT 棕金，建议作为主导航/标题强调色。
- `bitb`: BIT 深绿，建议作为辅助强调色。
- `bitc`: BIT 亮绿，建议用于正向/示例/进度色。
- `bitd`: BIT 浅金或辅助暖色。
- `bite`: 中性灰。

- [ ] **Step 3: 校准色阶派生**

`beamercolorthemebit.sty` 中所有 `10`-`90` 派生色应对应“标准色白底递减透明/混白”的视觉效果，不再沿用 SCU `JXred/BSblue` 注释。

- [ ] **Step 4: 更新 `main.tex` 颜色页文案**

替换当前错误句子：

```tex
本模板依据四川大学 VIS 手册定义了 ...
```

改为：

```tex
本模板参考北京理工大学视觉识别系统中的标准色阶，定义了 \textcolor{bita}{\texttt{bita}}、\textcolor{bitb}{\texttt{bitb}}、\textcolor{bitc}{\texttt{bitc}}、\textcolor{bitd}{\texttt{bitd}} 和 \textcolor{bite}{\texttt{bite}} 5 个颜色系列，并提供 \texttt{10}--\texttt{90} 的浅色变体。
```

- [ ] **Step 5: 渲染颜色页检查**

Run:
```bash
latexmk main.tex
pdftoppm -png -r 144 -f 10 -l 10 main.pdf tmp/review/bit-color-page
```

Expected: 颜色页不再出现“四川大学 VIS”，色阶视觉接近 `COLOR_USAGE/例.ai` 的亮绿/棕金/深绿关系。

---

### Task 5: 明确字体策略

**Files:**
- Modify: `beamerfontthemebit.sty`
- Modify: `README.md`
- Modify: `main.tex`
- Reference: `/Users/jerry/Projects/素材/ai/LOGOTYPE_USAGE/9.ai`

- [ ] **Step 1: 记录本机字体证据**

本机已通过 `fc-list` 确认可用：
- English sans: `Helvetica`, `Helvetica Neue`, `Arial`。
- English serif: `Times`, `Times New Roman`。
- Chinese sans: `PingFang SC`, `Heiti SC`, `Hiragino Sans GB`。
- Chinese serif: `Songti SC`。

- [ ] **Step 2: 保持默认 `FontTheme=Auto -> Mac`**

当前 `Mac` 分支使用 `\setsansfont{Helvetica}` 和 `\setCJKsansfont{PingFang SC}`，符合 BIT 英文字体规范中的 Helvetica 推荐，也符合 macOS 中文展示质量。

- [ ] **Step 3: 增加文档建议，不强改所有字体**

在 README 或示例注释中写明：
- macOS 推荐 `FontTheme=Auto` 或 `FontTheme=Mac`。
- 英文标准字参考 Helvetica；如需 Arial 可新增 `FontTheme=BIT-Arial`，但首轮不引入额外选项，避免扩大测试面。
- Times Roman / Times New Roman 用于需要衬线英文展示的特殊页，不作为 Beamer 默认正文字体。

- [ ] **Step 4: 检查首页标题粗细**

如果首页中文标题显得过轻，优先在 `beamerfontthemebit.sty` 调整 Beamer font series，而不是换 CJK 字体族。

---

### Task 6: 将中文 slides 内容改成 BIT 模板内容

**Files:**
- Modify: `main.tex`

- [ ] **Step 1: 列出 SCU 残留**

Run:
```bash
rg -n "四川大学|Sichuan|SCU|scu|川大|海纳百川|江纳百川|飞扬俱乐部|雪豹|FvNCCR228|SCU_Beamer" main.tex
```

- [ ] **Step 2: 按语境改写，不做盲替换**

改写规则：
- 模板项目说明页：改为 BIT Beamer Theme 的用途、资源来源、编译要求。
- 链接页：先使用本仓库占位或删除 SCU GitHub/Gitee 链接，不保留 SCU 仓库地址作为 BIT 项目地址。
- 学院/机构：改为北京理工大学或示例学院，不出现 `Business School, Sichuan University`。
- 校训页：改为“德以明理，学以精工”。
- 图片示例页：从“四川大学校徽及校名/飞扬俱乐部”改为“北京理工大学校徽及校名/BIT 视觉识别示例”。

- [ ] **Step 3: 保留原版教学结构**

保留 SCU 原版作为 Beamer 使用说明的教学顺序：关于模板、使用注意、元素、字体/图/代码、块环境、表格、公式、参考文献、致谢。只改内容语境和视觉资源。

- [ ] **Step 4: 编译并抽取文本验证**

Run:
```bash
latexmk main.tex
pdftotext -layout main.pdf tmp/review/bit-text-after-content.txt
rg -n "四川大学|Sichuan|SCU|scu.edu.cn|海纳百川|飞扬俱乐部" tmp/review/bit-text-after-content.txt main.tex
```

Expected: 仅允许历史说明或致谢中特意提及“基于 SCU 原版改造”时出现 SCU；示例正文不能继续以 SCU 为主体。

---

### Task 7: 同步英文示例和文档

**Files:**
- Modify: `main-en.tex`
- Modify: `README.md`
- Modify: `CLAUDE.md`
- Modify: `AGENTS.md`

- [ ] **Step 1: 英文示例去 SCU 化**

Run:
```bash
rg -n "Sichuan|SCU|scu|FvNCCR228|SCU_Beamer|Sichuan University" main-en.tex
```

把标题、机构、链接、示例说明改成 BIT 语境。

- [ ] **Step 2: 文档选项名统一**

确保文档中写的是：
- `ColorDisplay=BITA | BITB | Custom`
- `Background=BIT-Full | BIT-Lite | Custom | none`
- `VI=BIT | Custom`
- `\usetheme[...]{bit}`

- [ ] **Step 3: 保留来源致谢但避免项目身份混乱**

README 可以写“本项目基于 SCU Beamer Theme 改造”，但项目标题、安装说明、示例命令必须是 BIT Beamer Theme。

---

### Task 8: 验证页数、导航和视觉回归

**Files:**
- Run only

- [ ] **Step 1: 编译中文和英文示例**

Run:
```bash
latexmk main.tex
latexmk main-en.tex
```

Expected: 两个命令退出码为 0。

- [ ] **Step 2: 检查页数差异**

Run:
```bash
pdfinfo main.pdf | rg "Pages|Title|Author"
pdfinfo /Users/jerry/Projects/SCU-Beamer-Theme-main/main.pdf | rg "Pages|Title|Author"
```

Expected: 如果页数仍与原版不同，需要在 `main.tex` 注释中说明差异原因；如果是误删，应恢复对应 frame 或 overlay。

- [ ] **Step 3: 渲染关键页**

Run:
```bash
mkdir -p tmp/review/final
for p in 1 2 10 20 30; do pdftoppm -png -r 144 -f "$p" -l "$p" main.pdf "tmp/review/final/bit-p${p}"; done
for p in 1 2 10 20 30; do pdftoppm -png -r 144 -f "$p" -l "$p" /Users/jerry/Projects/SCU-Beamer-Theme-main/main.pdf "tmp/review/final/scu-p${p}"; done
```

Expected: 关键页保持原 SCU 模板的排版密度和导航结构，但校徽、颜色、文字语境都已 BIT 化。

- [ ] **Step 4: 最终 SCU 残留扫描**

Run:
```bash
rg -n "四川大学|Sichuan|SCU|scu|川大|海纳百川|飞扬俱乐部|FvNCCR228|SCU_Beamer" main.tex main-en.tex *.sty README.md CLAUDE.md AGENTS.md
```

Expected: 只剩明确的来源致谢、兼容性注释或历史注释；用户可见示例内容和主题身份不再混用 SCU。

---

## 执行顺序建议

1. 先做 Task 1：首页调试串和封面信息是硬错误。
2. 再做 Task 3：右下角 `BITemblem.png` 是明确需求，风险低。
3. 然后做 Task 4 和 Task 5：颜色与字体先定规范，避免后续反复调视觉。
4. 再做 Task 2：首页视觉依赖颜色/字体结论，放在规范明确后细调。
5. 最后做 Task 6-8：内容 BIT 化、英文/文档同步、完整验证。

## 待确认问题

- 首页右上是否要加入 BIT 校训“德以明理，学以精工”作为弱水印？我建议加入，因为它对应 SCU 原版右上书法水印的位置和功能。
- 示例标题是否采用“北京理工大学 Beamer 模板”这种模板说明型标题，还是保留“虚拟偶像研究”但改成 BIT 学术示例？我建议改成模板说明型，减少误导。
- 英文默认字体是否保持 Helvetica，还是强制 Arial？我建议保持 Helvetica，因为 `LOGOTYPE_USAGE/9.ai` 首推 Helvetica，且当前 Mac 分支已匹配。
