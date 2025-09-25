-- ===== Basic Options =====
vim.opt.number = true
vim.opt.signcolumn = "yes"
vim.opt.background = "dark"
vim.opt.termguicolors = false
vim.cmd([[
  filetype plugin on
  colorscheme desert
]])
vim.diagnostic.config({
  virtual_text = true,  -- show error messages inline
  signs = true,         -- show signs in the gutter
  underline = true,     -- underline problems
  update_in_insert = false,
})

-- ===== Bootstrap lazy.nvim =====
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git","clone","--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git","--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- ===== Plugins =====
require("lazy").setup({
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },

  {
    "Darazaki/indent-o-matic",
    lazy = false,
    config = function()
      require("indent-o-matic").setup({
        max_lines = 200,
        standard_widths = { 2, 4, 8 },
        default_indent = {
          typescript = 2,
          lua = 2,
          python = 4,
        },
      })
    end,
  },

  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },

  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = true,
  },

  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = { "node_modules", ".git/" },
          layout_config = {
            horizontal = { preview_width = 0.6 },
          },
        },
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "python", "javascript", "typescript", "html", "css" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  {
    "wellle/context.vim",
    config = function()
      vim.g.context_enabled = 1
      vim.g.context_max_height = 5
      vim.g.context_max_per_indent = 1

      -- Disable context in terminal buffers
      vim.api.nvim_create_autocmd("TermOpen", {
        callback = function()
          vim.b.context_enabled = 0
        end,
      })
    end,
  },
})
-- ===== Mason (LSP installer) =====
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "pyright", "lua_ls", "ts_ls" }, 
})

-- ===== LSP setup =====
local caps = require("cmp_nvim_lsp").default_capabilities()
local on_attach = function(_, bufnr)
  local map = function(m, lhs, rhs)
    vim.keymap.set(m, lhs, rhs, { buffer = bufnr })
  end
  map("n", "gd", vim.lsp.buf.definition)
  map("n", "K",  vim.lsp.buf.hover)
  map("n", "gr", vim.lsp.buf.references)
  map("n", "<leader>rn", vim.lsp.buf.rename)
end

-- Python (Pyright)
require("lspconfig").pyright.setup({
  on_attach = on_attach,
  capabilities = caps,
})

-- Lua (sumneko / lua-language-server)
require("lspconfig").lua_ls.setup({
  on_attach = on_attach,
  capabilities = caps,
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
    },
  },
})

-- TypeScript / JavaScript
require("lspconfig").ts_ls.setup({
  on_attach = on_attach,
  capabilities = caps,
})

-- ===== nvim-cmp setup =====
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args) require("luasnip").lsp_expand(args.body) end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"]      = cmp.mapping.confirm({ select = true }),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
  },
})

-- ===== Telescope keymaps =====
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Recent files" })

-- ===== Claude Code keymaps =====
vim.keymap.set("n", "<leader>cc", "<cmd>ClaudeCode<cr>", { desc = "Open Claude Code" })
vim.keymap.set("v", "<leader>cs", "<cmd>ClaudeCodeSelection<cr>", { desc = "Send selection to Claude" })
vim.keymap.set("n", "<leader>cf", "<cmd>ClaudeCodeFile<cr>", { desc = "Send current file to Claude" })
