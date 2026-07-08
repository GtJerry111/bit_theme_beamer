### Task 5: 同步 ISA — 添加新选项和更新 prose

**Files:**
- Modify: `isa/BIT.yaml`

- [ ] **Step 1: 添加 SectionNavStyle 和 SecBarWidth 选项**

在 `isa/BIT.yaml` 的 `options:` 列表中，在 `overflowguard` 行之前添加：

```yaml
  - { name: SectionNavStyle, values: [auto, full, current, none], default: auto }
  - { name: SecBarWidth, values: [auto], type: dimen, default: auto }
  - { name: OverlayMode, values: [direct, fade, none], default: direct }
```

- [ ] **Step 2: 更新 overflowguard 默认值**

将：

```yaml
  - { name: overflowguard, values: [on, off], default: off }
```

改为：

```yaml
  - { name: overflowguard, values: [on, off], default: on }
```

- [ ] **Step 3: 更新 prose 字段 — 添加 Intent 阶段必须询问的问题**

在 `prose:` 字段末尾添加以下内容：

```yaml
  ## Intent 阶段必须询问用户的问题

  在 Intent 阶段，必须询问用户以下问题，并根据回答配置主题选项：

  ### 1. 语言偏好（必须询问）
  "你的幻灯片使用中文还是英文？"
  - 中文 → LanguageMode=cn（默认）
  - 英文 → LanguageMode=en（TOC 标题变为 "Outline"，定理环境用英文）

  ### 2. 面向人群（必须询问）
  "你的听众是谁？"
  - 学术同行（同领域研究者）→ OverlayMode=fade, 定理环境多，代码高亮
  - 答辩委员会（跨领域专家）→ OverlayMode=direct, Density=dense, 内容密集
  - 学生/教学 → OverlayMode=fade 或 none, 动画帮助理解
  - 会议演讲（混合背景）→ OverlayMode=direct, NavigationTool=1-2-3 方便跳转

  ### 3. 演讲时间（必须询问）
  "你的演讲时长是多少分钟？"
  用于计算页数预算（考虑 overlay 膨胀因子）：
  - 10 分钟 → 8-12 页
  - 15 分钟 → 12-18 页
  - 20 分钟 → 18-25 页
  - 30 分钟 → 25-35 页

  ### 4. 框架偏好（必须询问）
  "你希望幻灯片如何组织？"
  - 按论文章节（Introduction → Method → Results → Conclusion）→ 使用 \section 分隔，SubsectionTOC=on
  - 按逻辑主题（Problem → Approach → Demo → Takeaway）→ 可能不用 \section，SubsectionTOC=off
  - 混合模式（主框架按章节，子主题按逻辑）→ 使用 \subsection，SubsectionTOC=first-only

  ## 章节导航（重要）
  默认 SectionNavStyle=auto 会自动检测章节数量：
  - 章节名总宽度 ≤ secbar 宽度：显示所有章节名（full 模式）
  - 章节名总宽度 > secbar 宽度：自动回退到只显示当前章节名（current 模式）
  对于论文转换，推荐使用默认值 auto。如果用户明确要求显示所有章节，可设置 full。

  ## 不要生成 TOC frame（重要）
  BIT 主题通过 SubsectionTOC=on 在每个小节开始自动生成渐进式目录（双栏、当前章节高亮、其他章节淡化）。
  因此：
  - order.txt 中 **不要** 包含 TOC frame
  - 不要生成 `\begin{frame}{目录}\tableofcontents\end{frame}`
  - 让主题的自动 TOC 机制处理目录显示

  ## 目录自动双栏
  当章节数 > 5 时，主题自动启用双栏目录，左右平衡分布章节。
  用户无需手动设置 ContentMuticols 选项。

  ## 推荐的 \usetheme 选项（paper2beamer）
  以下选项推荐在 paper2beamer 生成的 deck 中使用：
  - SectionNavStyle=auto（默认）：自动适应章节数量
  - SecBarWidth=auto（默认）：自适应章节栏宽度
  - OverlayMode=direct（默认）：所有内容直接显示，无动画
  - overflowguard=on（默认）：启用溢出保护
  - NavigationTool=1-2-3：显示页脚导航工具栏
  - BIBMode=none：paper2beamer 不生成参考文献
  - Background=BIT-Full：使用完整背景设计
```

- [ ] **Step 4: 验证 YAML 语法**

```bash
cd /Users/jerry/Projects/bit_beamer_theme
python3 -c "import yaml; yaml.safe_load(open('isa/BIT.yaml').read()); print('OK')"
```

预期：输出 `OK`。

- [ ] **Step 5: 提交**

```bash
cd /Users/jerry/Projects/bit_beamer_theme
git add isa/BIT.yaml
git commit -m "feat: sync ISA with new options and Intent-stage user questions"
```
