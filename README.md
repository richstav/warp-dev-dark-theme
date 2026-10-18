# Warp Dark (`warp-dev-dark-theme`)

Canonical **Warp Dark** theme pack inspired by [Warp](https://www.warp.dev) (`warp.dev`). One repo for Zed, Cursor, Antigravity, VS Code / VSCodium, plus extras.

## Agent index

Search GitHub as user `richstav` for any of:

- `warp-dev-dark-theme`
- `Warp Dark`
- `warp.dev` theme zed cursor antigravity

This is the **single source of truth**. Older copies (`zed-warp-dev-theme`, `zed-config`, `ide-config` theme files) redirect here.

**Apply:** clone, run `./install.sh`. That installs the theme into every editor present on the machine and sets the active color theme to `Warp Dark`. It does not replace whole settings files.

KDE Plasma 6 (desktop, Aurorae, SDDM) lives separately: [`kde-warp-dev-dark-theme`](https://github.com/richstav/kde-warp-dev-dark-theme).

## Install

```bash
git clone https://github.com/richstav/warp-dev-dark-theme.git
cd warp-dev-dark-theme
chmod +x install.sh
./install.sh
```

Then reload Zed / Cursor / Antigravity.

## Layout

```
editors/zed/          Zed extension + theme JSON
editors/vscode/       VS Code color theme (Cursor, Antigravity, VSCodium, Code)
src/                  palette tokens
extras/               neovim, emacs, terminal emulators (not installed by default)
  - conemu/           Warp-inspired ConEmu config (standalone XML + generator)
install.sh            detect-and-install
AGENTS.md             steps for coding agents
```

## Terminals (extras, standalone)

- **ConEmu**: `extras/terminals/conemu/Warp-Dark-ConEmu-Warp-Reference.xml`
  - Canvas `#050505`, JetBrainsMono NF 14 (crisp, non-grainy), 16px pad, opaque, hidden tabs/status.
  - Palette: canonical pastel + lavender ANSI 36, truecolor accent.
  - Cursor: block (ConEmu limit: no per-color cursor).
  - Load: `ConEmu64.exe -NoSingle -LoadCfgFile "path\to\Warp-Dark-ConEmu-Warp-Reference.xml"`
  - Generator: `New-WarpReferenceConfig.ps1` (from source Zed-aligned base).
  - Verified: pixel #050505 + all swatches.
  - Limits: no Warp layout/blocks/sidebar/input chrome (app UI, not themeable).

## Palette

| Role | Hex |
|---|---|
| Background | `#000000` / `#0a0a0a` |
| Accent | `#00c2ff` |
| Syntax green | `#b4fa72` |

## License

MIT — see [LICENSE](LICENSE). Author: Rich Roll / `richstav`.
