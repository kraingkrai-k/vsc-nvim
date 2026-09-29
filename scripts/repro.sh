#!/usr/bin/env bash
# Reproduce Neovim behaviour in a real pty (not --headless: VeryLazy / which-key need a UI).
#
#   scripts/repro.sh start [file]          start nvim in a pty (default: TSX fixture project)
#   scripts/repro.sh wait '<expr>' [sec]   poll until vimscript <expr> is truthy (default 15s)
#   scripts/repro.sh keys <k>... [N] <k>   send keys (vim notation), a bare number = sleep N sec
#                                          literal "<" must be written <lt> (e.g. 'o<lt>div>')
#   scripts/repro.sh expr '<expr>'         evaluate vimscript in the repro nvim
#   scripts/repro.sh lua '<lua expr>'      evaluate a lua expression in the repro nvim
#   scripts/repro.sh stop                  quit the repro nvim
#   scripts/repro.sh live ['<expr>']       list your running nvim sessions (STALE = started before
#                                          last config change), optionally eval <expr> in each
#
# Example: <Space> then pause longer than timeoutlen, then sg → should open Telescope
#   scripts/repro.sh start && scripts/repro.sh wait 'luaeval("package.loaded[\"which-key\"] ~= nil")'
#   scripts/repro.sh keys '<Space>' 1 sg 2 && scripts/repro.sh expr '&filetype'   # TelescopePrompt
#   scripts/repro.sh stop
#
# Note: nvim writes to ~/.cache/nvim and ~/.local/state/nvim, so run outside the Claude Code sandbox.

set -euo pipefail

CONFIG_DIR="$(cd "$(dirname "$0")/.." && pwd)"
REPRO_DIR="/tmp/nvim-repro"
SOCK="$REPRO_DIR/nvim.sock"
FIXTURE="$REPRO_DIR/fixture"

remote() { nvim --server "$SOCK" "$@"; }

make_fixture() {
  mkdir -p "$FIXTURE/src"
  echo '{ "name": "fixture", "private": true }' >"$FIXTURE/package.json"
  echo '{ "compilerOptions": { "jsx": "react-jsx", "strict": true } }' >"$FIXTURE/tsconfig.json"
  cat >"$FIXTURE/src/app.tsx" <<'EOF'
const count: number = "wrong type";

export const App = () => (
  <div>
    <span>{count}</span>
  </div>
);
EOF
}

cmd_start() {
  cmd_stop >/dev/null 2>&1 || true
  mkdir -p "$REPRO_DIR"
  local file="${1:-}"
  if [[ -z "$file" ]]; then
    make_fixture
    file="$FIXTURE/src/app.tsx"
  fi
  file="$(cd "$(dirname "$file")" && pwd)/$(basename "$file")"
  # `script` gives nvim a real pty so UIEnter/VeryLazy fire like in a terminal
  (cd "$(dirname "$file")" && script -q /dev/null nvim --listen "$SOCK" "$file" </dev/null >/dev/null 2>&1 &)
  for _ in $(seq 1 50); do
    [[ -S "$SOCK" ]] && remote --remote-expr 1 >/dev/null 2>&1 && { echo "started: $file"; return; }
    sleep 0.2
  done
  echo "nvim did not start (socket $SOCK)" >&2
  exit 1
}

cmd_wait() {
  local expr="$1" timeout="${2:-15}" start=$SECONDS
  while ((SECONDS - start < timeout)); do
    case "$(remote --remote-expr "$expr" 2>/dev/null)" in 1 | v:true | true) echo "ok: $expr"; return ;; esac
    sleep 0.3
  done
  echo "timeout after ${timeout}s: $expr" >&2
  exit 1
}

cmd_keys() {
  for k in "$@"; do
    if [[ "$k" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then sleep "$k"; else remote --remote-send "$k"; fi
  done
}

cmd_stop() {
  [[ -S "$SOCK" ]] && remote --remote-send '<C-\><C-n>:qa!<CR>' 2>/dev/null || true
  sleep 0.5
  rm -f "$SOCK"
}

cmd_live() {
  local expr="${1:-}" config_mtime=0 m
  while IFS= read -r f; do
    m=$(stat -f %m "$f")
    ((m > config_mtime)) && config_mtime=$m
  done < <(find "$CONFIG_DIR/init.lua" "$CONFIG_DIR/lua" -name '*.lua')

  local dirs=("$(getconf DARWIN_USER_TEMP_DIR 2>/dev/null || echo "${TMPDIR:-/tmp}")")
  [[ -n "${XDG_RUNTIME_DIR:-}" ]] && dirs+=("$XDG_RUNTIME_DIR")
  local found=0
  while IFS= read -r s; do
    found=1
    local pid cwd started status
    pid=$(nvim --server "$s" --remote-expr 'getpid()' 2>/dev/null) || continue
    cwd=$(nvim --server "$s" --remote-expr 'getcwd()' 2>/dev/null)
    started=$(LC_ALL=C date -j -f "%a %b %d %T %Y" "$(LC_ALL=C ps -o lstart= -p "$pid" | xargs)" +%s 2>/dev/null || echo 0)
    status="up-to-date"
    ((started < config_mtime)) && status="STALE (restart nvim to load config changes)"
    echo "pid=$pid  cwd=$cwd  $status"
    echo "  socket=$s"
    [[ -n "$expr" ]] && echo "  $expr => $(nvim --server "$s" --remote-expr "$expr" 2>&1)"
  done < <(find "${dirs[@]}" -maxdepth 3 -type s -name 'nvim.*' 2>/dev/null)
  ((found)) || echo "no running nvim sessions found"
}

case "${1:-}" in
  start) shift; cmd_start "$@" ;;
  wait) shift; cmd_wait "$@" ;;
  keys) shift; cmd_keys "$@" ;;
  expr) shift; remote --remote-expr "$1" ;;
  lua) shift; remote --remote-expr "luaeval('${1//\'/\'\'}')" ;;
  stop) cmd_stop ;;
  live) shift; cmd_live "$@" ;;
  *) sed -n '2,19p' "$0" | sed 's/^# \{0,1\}//'; exit 1 ;;
esac
