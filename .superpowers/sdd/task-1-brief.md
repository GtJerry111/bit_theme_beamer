### Task 1: 实现 SectionNavStyle=auto 模式

**Files:**
- Modify: `beamerouterthemebit.sty:39-42` (选项声明)
- Modify: `beamerouterthemebit.sty:159-170` (`\insert@secbar` 定义)

- [ ] **Step 1: 更新 SectionNavStyle 选项声明**

在 `beamerouterthemebit.sty` 第 40-41 行，将：

```latex
% KEY:: SectionNavStyle.
% VALUE:: full | current | none.
\DeclareOptionBeamer{SectionNavStyle}{\def\beamer@bit@SectionNavStyle{#1}}
```

改为：

```latex
% KEY:: SectionNavStyle.
% VALUE:: auto | full | current | none.
\DeclareOptionBeamer{SectionNavStyle}{\def\beamer@bit@SectionNavStyle{#1}}
```

- [ ] **Step 2: 修改 `\insert@secbar` 添加 auto 分支**

在 `beamerouterthemebit.sty` 第 159-170 行，将：

```latex
% 插入章节栏水平导航.
\def\insert@secbar#1{%
  % #1:: en LanguageMode 下尾部距离.
  \usebeamerfont{section in head/foot}%
  \usebeamercolor[fg]{section in head/foot}%
  \if\EqualOptionsBeamer{SectionNavStyle}{full}%
    \insertsectionnavigationhorizontal{\bit@wd@secbar}{}{}%
  \else\if\EqualOptionsBeamer{SectionNavStyle}{current}%
    \insertsectionhead\hspace*{#1}%
  \else\if\EqualOptionsBeamer{SectionNavStyle}{none}%
    \relax%
  \fi\fi\fi%
}
```

改为：

```latex
% 插入章节栏水平导航.
\def\insert@secbar#1{%
  % #1:: en LanguageMode 下尾部距离.
  \usebeamerfont{section in head/foot}%
  \usebeamercolor[fg]{section in head/foot}%
  \if\EqualOptionsBeamer{SectionNavStyle}{auto}%
    % auto 模式：先测量 full 模式宽度，超出则回退到 current
    \setbox\@tempboxa=\hbox{\insertsectionnavigationhorizontal{\bit@wd@secbar}{}{}}%
    \ifdim\wd\@tempboxa>\bit@wd@secbar\relax%
      \insertsectionhead\hspace*{#1}%
    \else%
      \box\@tempboxa%
    \fi%
  \else\if\EqualOptionsBeamer{SectionNavStyle}{full}%
    \insertsectionnavigationhorizontal{\bit@wd@secbar}{}{}%
  \else\if\EqualOptionsBeamer{SectionNavStyle}{current}%
    \insertsectionhead\hspace*{#1}%
  \else\if\EqualOptionsBeamer{SectionNavStyle}{none}%
    \relax%
  \fi\fi\fi\fi%
}
```

- [ ] **Step 3: 编译验证**

```bash
cd /Users/jerry/Projects/bit_beamer_theme && latexmk main.tex
```

预期：编译成功，无错误。

- [ ] **Step 4: 提交**

```bash
cd /Users/jerry/Projects/bit_beamer_theme
git add beamerouterthemebit.sty
git commit -m "feat: add SectionNavStyle=auto mode with width-based fallback to current"
```

---

