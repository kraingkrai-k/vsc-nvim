# Neovim Configuration (LazyVim Standard)

Minimal Neovim config with **LazyVim-standard keymaps**, designed for VS Code + Neovim extension with standalone Neovim support.

## Quick Start

### Prerequisites

```bash
# Neovim 0.10+
brew install neovim

# Nerd Font (for standalone icons)
brew install font-jetbrains-mono-nerd-font
```

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
lua/plugins/common.lua      Shared plugins (5)
lua/plugins/vscode.lua      VS Code keymaps
lua/plugins/standalone.lua  Standalone UI + LSP (11)
```

## Plugins

### Common (both environments) - 5 plugins

| Plugin | Keys |
|--------|------|
| mini.surround | `gsa` add, `gsd` delete, `gsr` replace |
| mini.comment | `gcc` line, `gc` visual |
| mini.pairs | auto `()[]{}""` |
| flash.nvim | `s` jump, `S` treesitter select |
| nvim-spider | `w/e/b` camelCase-aware |

### Standalone only - 11 plugins

tokyonight, lualine, bufferline, nvim-tree, telescope, gitsigns, which-key, lazygit, nvim-lspconfig, mason, mason-lspconfig

## Keymaps

Leader: `<Space>`

### File & Buffer

| Key | Action |
|-----|--------|
| `<leader>w` | Save |
| `<leader>q` | Close/Quit |
| `<C-s>` | Save (all modes) |
| `<leader>bd` | Delete buffer |
| `[b` / `]b` | Prev/Next buffer |
| `<S-h>` / `<S-l>` | Prev/Next buffer (standalone) |

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

### LSP

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | References |
| `gI` | Go to implementation |
| `gy` | Type definition |
| `K` | Hover |
| `<leader>cr` | Rename |
| `<leader>ca` | Code action |
| `<leader>cd` | Line diagnostics |
| `<leader>cf` | Format |
| `]d` / `[d` | Next/Prev diagnostic |

### Git

| Key | Action |
|-----|--------|
| `<leader>gg` | LazyGit / SCM |
| `<leader>gd` | Git diff |
| `<leader>gb` | Git blame |
| `]c` / `[c` | Next/Prev hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hp` | Preview hunk |

### Editing

| Key | Action |
|-----|--------|
| `gcc` | Toggle line comment |
| `gc` | Toggle comment (visual) |
| `gsa{motion}{char}` | Add surround |
| `gsd{char}` | Delete surround |
| `gsr{old}{new}` | Replace surround |
| `s` + 2 chars | Flash jump |
| `S` | Flash treesitter |
| `w/e/b` | Smart word movement |
| `gm` | Go to matching bracket |
| `Y` | Yank to end of line |
| `<leader>p` | Paste without overwriting register |
| `<A-j>` / `<A-k>` | Move lines (standalone) |

### VS Code Only

| Key | Action |
|-----|--------|
| `<leader>fp` | Projects |
| `<leader>z` | Zen mode |
| `gp` | Peek definition |
| `<leader><leader>` | Toggle recent file |
| `<leader>o` | Go to symbol |

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

Clear cache if needed:

```bash
rm -rf ~/.local/share/nvim/
rm -rf ~/.cache/nvim/
```

## LSP Servers (auto-installed via Mason)

- TypeScript/JavaScript (`ts_ls`)
- Go (`gopls`)
- Lua (`lua_ls`)
