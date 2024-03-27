-- telescope
local t = require("telescope.builtin")
vim.keymap.set("n", "<leader>gf", t.git_files, {})
vim.keymap.set("n", "<leader>sf", t.find_files, {})
vim.keymap.set("n", "<leader>sg", t.live_grep, {})
vim.keymap.set("n", "<leader>/", t.buffers, {})
vim.keymap.set("n", "<leader>?", t.oldfiles, {})
