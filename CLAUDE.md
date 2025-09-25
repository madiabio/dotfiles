# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository containing Vim and Neovim configurations. The structure is:

- `vimrc` - Minimal Vim configuration with basic settings and filetype-specific indentation
- `nvim/init.lua` - Neovim configuration using lazy.nvim plugin manager
- `nvim/lazy-lock.json` - Plugin version lockfile for lazy.nvim

## Architecture

### Vim Configuration (`vimrc`)
- Minimal setup focused on syntax highlighting and basic UI improvements
- Filetype-specific indentation rules (2 spaces for web languages, 4 for Python)
- System clipboard integration and persistent undo
- Python virtual environment detection for Neovim

### Neovim Configuration (`nvim/init.lua`)
- Uses lazy.nvim as plugin manager for lazy loading
- LSP setup with Mason for automatic language server installation
- Configured language servers: Pyright (Python), lua_ls (Lua), ts_ls (TypeScript/JavaScript)
- Auto-completion with nvim-cmp and LuaSnip
- Automatic indentation detection with indent-o-matic plugin
- Inline diagnostic messages enabled

## Key Plugin Stack
- **lazy.nvim**: Plugin manager with lazy loading
- **Mason**: LSP server installer and manager
- **nvim-lspconfig**: LSP client configurations
- **nvim-cmp**: Completion engine with LSP integration
- **indent-o-matic**: Automatic indentation detection (max 200 lines analyzed)
- **claudecode.nvim**: Official Claude Code integration for seamless AI assistance

## Claude Code Integration

Official Claude Code integration via claudecode.nvim with key mappings:
- `<leader>cc` - Open Claude Code interface
- `<leader>cs` - Send selection to Claude (visual mode)
- `<leader>cf` - Send current file to Claude

**Requirements**:
- Claude Code CLI (v1.0.124+ installed)
- Authenticated Claude Code session (uses same auth as web interface)
- No API key needed - uses Claude Code's authentication system

## Development

No build commands or scripts are present - this is a configuration-only repository. Changes to Neovim configuration require restarting Neovim or running `:source %` to reload.

The Mason plugin will automatically install language servers (pyright, lua_ls, ts_ls) on first run if they're not present.