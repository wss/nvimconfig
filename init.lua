vim.g.mapleader = " " 
vim.opt.number = true 
vim.opt.relativenumber = true 
vim.opt.tabstop = 4 
vim.opt.shiftwidth = 4 
vim.opt.expandtab = true 
vim.opt.termguicolors = true


local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim",
    "--branch=stable", -- 使用最新稳定版
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {"nvim-treesitter/nvim-treesitter",
   branch = "master",	
   build = ":TSUpdate",
   config = function()
	require("nvim-treesitter.configs").setup({
	  ensure_installed = { "lua", "vim", "vimdoc", "query", "c", "cpp" },
	  highlight = { enable = true },
	  indent = { enable = true },
	})
   end,
   },
  "tpope/vim-commentary",
   { "catppuccin/nvim", name = "catppuccin", priority = 1000},
   -- LSP 
   { "neovim/nvim-lspconfig", dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim", }, 
   }, 
   -- 自动补全 
   { "hrsh7th/nvim-cmp", dependencies = { "hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip", }, },
})

-- mason
require("mason").setup() require("mason-lspconfig").setup({ ensure_installed = { "clangd", "pyright", "bashls",} })

-- LSP配置
--local lspconfig = require("lspconfig") 
--local on_attach = function(_, bufnr) 
--	local opts = { buffer = bufnr } 
--	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts) 
--	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts) 
--	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts) 
--	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) 
--end

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local opts = { buffer = args.buf }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts) 
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) 
    end,
})


-- clangd
--lspconfig.clangd.setup({ 
--	on_attach = on_attach, 
--	cmd = { "clangd", "--background-index", "--clang-tidy", "--completion-style=detailed", }, 
--})
--clangd 
vim.lsp.config("clangd", { 
    cmd = { "clangd", "--background-index", "--clang-tidy", "--completion-style=detailed", }, 
}) 

-- python 
vim.lsp.config("pyright", {}) 
-- bash 
vim.lsp.config("bashls", {}) 
-- LSP

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        globals = { "vim" }, -- 关键！不然会提示 vim 未定义
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
    },
  },
})
vim.lsp.enable("lua_ls")

-- 启用 LSP 
vim.lsp.enable({ "clangd", "pyright", "bashls", })


local cmp = require("cmp") 
cmp.setup({ 
	snippet = { 
		expand = function(args) 
		  require("luasnip").lsp_expand(args.body) 
		end, 
	}, 
	mapping = cmp.mapping.preset.insert({ 
		["<C-Space>"] = cmp.mapping.complete(), 
		["<CR>"] = cmp.mapping.confirm({ select = true }), 
	}), 
	sources = { { name = "nvim_lsp" }, } 
})





