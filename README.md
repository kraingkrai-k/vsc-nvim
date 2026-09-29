# Neovim Configuration (LazyVim Standard)

Minimal Neovim config with **LazyVim-standard keymaps**, designed for VS Code + Neovim extension with standalone Neovim support.

## Quick Start

### Prerequisites

```bash
# Neovim 0.12+
brew install neovim

# C compiler + make (treesitter parsers, telescope-fzf-native)
xcode-select --install

# Standalone: ripgrep/fd (Telescope), tree-sitter CLI 0.26.1+ (parsers), lazygit (<leader>gg)
brew install ripgrep fd tree-sitter-cli lazygit

# Node.js — Mason installs vtsls / eslint via npm
brew install node   # or nvm

# Nerd Font (for standalone icons)
brew install font-jetbrains-mono-nerd-font

# Optional: mermaid diagrams in markdown (snacks.image, needs a Kitty-graphics terminal e.g. Ghostty/Kitty/WezTerm)
npm install -g @mermaid-js/mermaid-cli && brew install imagemagick
```

### Upgrading from Neovim 0.11

```bash
brew upgrade neovim
brew install tree-sitter-cli              # the `tree-sitter` formula no longer ships the CLI
rm -rf ~/.local/share/nvim/lazy/nvim-treesitter   # old master-branch parsers (incompatible ABI)
nvim "+Lazy! sync" +qa                    # re-clone on main branch; parsers install on next start
```

Then check `:checkhealth nvim-treesitter` and `:checkhealth vim.deprecated`.

### Installation

```bash
# Backup existing config
mv ~/.config/nvim ~/.config/nvim.backup

# Clone
git clone https://github.com/kraingkrai-k/vsc-nvim.git ~/.config/nvim

# Open Neovim to auto-install plugins
nvim
```

### VS Code Setup

