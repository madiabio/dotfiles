-- 1. Reuse your ~/.vimrc so you keep all old settings
vim.cmd("source " .. vim.fn.expand("~/.vimrc"))


-- 3. Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git","clone","--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


-- 3. Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git","clone","--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


-- 4. Plugins
require("lazy").setup({
  -- Treesitter for highlighting
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- LSP support
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim" },            -- installer for language servers
  { "williamboman/mason-lspconfig.nvim" },  -- bridges mason + lspconfig

  -- Autocompletion
  { "hrsh7th/nvim-cmp" },           -- completion engine
  { "hrsh7th/cmp-nvim-lsp" },       -- LSP source for nvim-cmp
  { "L3MON4D3/LuaSnip" },           -- snippet engine
  { "saadparwaiz1/cmp_luasnip" },   -- snippet completions
})

-- 5. Treesitter config
require("nvim-treesitter.configs").setup({
  ensure_installed = { "python", "lua", "vim", "bash", "json", "markdown" },
  highlight = { enable = true },
  indent = { enable = true },
})

-- 6. Mason (server manager) + LSP setup
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "pyright" },  -- Python LSP
  automatic_installation = true,
})

-- LSP attach: keymaps
local on_attach = function(_, bufnr)
  local map = function(mode, lhs, rhs)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr })
  end
  map("n", "gd", vim.lsp.buf.definition)
  map("n", "gr", vim.lsp.buf.references)
  map("n", "K", vim.lsp.buf.hover)
  map("n", "<leader>rn", vim.lsp.buf.rename)
  map("n", "<leader>ca", vim.lsp.buf.code_action)
  map("n", "[d", vim.diagnostic.goto_prev)
  map("n", "]d", vim.diagnostic.goto_next)
end

-- Configure Python LSP (pyright)
require("lspconfig").pyright.setup({
  on_attach = on_attach,
})

-- 7. Autocomplete setup
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args) require("luasnip").lsp_expand(args.body) end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
  }),
})
