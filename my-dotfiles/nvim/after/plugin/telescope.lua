local builtin = require('telescope.builtin')
--vim.keymap.set('n', '<leader>yf', builtin.find_files, {})
vim.keymap.set('n', '<leader>t', builtin.find_files, {})
vim.keymap.set('n', '<C-n>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
  builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)
