# 🚀 Modern Neovim Configuration

A powerful, environment-aware Neovim configuration that works seamlessly across **Standalone Neovim**, **VS Code**, and **Kiro IDE**. Built with performance, productivity, and modern development workflows in mind.

## ✨ Features

- 🎯 **Environment-Aware**: Automatically adapts to VS Code, Kiro, or standalone Neovim
- ⚡ **Performance Optimized**: Fast startup with lazy loading and environment-specific optimizations
- 🔧 **Modern Tooling**: LSP, Treesitter, Telescope, and more
- 🎨 **Beautiful UI**: Catppuccin theme with consistent styling across environments
- 🔄 **Smart Fallbacks**: Graceful degradation when features aren't available
- 📱 **Cross-Platform**: Works on macOS, Linux, and Windows

## 🚀 Quick Start

### Prerequisites

```bash
# Install Neovim (0.8+ required)
brew install neovim  # macOS
# or
sudo apt install neovim  # Ubuntu/Debian
# or
winget install Neovim.Neovim  # Windows

# Install a Nerd Font (recommended)
brew install font-jetbrains-mono-nerd-font  # macOS
```

### Installation

```bash
# Backup existing config (if any)
mv ~/.config/nvim ~/.config/nvim.backup

# Clone this configuration
git clone https://github.com/kraingkrai-k/vsc-nvim.git ~/.config/nvim

# Start Neovim - plugins will install automatically
nvim
```

### Environment Setup

#### For VS Code Users

