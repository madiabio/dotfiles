-- ===== Basic Options =====
vim.opt.mouse = "a" -- enable scrolling and changing sizes with mouse
vim.opt.number = true
vim.opt.signcolumn = "yes"
vim.opt.background = "dark"
vim.opt.termguicolors = true
vim.cmd([[
  filetype plugin on
]])
vim.diagnostic.config({
  virtual_text = true,  -- show error messages inline
  signs = true,         -- show signs in the gutter
  underline = true,     -- underline problems
  update_in_insert = false,
})
vim.keymap.set('n', '<Esc>', ':nohlsearch<CR>', { noremap = true, silent = true }) -- clear highlighted search text with esc
vim.api.nvim_create_autocmd("FileType", { -- Turn on line numbers for netrw
  pattern = "netrw",
  callback = function()
    vim.opt_local.number = true        -- absolute numbers
  end,
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
  -- LSP
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },

  -- Indentation Settings
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

  -- Completion
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },

  -- Claude Integration
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = true,
  },

  -- Fuzzy Finder
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

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "python", "javascript", "typescript", "html", "css" },
        highlight = { enable = true },
        indent = { enable = false },
      })
    end,
  },

  -- Context Bar
  {
    "nvim-treesitter/nvim-treesitter-context",
    config = function()
      require("treesitter-context").setup({
        enable = true,            -- enable this plugin
        max_lines = 3,            -- max lines shown in the context window
        min_window_height = 0,    -- disable if window too small
        line_numbers = true,      -- show line numbers in context
        trim_scope = "outer",     -- which scope to trim when max_lines is exceeded
        mode = "topline",          -- "cursor" or "topline"
        separator = "-",          -- e.g. "─" to put a line under context
        zindex = 20,              -- control overlay priority
      })
    end,
  },

  -- Gruvbox (Lua)
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        contrast = "hard", -- "soft", "medium" or "hard"
        transparent_mode = false,
      })
      vim.opt.termguicolors = true
      vim.cmd.colorscheme("gruvbox")
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
vim.keymap.set('n', '<leader>fc', function() -- fuzzy find in current open buffer only
  require('telescope.builtin').current_buffer_fuzzy_find()
end, { desc = 'Fuzzy search in current file' })
-- ===== Claude Code keymaps =====
vim.keymap.set("n", "<leader>cc", "<cmd>ClaudeCode<cr>", { desc = "Open Claude Code" })
vim.keymap.set("v", "<leader>cs", "<cmd>ClaudeCodeSelection<cr>", { desc = "Send selection to Claude" })
vim.keymap.set("n", "<leader>cf", "<cmd>ClaudeCodeFile<cr>", { desc = "Send current file to Claude" })

-- ===== Context Bar Colouring ===
vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "#282828", fg = "#ebdbb2", bold = true })
vim.api.nvim_set_hl(0, "TreesitterContextSeparator", { fg = "#d79921" }) -- bright yellow/gold border
