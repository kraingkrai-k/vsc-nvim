-- Platform detection utilities for cross-platform compatibility
local M = {}

-- Detect the current operating system
function M.detect_os()
  local os_name = vim.loop.os_uname().sysname
  
  if os_name == "Darwin" then
    return "macos"
  elseif os_name == "Linux" then
    return "linux"
  elseif os_name:match("Windows") then
    return "windows"
  else
    return "unknown"
  end
end

-- Check if running on macOS
function M.is_macos()
  return M.detect_os() == "macos"
end

-- Check if running on Linux
function M.is_linux()
  return M.detect_os() == "linux"
end

-- Check if running on Windows
function M.is_windows()
  return M.detect_os() == "windows"
end

-- Get platform-specific path separator
function M.get_path_separator()
  if M.is_windows() then
    return "\\"
  else
    return "/"
  end
end

-- Get platform-specific home directory
function M.get_home_dir()
  if M.is_windows() then
    return os.getenv("USERPROFILE") or os.getenv("HOME")
  else
    return os.getenv("HOME")
  end
end

-- Get platform-specific config directory
function M.get_config_dir()
  if M.is_windows() then
    return vim.fn.stdpath("config")
  elseif M.is_macos() then
    return vim.fn.stdpath("config")
  else -- Linux
    return vim.fn.stdpath("config")
  end
end

-- Get platform-specific data directory
function M.get_data_dir()
  return vim.fn.stdpath("data")
end

-- Get platform-specific cache directory
function M.get_cache_dir()
  return vim.fn.stdpath("cache")
end

-- Get platform-specific executable extension
function M.get_executable_extension()
  if M.is_windows() then
    return ".exe"
  else
    return ""
  end
end

-- Check if a command exists on the system
function M.has_command(cmd)
  local handle = io.popen(string.format("command -v %s 2>/dev/null", cmd))
  if handle then
    local result = handle:read("*a")
    handle:close()
    return result ~= ""
  end
  return false
end

-- Get platform-specific shell
function M.get_shell()
  if M.is_windows() then
    return os.getenv("COMSPEC") or "cmd.exe"
  else
    return os.getenv("SHELL") or "/bin/sh"
  end
end

-- Get platform-specific terminal
function M.get_terminal()
  if M.is_macos() then
    return "Terminal.app"
  elseif M.is_linux() then
    -- Try to detect common terminals
    local terminals = { "gnome-terminal", "konsole", "xterm", "alacritty", "kitty" }
    for _, term in ipairs(terminals) do
      if M.has_command(term) then
        return term
      end
    end
    return "xterm"
  elseif M.is_windows() then
    return "cmd.exe"
  end
  return "unknown"
end

-- Get platform-specific font directories
function M.get_font_dirs()
  if M.is_macos() then
    return {
      "/System/Library/Fonts",
      "/Library/Fonts",
      M.get_home_dir() .. "/Library/Fonts"
    }
  elseif M.is_linux() then
    return {
      "/usr/share/fonts",
      "/usr/local/share/fonts",
      M.get_home_dir() .. "/.fonts",
      M.get_home_dir() .. "/.local/share/fonts"
    }
  elseif M.is_windows() then
    return {
      "C:\\Windows\\Fonts",
      os.getenv("LOCALAPPDATA") .. "\\Microsoft\\Windows\\Fonts"
    }
  end
  return {}
end

-- Get platform-specific clipboard command
function M.get_clipboard_cmd()
  if M.is_macos() then
    return {
      copy = "pbcopy",
      paste = "pbpaste"
    }
  elseif M.is_linux() then
    if M.has_command("xclip") then
      return {
        copy = "xclip -selection clipboard",
        paste = "xclip -selection clipboard -o"
      }
    elseif M.has_command("xsel") then
      return {
        copy = "xsel --clipboard --input",
        paste = "xsel --clipboard --output"
      }
    end
  elseif M.is_windows() then
    return {
      copy = "clip",
      paste = "powershell Get-Clipboard"
    }
  end
  return nil
end

-- Get platform-specific key modifiers
function M.get_key_modifiers()
  if M.is_macos() then
    return {
      cmd = "D",      -- Command key
      opt = "A",      -- Option/Alt key
      ctrl = "C",     -- Control key
      shift = "S"     -- Shift key
    }
  else
    return {
      cmd = "C",      -- Control key (maps to Cmd on other platforms)
      opt = "A",      -- Alt key
      ctrl = "C",     -- Control key
      shift = "S"     -- Shift key
    }
  end
end

-- Get platform-specific default applications
function M.get_default_apps()
  if M.is_macos() then
    return {
      browser = "open",
      file_manager = "open",
      terminal = "open -a Terminal"
    }
  elseif M.is_linux() then
    return {
      browser = "xdg-open",
      file_manager = "xdg-open",
      terminal = M.get_terminal()
    }
  elseif M.is_windows() then
    return {
      browser = "start",
      file_manager = "explorer",
      terminal = "cmd"
    }
  end
  return {}
end

-- Check if running in WSL (Windows Subsystem for Linux)
function M.is_wsl()
  if not M.is_linux() then
    return false
  end
  
  local handle = io.popen("uname -r 2>/dev/null")
  if handle then
    local result = handle:read("*a")
    handle:close()
    return result:lower():match("microsoft") ~= nil
  end
  return false
end

-- Get environment-specific information
function M.get_env_info()
  return {
    os = M.detect_os(),
    is_wsl = M.is_wsl(),
    shell = M.get_shell(),
    terminal = M.get_terminal(),
    home_dir = M.get_home_dir(),
    config_dir = M.get_config_dir(),
    data_dir = M.get_data_dir(),
    cache_dir = M.get_cache_dir(),
    path_separator = M.get_path_separator(),
    executable_extension = M.get_executable_extension(),
    clipboard = M.get_clipboard_cmd(),
    key_modifiers = M.get_key_modifiers(),
    default_apps = M.get_default_apps()
  }
end

return M