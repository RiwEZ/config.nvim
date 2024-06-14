-- Set highlight on search
vim.o.hlsearch = false
vim.opt.incsearch = true

-- Scroll setting
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

-- Line number
vim.opt.nu = true
vim.opt.relativenumber = false

-- Indentation
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.o.breakindent = true

-- Undo shits 
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Colors 
vim.opt.termguicolors = true

-- Column
vim.opt.colorcolumn = "100"

-- Others
vim.opt.updatetime = 50
