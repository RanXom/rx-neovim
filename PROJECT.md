# rx-neovim

Personal Neovim configuration, evolved from [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim).

## Architecture

```text
.
├── init.lua                      -- Bootstrap: loads modules in order
│
├── lua/
│   ├── core/
│   │   ├── options.lua           -- Editor options (vim.opt, vim.o)
│   │   ├── keymaps.lua           -- Global keymaps and diagnostics
│   │   ├── autocmds.lua          -- General autocommands
│   │   ├── plugin-events.lua     -- vim.pack build hooks (PackChanged)
│   │   └── utils.lua             -- Shared helpers (gh, etc.)
│   │
│   ├── plugins/
│   │   ├── ui.lua                -- UI plugins (which-key, gitsigns, mini, colorscheme)
│   │   ├── telescope.lua         -- Telescope setup and keymaps
│   │   ├── lsp.lua               -- LSP servers, Mason, keymaps
│   │   ├── formatting.lua        -- conform.nvim
│   │   ├── completion.lua        -- blink.cmp + LuaSnip
│   │   └── treesitter.lua        -- Treesitter parsers and highlighting
│   │
│   ├── integrations/
│   │   └── matugen.lua           -- Matugen dynamic colorscheme (auto-generated, gitignored)
│   │
│   ├── kickstart/
│   │   ├── health.lua
│   │   └── plugins/              -- Optional kickstart modules
│   │
│   └── custom/
│       └── plugins/
│           └── init.lua          -- Legacy kickstart extension point
│
├── doc/
├── PROJECT.md
├── README.md
├── LICENSE.md
└── .stylua.toml
```

## Package Management

Uses native `vim.pack.add {}` — no Lazy.nvim.

## Key Integrations

- **Matugen**: Dynamic base16 colorscheme via SIGUSR1 signal reload.
  The file `lua/integrations/matugen.lua` is auto-generated and gitignored.
