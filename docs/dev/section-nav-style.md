# SectionNavStyle Option

The `SectionNavStyle` option controls how section navigation is displayed in the header bar. It is independent of `LanguageMode`, which now only controls text localization (date format, TOC titles, etc.).

## Usage

```latex
\usetheme[SectionNavStyle=full]{bit}    % default
\usetheme[SectionNavStyle=current]{bit}
\usetheme[SectionNavStyle=none]{bit}
```

## Modes

| Mode | Behavior |
|------|----------|
| `full` | Show all section names in header, highlight current section with PrimaryC background |
| `current` | Show only the current section name |
| `none` | Hide section navigation entirely |

## Default

`SectionNavStyle=full` — matches the previous `LanguageMode=cn` behavior.

## SecBarWidth

The section bar width can be configured independently:

```latex
\usetheme[SecBarWidth=0.5\paperwidth]{bit}   % default
\usetheme[SecBarWidth=0.3\paperwidth]{bit}   % narrower
```

The default value is `0.4\paperwidth`. Use a wider value when you have many sections with long names.

## Backward Compatibility

Previously, `LanguageMode=cn` showed full section navigation and `LanguageMode=en` showed only the current section. Now:

- `LanguageMode` controls only text localization (Chinese vs English strings)
- `SectionNavStyle` controls navigation rendering

The default `SectionNavStyle=full` preserves the previous Chinese-mode behavior. Users who preferred the English-mode navigation style can set `SectionNavStyle=current`.
