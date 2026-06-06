-- Evidenzia il testo copiato

vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Rimuove gli spazi finali al salvataggio

vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function()
        local pos = vim.api.nvim_win_get_cursor(0)

        vim.cmd([[%s/\s\+$//e]])

        vim.api.nvim_win_set_cursor(0, pos)
    end,
})
