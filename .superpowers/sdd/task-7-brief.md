### Task 7: 更新 resource-deployment.md 文档

**Files:**
- Modify: `docs/dev/resource-deployment.md`

- [ ] **Step 1: 修正文档描述**

将 `docs/dev/resource-deployment.md` 中 "How it works" 部分的代码示例从：

```latex
\def\bit@resolve@resource#1{%
  \IfFileExists{./resources/#1}{./resources/#1}{#1}%
}
```

改为：

```latex
\newcommand{\bit@def@resource}[2]{%
  % #1 = control sequence to define, #2 = resource filename
  \IfFileExists{./resources/#2}{\def#1{./resources/#2}}{\def#1{#2}}%
}
```

所有 `\pgfdeclareimage` 调用使用此宏。当从项目根目录编译时，`./resources/` 存在并被使用。当从子目录编译且设置了 `TEXINPUTS` 时，回退的裸文件名通过 TeX 搜索路径找到。

- [ ] **Step 2: 提交**

```bash
cd /Users/jerry/Projects/bit_beamer_theme
git add docs/dev/resource-deployment.md
git commit -m "docs: fix resource-deployment.md to match actual implementation"
```
