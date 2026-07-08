# SectionNavStyle Option

The `SectionNavStyle` option controls how section navigation is displayed in the header bar. It is independent of `LanguageMode`, which now only controls text localization (date format, TOC titles, etc.).

## Usage

```latex
\usetheme[SectionNavStyle=auto]{bit}     % default
\usetheme[SectionNavStyle=full]{bit}
\usetheme[SectionNavStyle=current]{bit}
\usetheme[SectionNavStyle=none]{bit}
```

## Modes

| Mode | Behavior |
|------|----------|
| `auto` | **Default.** Auto-detect: show all section names when total width ≤ secbar width, fallback to current-only when overflow |
| `full` | Show all section names in header, highlight current section with PrimaryC background |
| `current` | Show only the current section name |
| `none` | Hide section navigation entirely |

## Default

`SectionNavStyle=auto` — automatically adapts to section count, prevents overflow.

## SecBarWidth

The section bar width can be configured independently:

```latex
\usetheme[SecBarWidth=auto]{bit}              % default, adaptive
\usetheme[SecBarWidth=0.5\paperwidth]{bit}    % fixed width
\usetheme[SecBarWidth=0.3\paperwidth]{bit}    % narrower
```

`SecBarWidth=auto` is equivalent to `0.4\paperwidth`, but semantically means "let the theme decide automatically".

## Backward Compatibility

Previously, `LanguageMode=cn` showed full section navigation and `LanguageMode=en` showed only the current section. Now:

- `LanguageMode` controls only text localization (Chinese vs English strings)
- `SectionNavStyle` controls navigation rendering

The default `SectionNavStyle=auto` preserves the previous Chinese-mode behavior for small section counts, while automatically preventing overflow for large section counts.
