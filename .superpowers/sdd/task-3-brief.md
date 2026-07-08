### Task 3: 更新默认值为 auto

**Files:**
- Modify: `beamerthemebit.sty:176` (默认值)
- Modify: `beamerthemebit.sty:179` (SecBarWidth 默认值)

- [ ] **Step 1: 修改默认值**

在 `beamerthemebit.sty` 第 176 行，将：

```latex
  SectionNavStyle=full,
```

改为：

```latex
  SectionNavStyle=auto,
```

在 `beamerthemebit.sty` 第 179 行，将：

```latex
  SecBarWidth=0.4\paperwidth%
```

改为：

```latex
  SecBarWidth=auto%
```

- [ ] **Step 2: 编译验证**

```bash
cd /Users/jerry/Projects/bit_beamer_theme && latexmk main.tex
```

预期：编译成功，无错误。

- [ ] **Step 3: 编译英文示例**

```bash
cd /Users/jerry/Projects/bit_beamer_theme && latexmk main-en.tex
```

预期：编译成功，无错误。

- [ ] **Step 4: 提交**

```bash
cd /Users/jerry/Projects/bit_beamer_theme
git add beamerthemebit.sty
git commit -m "feat: change default SectionNavStyle to auto, SecBarWidth to auto"
```
