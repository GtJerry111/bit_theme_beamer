# beamer-bit Skill

BIT Beamer Theme (北京理工大学 Beamer 模板) 专用 Claude Code Skill。

用于：论文/报告转 Beamer Slides、从零创建 Slides、修改已有 Slides、选择主题参数、排查编译问题。

## 使用

在 Claude Code 中输入：

```
/beamer-bit
```

触发场景：提到 beamer-bit、北京理工大学 beamer、BIT beamer、北理工 slides，或执行论文转 Slides、从零创建、修改已有 Slides 等任务。

### 使用示例

```
# 将论文转为 Slides
/beamer-bit 把这篇论文转成 beamer slides

# 从零创建 Slides
/beamer-bit 我要做一个 15 分钟的学术报告，主题是深度学习

# 修改已有 Slides
/beamer-bit 帮我改一下 slides 的配色和动画

# 查询配置
/beamer-bit 有哪些配色方案？
```

## 功能模块

| 模块文件 | 用途 |
|----------|------|
| config-overview.md | 选项速查 + 场景配置 + 废弃选项 |
| config-detail.md | 15 个选项的详细说明（用户问具体选项时加载） |
| workflow.md | 任务工作流：论文转 Slides / 从零创建 / 修改已有 + 标题页信息 |
| templates.md | 模板库：帧类型、14 个环境、代码、公式、图表、参考文献、交叉引用 |
| mwe.md | 完整最小工作示例（双栏帧、公式、动画、附录） |
| typography.md | 排版规则 + 内容压缩策略 |
| customization.md | 高级定制：自定义颜色/字体/背景/VI + 配色基色 + 扩展宏包 |
| troubleshooting.md | 问题排查：9 个常见问题 + latexmk 配置 |

## 数据来源

- `main` 分支：5 个 `.sty` 源码文件
- `manual` 分支：用户手册文档

## 版本

| Skill 版本 | 对应主题版本 | 变更 |
|-----------|------------|------|
| v1.0 | v2.1g(2026/06/26) | 基于 beamer-scu v2.1g 适配 BIT：替换全部 SCU 专有项为 BIT 对应项 |
