require("theprimeagen.set")
require("theprimeagen.remap")
require("theprimeagen.lazy_init")
-- DO.not
-- DO NOT INCLUDE THIS

-- If i want to keep doing lsp debugging
-- function restart_htmx_lsp()
--     require("lsp-debug-tools").restart({ expected = {}, name = "htmx-lsp", cmd = { "htmx-lsp", "--level", "DEBUG" }, root_dir = vim.loop.cwd(), });
-- end

-- DO NOT INCLUDE THIS
-- DO.not

local augroup = vim.api.nvim_create_augroup
local ThePrimeagenGroup = augroup('ThePrimeagen', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

function R(name)
    require("plenary.reload").reload_module(name)
end

vim.filetype.add({
    extension = {
        templ = 'templ',
    }
})

autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

autocmd({"BufWritePre"}, {
    group = ThePrimeagenGroup,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

autocmd('LspAttach', {
    group = ThePrimeagenGroup,
    callback = function(e)
        local opts = { buffer = e.buf }
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function()
            vim.diagnostic.open_float({ scope = "line", border = "rounded", source = "always", max_width = 80, wrap = true })
        end, opts)
        vim.keymap.set("n", "<leader>E", function()
            vim.diagnostic.open_float({ scope = "line", border = "rounded", source = "always", max_width = 80, wrap = true })
        end, vim.tbl_extend("force", opts, { desc = "Diagnostics: full error float" }))
        vim.keymap.set("n", "T", function()
            vim.diagnostic.open_float({ scope = "line", border = "rounded", source = "always", max_width = 80, wrap = true })
        end, vim.tbl_extend("force", opts, { desc = "Diagnostics: full error float" }))
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, opts)
    end
})
-- Virtual text restored: always-visible inline errors, truncated for splits.
-- Full text via <leader>vd (float) and <leader>tt / <leader>tb (Trouble).
vim.diagnostic.config({
    virtual_text = {
        prefix = '●',
        spacing = 4,
        source = "if_many",
        format = function(diagnostic)
            local msg = diagnostic.message
            local max = 60
            if vim.fn.strchars(msg) > max then
                msg = vim.fn.strcharpart(msg, 0, max) .. "…"
            end
            return msg
        end,
    },
    virtual_lines = false,
    update_in_insert = false,
    severity_sort = true,
    underline = true,
    signs = true,
    float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always", -- Or "if_many"
        header = "",
        prefix = "",
        max_width = 80,
        wrap = true,
    },
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 2
vim.g.netrw_winsize = 25

--I tried nvim-tree one last time
-- disable netrw at the very start of your init.lua
--vim.g.loaded_netrw = 1
--vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

