### Task 12: 更新 README.md — 添加 OverlayMode 和 TOC 自动双栏说明

**Files:**
- Modify: `README.md`

- [ ] **Step 1: 更新 MWE 中的 OverlayMode 注释**

在 `README.md` 的 MWE 代码块中，找到：

```latex
	% SubsectionTOC=, % on ️ | off | first-only → 小节目录显示控制
```

在其后添加：

```latex
	% OverlayMode=, % direct ⚙️ | fade | none → 逐行显示效果控制
```

- [ ] **Step 2: 添加 OverlayMode 选项说明**

在 `README.md` 的 "SubsectionTOC 选项" 部分之后，添加：

```markdown
### OverlayMode 选项

`OverlayMode` 选项控制逐行显示效果：

```latex
\usetheme[OverlayMode=direct]{bit}  % 默认，所有内容直接显示
\usetheme[OverlayMode=fade]{bit}    % 逐行出现，未出现的行显示为灰色半透明
\usetheme[OverlayMode=none]{bit}    % 逐行出现，但未出现的行完全隐藏
```

| 模式 | 行为 |
|------|------|
| `direct` | **默认。** 所有内容直接显示，没有动画（适合快速浏览/打印讲义） |
| `fade` | 逐行出现，未出现的行显示为灰色半透明（传统演讲模式） |
| `none` | 逐行出现，但未出现的行完全隐藏（无灰色干扰） |

**默认值：** `OverlayMode=direct` — 所有内容直接显示，无动画。

### TOC 自动双栏

当章节数 > 5 时，主题自动启用双栏目录，左右平衡分布章节。
用户无需手动设置 `ContentMuticols` 选项。

**阈值：** > 5 章节（6 个章节开始双栏）
```

- [ ] **Step 3: 更新更新记录**

在 "更新记录" 部分的 v2.1j 条目中，添加：

```markdown
- 新增 `OverlayMode` 选项：控制逐行显示效果（direct/fade/none）
- 新增 TOC 自动双栏：章节数 > 5 时自动启用双栏目录
```

- [ ] **Step 4: 提交**

```bash
cd /Users/jerry/Projects/bit_beamer_theme
git add README.md
git commit -m "docs: add OverlayMode and auto two-column TOC documentation"
```