1. Install the [VSCode Neovim extension](https://marketplace.visualstudio.com/items?itemName=asvetliakov.vscode-neovim)

2. Add to your VS Code `settings.json`:

```json
{
  "extensions.experimental.affinity": {
    "asvetliakov.vscode-neovim": 1
  },
  "vscode-neovim.neovimExecutablePaths.darwin": "/opt/homebrew/bin/nvim",
  "vscode-neovim.neovimInitVimPaths.darwin": "$HOME/.config/nvim/init.lua",
  "editor.cursorSmoothCaretAnimation": "on",
  "keyboard.dispatch": "keyCode"
}
```

#### For Kiro IDE Users

The configuration automatically detects Kiro and loads enhanced features for AI-powered development workflows.

#### For Standalone Neovim

No additional setup required! The full feature set is available out of the box.

## 📋 Cheat Sheet

### Universal Keybindings (All Environments)

| Key          | Action            | Description                      |
| ------------ | ----------------- | -------------------------------- |
| `<Space>`    | Leader key        | Primary leader for most commands |
| `<Esc><Esc>` | Clear search      | Clear search highlighting        |
| `H`          | Beginning of line | Go to start of line              |
| `L`          | End of line       | Go to end of line                |
| `U`          | Redo              | Redo last undone change          |
| `Y`          | Yank to end       | Yank from cursor to end of line  |

### Navigation & Movement

| Key     | Action           | Description                    |
| ------- | ---------------- | ------------------------------ |
| `s`     | Flash jump       | Quick jump to any visible text |
| `S`     | Flash treesitter | Jump to code structures        |
| `gm`    | Matching bracket | Go to matching bracket         |
| `<C-j>` | Fast scroll down | Scroll 5 lines down            |
| `<C-k>` | Fast scroll up   | Scroll 5 lines up              |

### File Operations

| Key          | Action        | Environment                  |
| ------------ | ------------- | ---------------------------- |
| `<leader>w`  | Save file     | All                          |
| `<leader>q`  | Close/Quit    | All                          |
| `<leader>ff` | Find files    | All (Telescope/VS Code/Kiro) |
| `<leader>fg` | Find in files | All (Live grep/Search)       |

### Code Navigation & LSP

| Key          | Action                   | Environment |
| ------------ | ------------------------ | ----------- |
| `gd`         | Go to definition         | All         |
| `gr`         | Go to references         | All         |
| `K`          | Show hover/documentation | All         |
| `<leader>ca` | Code actions             | All         |
| `<leader>rn` | Rename symbol            | All         |
| `[d` / `]d`  | Previous/Next diagnostic | Standalone  |

### VS Code Specific

| Key          | Action             | Description                  |
| ------------ | ------------------ | ---------------------------- |
| `<leader>d`  | Multi-cursor next  | Add cursor to next match     |
| `<leader>a`  | Select all matches | Select all occurrences       |
| `<leader>/`  | Toggle comment     | Comment/uncomment lines      |
| `<leader>z`  | Zen mode           | Toggle distraction-free mode |
| `<leader>pp` | Project manager    | Open project manager         |

### Window Management (Standalone)

| Key              | Action            | Description                     |
| ---------------- | ----------------- | ------------------------------- |
| `<C-h/j/k/l>`    | Navigate windows  | Move between splits             |
| `<C-Up/Down>`    | Resize height     | Increase/decrease window height |
| `<C-Left/Right>` | Resize width      | Increase/decrease window width  |
| `<S-h/l>`        | Buffer navigation | Previous/next buffer            |

### Git Integration

| Key          | Action     | Environment     |
| ------------ | ---------- | --------------- |
| `<leader>gs` | Git status | All             |
| `<leader>gd` | Git diff   | All             |
| `<leader>gb` | Git blame  | All             |
| `<leader>gc` | Git commit | Kiro/Standalone |
| `<leader>gp` | Git push   | Kiro/Standalone |

### Kiro Specific

| Key          | Action             | Description             |
| ------------ | ------------------ | ----------------------- |
| `<leader>ai` | AI assistance      | Access Kiro AI features |
| `<leader>sp` | Specs directory    | Open specs folder       |
| `<leader>st` | Steering directory | Open steering folder    |
| `<leader>pk` | Kiro config        | Open .kiro directory    |
| `<leader>pm` | MCP config         | Edit MCP configuration  |

### Text Editing

| Key         | Action                | Description                        |
| ----------- | --------------------- | ---------------------------------- |
| `gcc`       | Comment line          | Toggle line comment                |
| `gc`        | Comment operator      | Comment with motion                |
| `<` / `>`   | Indent (visual)       | Indent and reselect                |
| `<leader>r` | Replace with register | Replace text with register         |
| `<leader>p` | Paste (no overwrite)  | Paste without overwriting register |

### Search & Replace

| Key          | Action              | Environment |
| ------------ | ------------------- | ----------- |
| `<leader>ss` | Search in files     | All         |
| `<leader>sr` | Replace in files    | All         |
| `/`          | Search forward      | All         |
| `?`          | Search backward     | All         |
| `n` / `N`    | Next/previous match | All         |

## 🔧 Configuration

### Environment Detection

The configuration automatically detects your environment:

- **VS Code**: `vim.g.vscode` is set
- **Kiro**: `vim.g.kiro` is set
- **Standalone**: Neither flag is set

### Plugin Loading

Plugins are loaded conditionally based on environment:

- **Universal**: Core Vim plugins (surround, repeat, etc.)
- **VS Code**: Minimal set with VS Code integration
- **Kiro**: Enhanced set with AI workflow support
- **Standalone**: Full feature set with LSP, Treesitter, etc.

### Performance Monitoring

Check startup performance and environment info:

```vim
:PluginEnvInfo        " Show environment information
:PluginHealthCheck    " Run health diagnostics
```

## 🎨 Customization

### Theme Configuration

The configuration uses Catppuccin theme by default. To change:

```lua
-- In lua/config/init.lua
_G.nvim_config.preferences.theme = "your-theme-name"
```

### Adding Custom Keybindings

```lua
-- In lua/config/keymaps.lua or your custom config
local keymap = vim.keymap.set

keymap("n", "<leader>custom", function()
  -- Your custom function
end, { desc = "Custom action" })
```

### Environment-Specific Plugins

```lua
-- In your plugin configuration
return {
  "your-plugin/name",
  enabled = function()
    return require("utils.plugin_loader").env.is_standalone
  end,
  config = function()
    -- Plugin configuration
  end,
}
```

## 🛠️ Troubleshooting

### Clear Plugin Cache

```bash
rm -rf ~/.local/share/nvim/
rm -rf ~/.cache/nvim/
```

### VS Code Integration Issues

1. Ensure VS Code Neovim extension is installed
2. Check Neovim path in VS Code settings
3. Verify `keyboard.dispatch` is set to `keyCode`

### Performance Issues

1. Check startup time: `:PluginEnvInfo`
2. Profile plugins: `:Lazy profile`
3. Disable unused plugins for your environment

### Font Issues

Install a Nerd Font for proper icon display:

```bash
# macOS
brew install font-jetbrains-mono-nerd-font

# Manual installation
# Download from: https://www.nerdfonts.com/
```

## 📚 Additional Resources

- [Neovim Documentation](https://neovim.io/doc/)
- [Lazy.nvim Plugin Manager](https://github.com/folke/lazy.nvim)
- [VS Code Neovim Extension](https://github.com/vscode-neovim/vscode-neovim)
- [Kiro IDE](https://kiro.ai/)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test across environments
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**Happy coding!** 🎉

> This configuration is designed to enhance your development experience across all environments. Press `<leader>h` in any environment to see available keybindings!