1. Install [VSCode Neovim](https://marketplace.visualstudio.com/items?itemName=asvetliakov.vscode-neovim)
2. Copy settings from `vscode-settings-recommended.json` to your VS Code `settings.json`

## Structure

```
lua/config/options.lua      Vim options
lua/config/keymaps.lua      Core keymaps (env-specific)
lua/plugins/common.lua      Shared plugins (4)
lua/plugins/vscode.lua      VS Code keymaps
lua/plugins/standalone.lua  Standalone UI + LSP (23)
```

## Plugins

### Common (both environments) - 4 plugins

| Plugin | Keys |
|--------|------|
| mini.surround | `gsa` add, `gsd` delete, `gsr` replace |
| mini.pairs | auto `()[]{}""` |
| flash.nvim | `s` jump, `S` treesitter select |
| nvim-spider | `<A-w>/<A-e>/<A-b>` camelCase-aware |

### Standalone only - 23 plugins

tokyonight, lualine, bufferline, nvim-tree, telescope (+fzf-native), gitsigns, which-key, lazygit, nvim-lspconfig, mason, mason-lspconfig, render-markdown, snacks, nvim-treesitter (`main` branch), nvim-treesitter-textobjects, mini.ai, nvim-ts-autotag (JSX tags), ts-comments (JSX `{/* */}`), blink.cmp (completion), conform (prettier from project `node_modules`), grug-far (search & replace), trouble (diagnostics list), neotest + neotest-vitest (Vitest runner)

Format on save runs prettier only in projects with a prettier config (`.prettierrc*` or `"prettier"` in `package.json`).

## Keymaps

Leader: `<Space>`

### File & Buffer

| Key | Action |
|-----|--------|
| `<C-s>` | Save (all modes) |
| `<leader>bd` | Delete buffer |
| `[b` / `]b` | Prev/Next buffer (native in standalone) |
| `<S-h>` / `<S-l>` | Prev/Next buffer (standalone) |
| `<leader>bo` | Delete other buffers (standalone) |
| `<leader>qq` | Quit all (standalone) |

### Window

| Key | Action |
|-----|--------|
| `<leader>\|` | Split vertical |
| `<leader>-` | Split horizontal |
| `<leader>wd` | Close window |
| `<C-h/j/k/l>` | Navigate windows |

### Find & Search

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fr` | Recent files |
| `<leader>e` | File explorer |
| `<leader>/` / `<leader>sg` | Grep (standalone) |
| `<leader>sw` | Grep word under cursor / selection (standalone) |
| `<leader>sR` | Resume last search (standalone) |
| `<leader>ss` | Symbols in file (standalone) |
| `<leader>sS` | Symbols in project |
| `<leader>sr` | Search & replace in project — grug-far (standalone) |

### LSP

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | References (Telescope) |
| `gI` | Go to implementation |
| `gy` | Type definition |
| `K` | Hover (native) |
| `<leader>cr` | Rename |
| `<leader>ca` | Code action |
| `<leader>cd` | Line diagnostics |
| `<leader>cf` | Format (prettier, fallback LSP) |
| `<leader>co` | Organize imports (vtsls) |
| `<leader>cM` | Add missing imports (vtsls) |
| `<leader>cu` | Remove unused imports (vtsls) |
| `]d` / `[d` | Next/Prev diagnostic |
| `<leader>xx` / `<leader>xX` | Diagnostics project / buffer — Trouble (standalone) |
| `<leader>xQ` / `<leader>xL` | Quickfix / location list — Trouble (standalone) |
| `<leader>cs` / `<leader>cS` | Symbols / LSP refs — Trouble (standalone) |

### Git

| Key | Action |
|-----|--------|
| `<leader>gg` | LazyGit / SCM |
| `<leader>gd` | Git diff |
| `<leader>gb` | Git blame |
| `]h` / `[h` | Next/Prev hunk |
| `<leader>ghs` | Stage hunk |
| `<leader>ghr` | Reset hunk |
| `<leader>ghp` | Preview hunk |
| `<leader>ghb` / `<leader>ghB` | Blame line / buffer (standalone) |
| `ih` | Hunk text object (standalone) |

### Test (standalone, Vitest via neotest)

| Key | Action |
|-----|--------|
| `<leader>tt` | Run file |
| `<leader>tr` | Run nearest |
| `<leader>tT` | Run all test files |
| `<leader>tl` | Run last |
| `<leader>ts` | Toggle summary |
| `<leader>to` / `<leader>tO` | Output / output panel |
| `<leader>tw` | Toggle watch |
| `<leader>tS` | Stop |

### Editing

| Key | Action |
|-----|--------|
| `gcc` | Toggle line comment (native) |
| `gc` | Toggle comment (visual, native) |
| `gsa{motion}{char}` | Add surround |
| `gsd{char}` | Delete surround |
| `gsr{old}{new}` | Replace surround |
| `s` + 2 chars | Flash jump |
| `S` | Flash treesitter |
| `<A-w>/<A-e>/<A-b>` | camelCase-aware word movement |
| `%` | Go to matching bracket (native) |
| `Y` | Yank to end of line (native) |
| `P` (visual) | Paste without overwriting register (native) |
| `<A-j>` / `<A-k>` | Move lines (standalone) |
| `n` / `N` | Always forward / backward search (standalone) |
| `af`/`if`, `ac`/`ic`, `aa`/`ia`, `at`/`it`, `ao`/`io`, `au`/`iu` | Function, class, argument, tag, block, call text objects — mini.ai (standalone) |
| `]f`/`[f`, `]c`/`[c`, `]a`/`[a` | Next/Prev function, class, argument — treesitter-textobjects (standalone) |

### VS Code Only

| Key | Action |
|-----|--------|
| `<leader>fp` | Projects |
| `<leader>z` | Zen mode |
| `gp` | Peek definition |
| `<leader><leader>` | Toggle recent file |
| `<leader>o` | Go to symbol (file) |

### Useful Vim Built-ins

```
u / <C-r>           Undo / Redo
<C-o> / <C-i>       Jump back / forward
g; / g,             Prev / Next edit position
``                  Last jump position
'.                  Last edit position
f/F{char}           Find char forward/backward
* / #               Search word under cursor
```

## Troubleshooting

```vim
:Lazy               " Plugin manager
:Lazy sync          " Update plugins
:checkhealth        " Health diagnostics
```

Reproduce issues in a real pty (headless skips `VeryLazy`, so which-key etc. never load):

```bash
scripts/repro.sh live                   # running sessions; STALE = restart nvim to pick up config changes
scripts/repro.sh start && scripts/repro.sh keys '<Space>' 1 sg 2 && scripts/repro.sh expr '&filetype'
scripts/repro.sh stop                   # see header of scripts/repro.sh for all commands
```

Clear cache if needed:

```bash
rm -rf ~/.local/share/nvim/
rm -rf ~/.cache/nvim/
```

## LSP Servers (auto-installed via Mason)

- TypeScript/JavaScript (`vtsls`)
- ESLint (`eslint`, attaches only in projects with an eslint config)
- Go (`gopls`)
- Lua (`lua_ls`)
