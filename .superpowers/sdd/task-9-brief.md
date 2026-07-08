### Task 9: 端到端验证

**Files:**
- 无新文件

- [ ] **Step 1: 编译中文示例**

```bash
cd /Users/jerry/Projects/bit_beamer_theme && latexmk main.tex
```

预期：编译成功，无错误，PDF 正常生成。

- [ ] **Step 2: 编译英文示例**

```bash
cd /Users/jerry/Projects/bit_beamer_theme && latexmk main-en.tex
```

预期：编译成功，无错误。

- [ ] **Step 3: 编译 10 章节测试**

```bash
cd /Users/jerry/Projects/bit_beamer_theme/docs/examples && latexmk auto-nav-test.tex
```

预期：编译成功，页眉章节导航不溢出。

- [ ] **Step 4: 验证 ISA YAML 语法**

```bash
cd /Users/jerry/Projects/bit_beamer_theme
python3 -c "import yaml; yaml.safe_load(open('isa/BIT.yaml').read()); print('ISA OK')"
```

预期：输出 `ISA OK`。

- [ ] **Step 5: 运行 verify-bit-theme.sh**

```bash
cd /Users/jerry/Projects/bit_beamer_theme && bash scripts/verify-bit-theme.sh
```

预期：所有检查通过。

- [ ] **Step 6: 提交最终验证结果**

```bash
cd /Users/jerry/Projects/bit_beamer_theme
git add -A
git commit -m "chore: final verification - all tests pass"
```
