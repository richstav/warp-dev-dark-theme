#!/usr/bin/env bash
# Install Warp Dark into every editor present on this machine.
# Theme files only. Does not replace whole settings files.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
THEME_NAME="Warp Dark"
VSX_ID="richstav.warp-dark-0.1.0"
HOME="${HOME:?}"

log() { printf '%s\n' "$*"; }

ensure_json_object_file() {
  local path="$1"
  mkdir -p "$(dirname "$path")"
  if [[ ! -f "$path" ]] || [[ ! -s "$path" ]]; then
    printf '{\n}\n' >"$path"
  fi
}

set_zed_theme() {
  local settings="$1"
  ensure_json_object_file "$settings"
  python3 - "$settings" "$THEME_NAME" <<'PY'
import json, pathlib, re, sys
path = pathlib.Path(sys.argv[1])
name = sys.argv[2]
text = path.read_text()
# jsonc: strip // comments for parse, then rewrite theme block via regex
if re.search(r'"theme"\s*:', text):
    text, n = re.subn(
        r'("dark"\s*:\s*")[^"]*(")',
        rf'\1{name}\2',
        text,
        count=1,
    )
    if n == 0:
        text = re.sub(
            r'("theme"\s*:\s*\{)',
            rf'\1\n    "dark": "{name}",',
            text,
            count=1,
        )
else:
    text = re.sub(
        r'\}\s*$',
        f'  "theme": {{\n    "mode": "dark",\n    "dark": "{name}"\n  }}\n}}\n',
        text,
        count=1,
    )
path.write_text(text)
print(f"zed settings -> {path}")
PY
}

set_vscode_theme() {
  local settings="$1"
  ensure_json_object_file "$settings"
  python3 - "$settings" "$THEME_NAME" <<'PY'
import pathlib, re, sys
path = pathlib.Path(sys.argv[1])
name = sys.argv[2]
text = path.read_text()
if re.search(r'"workbench\.colorTheme"\s*:', text):
    text = re.sub(
        r'("workbench\.colorTheme"\s*:\s*")[^"]*(")',
        rf'\1{name}\2',
        text,
        count=1,
    )
else:
    # insert after opening brace
    text = re.sub(
        r'^\s*\{',
        '{\n  "workbench.colorTheme": "%s",' % name,
        text,
        count=1,
    )
path.write_text(text)
print(f"vscode-family settings -> {path}")
PY
}

install_zed() {
  local cfg="${XDG_CONFIG_HOME:-$HOME/.config}/zed"
  [[ -d "$cfg" || -x "$(command -v zed 2>/dev/null || true)" ]] || {
    log "skip zed (not present)"
    return 0
  }
  mkdir -p "$cfg/themes" "$HOME/.local/share/zed/extensions/installed/zed-warp-dev-theme/themes"
  cp "$ROOT/editors/zed/themes/warp-dark.json" "$cfg/themes/warp-dark.json"
  cp "$ROOT/editors/zed/extension.toml" "$HOME/.local/share/zed/extensions/installed/zed-warp-dev-theme/extension.toml"
  cp "$ROOT/editors/zed/themes/warp-dark.json" "$HOME/.local/share/zed/extensions/installed/zed-warp-dev-theme/themes/warp-dark.json"
  set_zed_theme "$cfg/settings.json"
  log "installed zed"
}

install_vscode_family() {
  local ext_dir="$1"
  local settings="$2"
  local label="$3"
  mkdir -p "$ext_dir/$VSX_ID"
  cp "$ROOT/editors/vscode/package.json" "$ext_dir/$VSX_ID/package.json"
  cp "$ROOT/editors/vscode/warp-dark-color-theme.json" "$ext_dir/$VSX_ID/warp-dark-color-theme.json"
  set_vscode_theme "$settings"
  log "installed $label"
}

install_zed

# Cursor
if [[ -d "$HOME/.cursor/extensions" || -d "$HOME/.config/Cursor" ]]; then
  install_vscode_family \
    "$HOME/.cursor/extensions" \
    "$HOME/.config/Cursor/User/settings.json" \
    "cursor"
else
  log "skip cursor (not present)"
fi

# Antigravity (Google Antigravity IDE)
if [[ -d "$HOME/.antigravity-ide/extensions" || -d "$HOME/.config/Antigravity IDE" ]]; then
  install_vscode_family \
    "$HOME/.antigravity-ide/extensions" \
    "$HOME/.config/Antigravity IDE/User/settings.json" \
    "antigravity"
else
  log "skip antigravity (not present)"
fi

# VSCodium / VS Code
if [[ -d "$HOME/.vscode-oss/extensions" ]]; then
  install_vscode_family \
    "$HOME/.vscode-oss/extensions" \
    "$HOME/.config/VSCodium/User/settings.json" \
    "vscodium"
fi
if [[ -d "$HOME/.vscode/extensions" ]]; then
  install_vscode_family \
    "$HOME/.vscode/extensions" \
    "$HOME/.config/Code/User/settings.json" \
    "vscode"
fi

log "done. Reload each editor to pick up Warp Dark."
log "KDE Plasma theme is a separate repo: https://github.com/richstav/kde-warp-dev-dark-theme"
