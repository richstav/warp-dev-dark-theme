# Warp Dark — agent instructions

Repo: `richstav/warp-dev-dark-theme`  
Theme label in every editor: `Warp Dark`

## When this repo applies

User asks to install, restore, sync, or find the Warp / warp.dev / Warp Dark theme for Zed, Cursor, Antigravity, VS Code, or VSCodium.

## Find

GitHub search (authenticated as `richstav`):

```
user:richstav warp-dev-dark-theme
user:richstav "Warp Dark"
```

Clone: `https://github.com/richstav/warp-dev-dark-theme.git`

## Apply

1. Clone this repo (or pull if already cloned).
2. Run `./install.sh` from the repo root.
3. Done when:
   - Zed: `~/.config/zed/themes/warp-dark.json` exists and `settings.json` `"theme"."dark"` is `"Warp Dark"`.
   - Cursor: `~/.cursor/extensions/richstav.warp-dark-0.1.0/` exists and `~/.config/Cursor/User/settings.json` has `"workbench.colorTheme": "Warp Dark"`.
   - Antigravity: `~/.antigravity-ide/extensions/richstav.warp-dark-0.1.0/` exists and `~/.config/Antigravity IDE/User/settings.json` has `"workbench.colorTheme": "Warp Dark"`.
4. Tell the user to reload each editor.

`install.sh` skips editors that are not installed. It patches only the theme key; leave the rest of settings alone.

## Edit the theme

Change tokens in `src/`, then the editor files:

- Zed: `editors/zed/themes/warp-dark.json`
- VS Code family: `editors/vscode/warp-dark-color-theme.json` and `editors/vscode/package.json`

Re-run `./install.sh` after edits.

## Related

- Plasma desktop: `richstav/kde-warp-dev-dark-theme`
- Do not treat `zed-warp-dev-theme`, `zed-config`, or `ide-config` as the live theme source.
