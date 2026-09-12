
function ColorMyPencils(color)
--	color = color or "rose-pine"
  color = color or "rose-pine"
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	-- Reuse rose-pine palette so floats stay readable with transparent bg.
	-- palette: base #191724, surface #1f1d2e, overlay #26233a, rose #ebbcba, etc.
	local ok, palette = pcall(require, "rose-pine.palette")
	if ok then
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = palette.surface })
		vim.api.nvim_set_hl(0, "FloatBorder", { bg = palette.surface, fg = palette.subtle })
		vim.api.nvim_set_hl(0, "NotifyBackground", { bg = palette.base })
	else
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
	end

end
return {
	{
        "rose-pine/neovim",
        --name = "rose-pine",
        name = "rose-pine",
        config = function()
            require('rose-pine').setup({
                disable_background = true,
                styles = {
                    italic = true,
                },
            })

           -- vim.cmd("colorscheme rose-pine")
          vim.cmd("colorscheme rose-pine")

            ColorMyPencils()
        end
    },

}
