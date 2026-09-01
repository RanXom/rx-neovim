# rx-neovim

A personal, highly customized Neovim configuration built for performance, modularity, and integration with modern terminal environments. This configuration was originally evolved from [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim).

## Overview

This setup is designed for developers who want a powerful, IDE-like experience within the terminal. It features a completely custom, unified statusline that absorbs the command line and notifications, rich markdown and image rendering, and a robust LSP configuration.

### Integrations

*   **rx-tmux**: This Neovim configuration is designed to be optionally paired with `rx-tmux` for a seamless terminal multiplexer and editor workflow.
*   **Noctalia (Matugen)**: The colorscheme is dynamically generated. It requires **Noctalia v5** (or Matugen) as a dependency to generate the base16 colors dynamically. If you prefer not to use Noctalia, you can easily hardcode your preferred colorscheme in the UI configuration.

## Features & Plugins

This configuration leverages Neovim's native `vim.pack.add` for package management—avoiding the overhead of external package managers like lazy.nvim while maintaining a modular structure.

### Core Plugins
*   **Telescope**: Extensible fuzzy finder for files, LSP references, diagnostics, and help tags.
*   **blink.cmp & LuaSnip**: Fast, lightweight autocompletion engine paired with robust snippet support.
*   **nvim-lspconfig, Mason & conform.nvim**: Automated LSP installation, configuration, and format-on-save mechanics.
*   **nvim-treesitter**: Advanced syntax highlighting, indentation, and folding.
*   **nvim-autopairs**: Automatic bracket pairing and intelligent `<CR>` formatting.

### UI & Aesthetics
*   **mini.nvim (statusline)**: A heavily customized, single-line UI. The command line (`:`) and confirm prompts are seamlessly injected into the statusline, while general messages are routed to a notification manager.
*   **snacks.nvim**: Provides a clean dashboard and a unified notification system.
*   **which-key.nvim**: Displays available keybindings as you type, aiding in discovery.
*   **gitsigns.nvim**: Unobtrusive git integration within the sign column.

### Markdown & Note-taking
*   **obsidian.nvim**: Full integration with Obsidian vaults for note-taking and knowledge management.
*   **render-markdown.nvim**: Rich, concealed markdown display within the buffer.
*   **image.nvim**: Inline image rendering using the Kitty graphics protocol.
*   **render-latex.nvim**: Renders display math blocks as high-fidelity images.

## Architecture

The configuration is strictly modular to keep concerns separated:

```text
.
├── init.lua                      -- Bootstrap: loads modules in order
│
├── lua/
│   ├── core/
│   │   ├── options.lua           -- Editor options (vim.opt, vim.o)
│   │   ├── keymaps.lua           -- Global keymaps and diagnostics
│   │   ├── autocmds.lua          -- General autocommands
│   │   └── plugin-events.lua     -- vim.pack build hooks (PackChanged)
│   │
│   ├── plugins/
│   │   ├── ui.lua                -- UI plugins (which-key, gitsigns, mini)
│   │   ├── telescope.lua         -- Telescope setup and keymaps
│   │   ├── lsp.lua               -- LSP servers, Mason, keymaps
│   │   ├── formatting.lua        -- conform.nvim
│   │   ├── completion.lua        -- blink.cmp + LuaSnip
│   │   ├── treesitter.lua        -- Treesitter parsers and highlighting
│   │   └── ...                   -- Modular plugin configs (markdown, image, etc.)
│   │
│   └── integrations/
│       └── matugen.lua           -- Matugen dynamic colorscheme (auto-generated)
```

## Getting Help & Keymaps

The configuration uses the `<Space>` key as the leader key (`<leader>`). 

If you are ever unsure of a keybinding or need to search for documentation:
*   Press `<leader>sh` (Search Help) to open Telescope and search through all available Neovim help tags.
*   Press `<leader>sk` (Search Keymaps) to search through all currently active keybindings.
*   Simply press `<leader>` and wait a moment; `which-key.nvim` will appear at the bottom of the screen to guide you through the available keymap groups.

### Notable Custom Mappings
*   **Splits**: `<leader>-` for horizontal split, `<leader>|` for vertical split.
*   **LSP Navigation**: `grd` (definition), `grr` (references), `gri` (implementation), `grt` (type definition).
*   **Visual Indentation**: `<` and `>` in visual mode persistently retain selection for repeated indenting.

## Acknowledgements

This configuration is built upon the incredible foundation provided by [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim). It has since been heavily modified to use native package management and a custom UI paradigm.
