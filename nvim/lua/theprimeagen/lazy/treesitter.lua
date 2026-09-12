 return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main", -- Ensure you are tracking the modern rewrite branch
  build = ":TSUpdate",
  config = function()
    local ts = require("nvim-treesitter")

    -- 1. Configure custom or external parsers
    ts.setup({
      local_parsers = {
        templ = {
          source = {
            type = "self_contained",
            url = "https://github.com/vrischmann/tree-sitter-templ.git",
          },
          filetypes = { "templ" },
        },
      },
    })

    -- 2. Replace 'ensure_installed' by explicitly calling install
    ts.install({
      "lua",
      "go",
      "javascript",
      "typescript",
      "markdown",
      -- Add any other languages you want auto-managed
    })

    -- 3. Native Filetype Mapping
    vim.filetype.add({
      extension = {
        templ = "templ",
      },
    })

    -- 4. Native Highlighting & Indentation Toggle
    -- Instead of old plugin modules, we spin up the built-in Neovim engines
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "templ", "lua", "go", "javascript", "typescript", "markdown" },
      callback = function()
        vim.treesitter.start()

        -- Enables native tree-sitter based indentation tracking
        vim.bo.indentexpr = "v:lua.vim.treesitter.indentexpr()"
      end,
    })
  end,
}
