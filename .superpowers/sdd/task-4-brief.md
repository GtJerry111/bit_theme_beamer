### Task 4: 创建 10 章节测试文件验证 auto 模式

**Files:**
- Create: `docs/examples/auto-nav-test.tex`

- [ ] **Step 1: 创建测试文件**

创建 `docs/examples/auto-nav-test.tex`：

```latex
% !TeX encoding = UTF-8
% !TeX TS-program = latexmk
\PassOptionsToPackage{cmyk}{xcolor}
\documentclass[aspectratio=169, hyperref, UTF8, CJK]{beamer}

\usetheme[
  SectionNavStyle=auto,
  SecBarWidth=auto,
]{bit}

\title{10 章节导航测试}
\author{测试作者}
\institute{北京理工大学}
\date{\today}

\begin{document}

\section{引言}
\subsection{背景}
\begin{frame}{测试帧 1}
  内容
\end{frame}

\section{相关工作}
\subsection{文献综述}
\begin{frame}{测试帧 2}
  内容
\end{frame}

\section{方法论}
\subsection{方法一}
\begin{frame}{测试帧 3}
  内容
\end{frame}

\section{实验设计}
\subsection{数据集}
\begin{frame}{测试帧 4}
  内容
\end{frame}

\section{实验结果}
\subsection{主要结果}
\begin{frame}{测试帧 5}
  内容
\end{frame}

\section{消融实验}
\subsection{组件分析}
\begin{frame}{测试帧 6}
  内容
\end{frame}

\section{可视化}
\subsection{特征图}
\begin{frame}{测试帧 7}
  内容
\end{frame}

\section{局限性}
\subsection{不足}
\begin{frame}{测试帧 8}
  内容
\end{frame}

\section{未来工作}
\subsection{改进方向}
\begin{frame}{测试帧 9}
  内容
\end{frame}

\section{总结}
\subsection{结论}
\begin{frame}{测试帧 10}
  内容
\end{frame}

\end{document}
```

- [ ] **Step 2: 编译测试**

```bash
cd /Users/jerry/Projects/bit_beamer_theme/docs/examples && latexmk auto-nav-test.tex
```

预期：编译成功，页眉章节导航不溢出（auto 模式应回退到 current 样式）。

- [ ] **Step 3: 提交**

```bash
cd /Users/jerry/Projects/bit_beamer_theme
git add docs/examples/auto-nav-test.tex
git commit -m "test: add 10-section test file for SectionNavStyle=auto verification"
```
