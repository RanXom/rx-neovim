# rx-neovim

Personal Neovim configuration evolved from [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim).

## Overview

Provides a modular Neovim environment using native package management (`vim.pack.add`). Core capabilities include a unified statusline, LSP integration, and rich markdown rendering.

### Integrations

*   **[rx-tmux](https://github.com/RanXom/rx-tmux)**: Optionally pairs with rx-tmux for a terminal multiplexer workflow.
*   **Noctalia (Matugen)**: Requires Noctalia v5 (or Matugen) to generate base16 colors dynamically. Colors can alternatively be hardcoded in the UI configuration.

## Features & Plugins

Leverages Neovim's native `vim.pack.add` for package management, avoiding external package managers like lazy.nvim while maintaining a modular structure.

### Core Plugins
*   **Telescope**: Fuzzy finder for files, LSP references, diagnostics, and help tags.
*   **blink.cmp & LuaSnip**: Autocompletion engine and snippet support.
*   **nvim-lspconfig, Mason & conform.nvim**: Automated LSP installation, configuration, and format-on-save.
*   **nvim-treesitter**: Syntax highlighting, indentation, and folding.
*   **nvim-autopairs**: Automatic bracket pairing and `<CR>` formatting.

### UI & Aesthetics
*   **mini.nvim (statusline)**: Single-line UI. The command line (`:`) and confirm prompts are injected into the statusline.
*   **snacks.nvim**: Dashboard and unified notification system.
*   **which-key.nvim**: Displays available keybindings as you type.
*   **gitsigns.nvim**: Git integration within the sign column.

### Markdown & Note-taking
*   **obsidian.nvim**: Integration with Obsidian vaults for note-taking.
*   **render-markdown.nvim**: Concealed markdown display within the buffer.
*   **image.nvim**: Inline image rendering using the Kitty graphics protocol.
*   **render-latex.nvim**: Renders display math blocks as images.

## Architecture

The configuration is modular to keep concerns separated:

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

To search for documentation or keybindings:
*   Press `<leader>sh` (Search Help) to open Telescope and search through all Neovim help tags.
*   Press `<leader>sk` (Search Keymaps) to search active keybindings.
*   Press `<leader>` and wait; `which-key.nvim` will display available keymap groups.

### Custom Mappings
*   **Splits**: `<leader>-` for horizontal split, `<leader>|` for vertical split.
*   **LSP Navigation**: `grd` (definition), `grr` (references), `gri` (implementation), `grt` (type definition).
*   **Visual Indentation**: `<` and `>` in visual mode retain selection for repeated indenting.

## Acknowledgements

Built upon [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim), modified to use native package management and a custom UI.
