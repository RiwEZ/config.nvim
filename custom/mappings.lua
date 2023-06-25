---@type MappingsTable
local M = {}

M.disabled = {
  n = {
    ["<leader>b"] = "",
  },
}

M.comment = {
  plugin = false,
}

M.nvterm = {
  plugin = false,
}

M.telescope = {
  n = {
    -- find
    ["<leader>gf"] = { "<cmd> Telescope find_files <CR>", "Find files" },
    ["<leader>sf"] = { "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>", "Find all" },
    ["<leader>sg"] = { "<cmd> Telescope live_grep <CR>", "Live grep" },
    ["<leader>sh"] = { "<cmd> Telescope help_tags <CR>", "Help page" },
    ["<leader>/"] = { "<cmd> Telescope current_buffer_fuzzy_find <CR>", "Find in current buffer" },
    ["<leader>?"] = { "<cmd> Telescope oldfiles <CR>", "Find oldfiles" },

    ["<leader><space>"] = { "<cmd> Telescope buffers <CR>", "Find buffers" },

    -- theme switcher
    ["<leader>th"] = { "<cmd> Telescope themes <CR>", "Nvchad themes" },

    ["<leader>ma"] = { "<cmd> Telescope marks <CR>", "telescope bookmarks" },
  },
}

M.harpoon = {
  n = {
    ["<leader>b"] = {
      function()
        require("harpoon.mark").add_file()
      end,
      "harpoon mark",
    },
    ["<S-e>"] = {
      function()
        require("harpoon.ui").toggle_quick_menu()
      end,
      "toggle harpoon ui",
    },
  },
}

return M
