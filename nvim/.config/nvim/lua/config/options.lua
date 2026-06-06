-- Numeri
vim.opt.number = true
vim.opt.relativenumber = true

-- Indentazione
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Ricerca
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Aspetto
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"

-- Scroll
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- Split
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Mouse
vim.opt.mouse = "a"

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Tempi di risposta
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Backup / swap
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

-- Completamento
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- Folding (lo prepariamo per Treesitter)
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldenable = false
