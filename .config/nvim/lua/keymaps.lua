local setk = vim.keymap.set

-- map some useful common commands from other editors
setk({ "i", "n", "v" }, "<C-s>", "<esc>:w<CR>", { desc = "Save File" })
setk({ "i", "n", "v" }, "<C-f>", "<esc>/", { desc = "Find in file" })
-- :redo is redo still btw
setk({ "i", "n", "v" }, "<C-r>", "<esc><CR>:%s//gc<LEFT><LEFT><LEFT>", { desc = "Replace in file", noremap = true, })
setk({ "i", "n" }, "<C-q>", "<esc>:wq<CR>", { desc = "Save & exit" })
setk("i", "<C-z>", "<esc>:undo<CR>i", { desc = "Undo" })
setk("n", "<C-z>", "<esc>:undo<CR>", { desc = "Undo" })
setk("v", "<C-z>", "<esc>", { desc = "Undo" })
setk("n", "u", "<CR>", { desc = "Removed undo, use :undo" })
setk("n", "r", "<CR>", { desc = "Removed redo, use :redo" })

-- tabs
setk("n", "[b", "<Cmd>BufferPrevious<CR>", { noremap = true, silent = true })
setk("n", "]b", "<Cmd>BufferNext<CR>", { noremap = true, silent = true })
setk("n", "<leader>b1", "<Cmd>BufferGoto 1<CR>", { noremap = true, silent = true })
setk("n", "<leader>b2", "<Cmd>BufferGoto 2<CR>", { noremap = true, silent = true })
setk("n", "<leader>b3", "<Cmd>BufferGoto 3<CR>", { noremap = true, silent = true })
setk("n", "<leader>b4", "<Cmd>BufferGoto 4<CR>", { noremap = true, silent = true })
setk("n", "<leader>bd", "<cmd>bd<CR>", { noremap = true, silent = true })

-- Move around splits
setk("n", "<leader>wh", "<C-w>h", { desc = "Left window" })
setk("n", "<leader>wj", "<C-w>j", { desc = "Down window" })
setk("n", "<leader>wk", "<C-w>k", { desc = "Up window" })
setk("n", "<leader>wl", "<C-w>l", { desc = "Right window" })

-- Telescope
setk("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Fuzzy file" })
setk("n", "<leader>fd", "<cmd>Telescope git_files hidden=true<CR>", { desc = "Fuzzy git files" })
setk("n", "<leader>fa", "<cmd>Telescope find_files hidden=true<CR>", { desc = "Fuzzy all files" })
setk("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Fuzzy grep" })
setk("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Fuzzy buffer" })
setk("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Fuzzy help" })
setk("n", "<leader>fc", "<cmd>Telescope colorscheme<CR>", { desc = "Fuzzy colorscheme" })

-- Terminal
setk("n", "<leader>tt", "<cmd>lua require'FTerm'.toggle()<CR>", { desc = "Show terminal" })
setk("t", "<esc>", "<cmd>lua require'FTerm'.close()<CR>", { desc = "Hide terminal" })

-- primeagen remaps
setk("x", "<leader>p", [["_dP]])

setk({ "n", "v" }, "<leader>y", [["+y]])
setk("n", "<leader>Y", [["+Y]])

setk({ "n", "v" }, "<leader>d", [["_d]])

