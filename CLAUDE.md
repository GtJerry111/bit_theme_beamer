# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

BIT Beamer Theme — 北京理工大学 Beamer 演示文稿模板。基于 LaTeX Beamer 构建，提供完整的北京理工大学视觉识别（VI）配色、字体、背景和布局。

## Build Commands

```bash
# 编译中文示例
latexmk main.tex

# 编译英文示例
latexmk main-en.tex

# 清理中间文件（保留 PDF）
latexmk -c main.tex

# 完全清理（含 PDF）
latexmk -C main.tex
```

编译引擎：XeLaTeX → xdvipdfmx（由 `.latexmkrc` 配置）。aux 文件输出至 `tmp/build/`。

## Theme Architecture

模板按 Beamer 主题系统拆分为 5 个 `.sty` 文件，通过 `\usetheme[options]{bit}` 统一加载：

| 文件 | 职责 |
|------|------|
| `beamerthemebit.sty` | 主入口：声明所有选项键值，加载子主题，定义通用命令和环境（定理框、代码框、目录等） |
| `beamercolorthemebit.sty` | 颜色主题：定义 JXred/BSblue/Custom 三套配色，所有颜色变量 |
| `beamerfontthemebit.sty` | 字体主题：管理 Auto/Ubuntu/Win/Mac/Fandol/Source-Han 等字体方案和数学字体 |
| `beamerinnerthemebit.sty` | 内部主题：封面页、目录页、itemize/enumerate、block 环境、脚注等内部元素样式 |
| `beamerouterthemebit.sty` | 外部主题：页眉双栏（节导航+标题栏）、页脚双栏（导航+信息行）、侧边栏、徽标 |

### Key Theme Options

所有选项通过 `\usetheme[<key>=<value>,...]{bit}` 传入：
- `ColorDisplay` — JXred（默认）| BSblue | Custom
- `BlockDisplay` — colorful（默认）| followtheme | allgrey
- `CodeTheme` — listing（默认）| minted | minted2
- `LanguageMode` — cn（默认）| en
- `Miniframes` — follow（默认）| separate | none
- `NavigationTool` — 1-2-3（默认）| none
- `FontTheme` — Auto（默认）| Ubuntu | Win | Mac | Fandol | Source-Han | ...
- `MathFont` — LM（默认）| XITS
- `BIBMode` — biber（默认）| none
- `Background` — SCU-Full（默认）| SCU-Lite | Custom | none

### Project Structure

```
.
├── beamerthemebit.sty          # 主宏包
├── beamercolorthemebit.sty     # 颜色主题
├── beamerfontthemebit.sty      # 字体主题
├── beamerinnerthemebit.sty     # 内部主题
├── beamerouterthemebit.sty     # 外部主题
├── main.tex                    # 中文示例文档
├── main-en.tex                 # 英文示例文档
├── ref.bib                     # 参考文献数据库
├── .latexmkrc                  # latexmk 编译配置
├── resources/                  # 背景图、Logo 等资源文件
├── image/                      # PDF 插图（Logo、停止符等）
├── fonts/                      # 字体文件（含 README）
├── include-sec/                # 章节 .tex 文件目录
├── docs/                       # 文档、贡献指南、安装脚本
├── sourcecode/                 # 示例代码文件
└── tmp/build/                  # 编译中间文件输出目录
```

### Design Highlights

- **封面与正文**：采用不同背景，正文背景低透明度淡色以保证可读性
- **页眉**：双行设计 — 首行节标题导航 + 校名，次行小节标题 + 迷你帧圆点 + 帧标题
- **页脚**：双行设计 — 首行导航栏，次行作者/机构/日期/页码
- **环境**：预定义定理环境（定理、引理、证明等）、代码高亮（listings/minted）、公式、算法等

## Development Notes

- 修改 `.sty` 文件前请备份，改动后需重新编译主文档验证
- `.latexmkrc` 中 `$aux_dir = 'tmp/build'`，若新增 `include-sec/` 子目录需在 `tmp/build/include-sec/` 下创建对应目录
- 字体相关改动需在 `beamerfontthemebit.sty` 中进行
- 颜色相关改动需在 `beamercolorthemebit.sty` 中进行
- 不使用 `pstricks`（与 `adjustbox` 冲突）
