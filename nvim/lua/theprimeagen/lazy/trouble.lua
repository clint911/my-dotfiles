return {
  {
      "folke/trouble.nvim",
      config = function()
          require("trouble").setup({
              icons = true,
              focus = false,
              multiline = true,
              win = { position = "bottom", size = 10 },
          })

          vim.keymap.set("n", "<leader>tt", function()
              require("trouble").toggle("diagnostics")
          end, { desc = "Trouble: workspace diagnostics" })

          vim.keymap.set("n", "<leader>tb", function()
              require("trouble").toggle({ mode = "diagnostics", filter = { buf = 0 } })
          end, { desc = "Trouble: buffer diagnostics" })

          vim.keymap.set("n", "[t", function()
              require("trouble").prev({skip_groups = true, jump = true});
          end)

          vim.keymap.set("n", "]t", function()
              require("trouble").next({skip_groups = true, jump = true});
          end)
         vim.keymap.set("n", "<leader>tf", function() require("trouble").toggle("qflist") end)
 vim.keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end)
      end
  },
}
