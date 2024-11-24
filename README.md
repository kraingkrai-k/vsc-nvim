## clone repo
- git clone https://github.com/kraingkrai-k/vsc-nvim.git ~/.config/nvim 

## update zsh
- export MYVIMRC=~/.config/nvim/init.lua
- source $MYVIMRC

# settings.json
```
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
```

### Fonts
```
  "terminal.integrated.fontFamily": "monospace",
  "editor.fontFamily": "'Monaspace Neon', monospace",
  "editor.fontLigatures": "'calt', 'liga', 'ss01', 'ss02', 'ss03', 'ss04', 'ss05', 'ss06', 'ss07', 'ss08', 'ss09'",
  "editor.fontSize": 14,
  "editor.lineHeight": 19,
```

### Zenmode
```
    "zenMode.centerLayout": false,
    "zenMode.hideLineNumbers": false,
```

### set up macOS
- update keyboard setting to use cap instead of ESC
>
> - defaults write -g InitKeyRepeat -int 10
> - defaults write -g KeyRepeat -int 1
> - defaults write -g ApplePressAndHoldEnabled -bool false
> - setting/modifier key/keyboard shortcut
>     - cap lock key -> escape
>  - restart mac
>


### vs-code keyboard
- cmd + , 
  - keyboard.dispatch -> keyCode

### remove cache
- rm -rf ~/.local/share/nvim/site

### sheet
Key|Action|Meaning/Description
---|------|-------------------|
a|	Append|	Enters Insert mode after the cursor position (append text after cursor).
b|	Back|	Moves the cursor backward to the beginning of the previous word.
c|	Change|	Deletes text and enters Insert mode (change text).
d|	Delete|	Deletes text (delete text from cursor).
e|	End|	Moves the cursor to the end of the next word.
f|	Find|	Finds the next occurrence of a character in the current line.
g|	Go|	Used as a prefix for many commands (gg for beginning of file, gd for go to definition in code, etc.).
h|	Left|	Moves the cursor one character to the left.
i|	Insert|	Enters Insert mode at the cursor position (insert text at cursor).
j|	Down|	Moves the cursor one line down.
k|	Up|	Moves the cursor one line up.
l|	Right|	Moves the cursor one character to the right.
m|	Mark|	Sets a mark at the cursor’s current position (mark position).
n|	Next|	Moves to the next search result after searching.
o|	Open| Below	Opens a new line below the current line and enters Insert mode.
p|	Paste|	Pastes the most recent yanked or deleted text after the cursor position.
q|	Record|	Starts recording a macro. (q followed by a letter starts recording).
r|	Replace|	Replaces a single character at the cursor position.
s|	Substitute|	Deletes a character and enters Insert mode (substitute a character).
t|	Till|	Moves the cursor up to (but not including) the next occurrence of a character on the line.
u|	Undo|	Undoes the last change.
v|	Visual| Mode	Enters Visual mode to select text.
w|	Word|	Moves the cursor to the beginning of the next word.
x|	Delete| Char	Deletes a character under the cursor (x delete, similar to backspace).
y|	Yank|	Copies (yanks) text into a register (similar to copy in other editors).
z|	Scroll| & Fold	Related to scrolling and folds (e.g., zz centers the line, zO opens all folds).


