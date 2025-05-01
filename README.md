## Get Start

```
$ git clone https://github.com/kraingkrai-k/vsc-nvim.git ~/.config/nvim

## update zsh
$ export MYVIMRC=~/.config/nvim/init.lua
$ source $MYVIMRC

```

## install

```
$ brew install neovim
$ Neovim Extension In VS Code
$ sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
   https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

```

### Nerde Font

```
$ brew install font-jetbrains-mono-nerd-font
```

### set up macOS

- update keyboard setting to use cap instead of ESC
  > - defaults write -g InitKeyRepeat -int 10
  > - defaults write -g KeyRepeat -int 1
  > - defaults write -g ApplePressAndHoldEnabled -bool false
  > - setting/modifier key/keyboard shortcut
  >   - cap lock key -> escape
  > - restart mac

### vs-code keyboard

- cmd + ,
  > keyboard.dispatch -> keyCode

# settings.json

```json
  "workbench.colorCustomizations": {
    "list.activeSelectionBackground": "#4c4c4c", // Darker background color for selected item
    "list.activeSelectionForeground": "#ffffff", // White or lighter text color for selected item
    "list.inactiveSelectionBackground": "#3a3a3a", // Background for inactive selection (not focused)
    "list.inactiveSelectionForeground": "#ffffff", // Text color for inactive selection
    "list.hoverBackground": "#505050", // Background color when hovering over items
    "list.hoverForeground": "#ffffff", // Text color when hovering over items
    "list.activeSelectionBorder": "#5f9ea0", // Border color for active selection (e.g., a teal border)
    "list.hoverBorder": "#5f9ea0", // Border color when hovering over items
    "terminalCursor.foreground": "#1bb66e",
    "editorCursor.foreground": "#E5C07B"
  },
  "extensions.experimental.affinity": {
      "asvetliakov.vscode-neovim": 1
  },
  "vscode-neovim.neovimExecutablePaths.darwin": "/opt/homebrew/bin/nvim",
  "vscode-neovim.neovimInitVimPaths.darwin": "$HOME/.config/nvim/init.lua",
  "editor.cursorSmoothCaretAnimation": "on",
  "zenMode.centerLayout": false,
  "zenMode.hideLineNumbers": false,
```

### Fonts optional

```json
{
  "terminal.integrated.fontFamily": "JetBrainsMono Nerd Font",
  "editor.fontFamily": "JetBrainsMono Nerd Font, 'Monaspace Neon', monospace",
  "editor.fontLigatures": true,
  "editor.fontSize": 14,
  "editor.lineHeight": 19
}
```

### Troubleshoot

```
# clear cache
$ rm -rf ~/.local/share/nvim/site
```
