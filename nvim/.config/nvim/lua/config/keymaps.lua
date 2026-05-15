-- `keymaps.lua` — Neovim keymaps per tastiera italiana

-- =========================================================
-- LEADER
-- =========================================================

vim.g.mapleader = " "
vim.g.maplocalleader = " "


-- =========================================================
-- OPTIONS
-- =========================================================

-- rende più naturale il mapping jk -> Esc
vim.opt.timeoutlen = 250


-- =========================================================
-- ESC ERGONOMICO
-- =========================================================

-- insert mode
vim.keymap.set("i", "jk", "<Esc>", {
  desc = "Exit insert mode",
})

-- terminal mode
vim.keymap.set("t", "jk", [[<C-\\><C-n>]], {
  desc = "Exit terminal mode",
})


-- =========================================================
-- SAVE / QUIT
-- =========================================================

vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", {
  desc = "Save file",
})

vim.keymap.set("n", "<leader>q", "<cmd>q<CR>", {
  desc = "Quit window",
})

vim.keymap.set("n", "<leader>x", "<cmd>x<CR>", {
  desc = "Save and quit",
})

vim.keymap.set("n", "<leader>Q", "<cmd>qa!<CR>", {
  desc = "Force quit all",
})


-- =========================================================
-- CLEAR SEARCH HIGHLIGHT
-- =========================================================

vim.keymap.set("n", "<leader>h", "<cmd>nohlsearch<CR>", {
  desc = "Clear search highlight",
})


-- =========================================================
-- WINDOW NAVIGATION
-- =========================================================

vim.keymap.set("n", "<C-h>", "<C-w>h", {
  desc = "Move to left split",
})

vim.keymap.set("n", "<C-j>", "<C-w>j", {
  desc = "Move to lower split",
})

vim.keymap.set("n", "<C-k>", "<C-w>k", {
  desc = "Move to upper split",
})

vim.keymap.set("n", "<C-l>", "<C-w>l", {
  desc = "Move to right split",
})


-- =========================================================
-- SPLITS
-- =========================================================

vim.keymap.set("n", "<leader>sv", "<cmd>vsplit<CR>", {
  desc = "Vertical split",
})

vim.keymap.set("n", "<leader>sh", "<cmd>split<CR>", {
  desc = "Horizontal split",
})


-- =========================================================
-- SPLIT RESIZE
-- =========================================================

vim.keymap.set("n", "<leader>+", "<cmd>resize +5<CR>", {
  desc = "Increase split height",
})

vim.keymap.set("n", "<leader>-", "<cmd>resize -5<CR>", {
  desc = "Decrease split height",
})


-- =========================================================
-- BUFFER MANAGEMENT
-- =========================================================

vim.keymap.set("n", "<leader>bn", "<cmd>bnext<CR>", {
  desc = "Next buffer",
})

vim.keymap.set("n", "<leader>bp", "<cmd>bprevious<CR>", {
  desc = "Previous buffer",
})

vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", {
  desc = "Delete buffer",
})


-- =========================================================
-- BETTER INDENTING
-- =========================================================

vim.keymap.set("v", "<", "<gv", {
  desc = "Indent left",
})

vim.keymap.set("v", ">", ">gv", {
  desc = "Indent right",
})


-- =========================================================
-- MOVE LINES
-- =========================================================

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", {
  desc = "Move selection down",
})

vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", {
  desc = "Move selection up",
})


-- =========================================================
-- SYSTEM CLIPBOARD
-- =========================================================

vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', {
  desc = "Yank to system clipboard",
})

vim.keymap.set("n", "<leader>p", '"+p', {
  desc = "Paste from system clipboard",
})


-- =========================================================
-- TERMINAL
-- =========================================================

vim.keymap.set("n", "<leader>tt", "<cmd>terminal<CR>", {
  desc = "Open terminal",
})


-- =========================================================
-- TELESCOPE
-- =========================================================
-- richiede:
-- https://github.com/nvim-telescope/telescope.nvim
-- =========================================================

vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", {
  desc = "Find files",
})

vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", {
  desc = "Live grep",
})

vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>", {
  desc = "Recent files",
})

vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", {
  desc = "Find buffers",
})

vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", {
  desc = "Help tags",
})


-- =========================================================
-- LSP
-- =========================================================

vim.keymap.set("n", "gd", vim.lsp.buf.definition, {
  desc = "Go to definition",
})

vim.keymap.set("n", "gr", vim.lsp.buf.references, {
  desc = "References",
})

vim.keymap.set("n", "K", vim.lsp.buf.hover, {
  desc = "Hover documentation",
})

vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, {
  desc = "Rename symbol",
})

vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, {
  desc = "Code action",
})


-- =========================================================
-- QUICKFIX / LOCATION LIST
-- =========================================================

vim.keymap.set("n", "<leader>cn", "<cmd>cnext<CR>", {
  desc = "Quickfix next",
})

vim.keymap.set("n", "<leader>cp", "<cmd>cprev<CR>", {
  desc = "Quickfix previous",
})

vim.keymap.set("n", "<leader>co", "<cmd>copen<CR>", {
  desc = "Open quickfix",
})

vim.keymap.set("n", "<leader>cc", "<cmd>cclose<CR>", {
  desc = "Close quickfix",
})


-- =========================================================
-- BETTER SCROLLING
-- =========================================================

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")


-- =========================================================
-- SEARCH RESULTS CENTERED
-- =========================================================

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")


-- =========================================================
-- KEEP PASTE BUFFER
-- =========================================================

vim.keymap.set("x", "<leader>p", [['_dP]], {
  desc = "Paste without overwriting register",
})


-- =========================================================
-- DISABLE EX MODE
-- =========================================================

vim.keymap.set("n", "Q", "<nop>")

-- =========================================================
-- NEO-TREE
-- =========================================================

vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<CR>", {
  desc = "Toggle file explorer",
})
