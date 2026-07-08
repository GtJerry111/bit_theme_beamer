### Task 6: 更新 section-nav-style.md 文档

**Files:**
- Modify: `docs/dev/section-nav-style.md`

- [ ] **Step 1: 更新文档内容**

将 `docs/dev/section-nav-style.md` 的 Modes 表格部分替换为：

```markdown
## Modes

| Mode | Behavior |
|------|----------|
| `auto` | **默认。** 自动检测：章节名总宽度 ≤ secbar 宽度时显示全部（full），超出时回退到仅当前章节（current） |
| `full` | 显示所有章节名称，用 PrimaryC 背景高亮当前章节 |
| `current` | 仅显示当前章节名称 |
| `none` | 完全隐藏章节导航 |

## Default

`SectionNavStyle=auto` — 自动适应章节数量，避免溢出。

## SecBarWidth

章节栏宽度可以独立配置：

```latex
\usetheme[SecBarWidth=auto]{bit}         % 默认，自适应
\usetheme[SecBarWidth=0.5\paperwidth]{bit}   % 固定宽度
\usetheme[SecBarWidth=0.3\paperwidth]{bit}   % 更窄
```

`SecBarWidth=auto` 等价于 `0.4\paperwidth`，但语义上表示"让主题自动决定"。
```

- [ ] **Step 2: 提交**

```bash
cd /Users/jerry/Projects/bit_beamer_theme
git add docs/dev/section-nav-style.md
git commit -m "docs: update section-nav-style.md with auto mode"
```
