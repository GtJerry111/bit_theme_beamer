### Task 8: 更新 README.md

**Files:**
- Modify: `README.md`

- [ ] **Step 1: 更新 MWE 中的注释**

在 `README.md` 的 MWE 代码块中，找到：

```latex
	% SectionNavStyle=, % full ⚙️ | current | none → 页眉章节导航样式
	% SecBarWidth=, % 0.4\paperwidth ️ | <dimen> → 章节栏宽度
	% overflowguard=, % off ⚙️ | on → 溢出保护 (paper2beamer 集成)
```

改为：

```latex
	% SectionNavStyle=, % auto ⚙️ | full | current | none → 页眉章节导航样式
	% SecBarWidth=, % auto ⚙️ | <dimen> → 章节栏宽度
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
