local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end

vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.terminal_emulator = 'warp-terminal'

require("lazy").setup({
	root = vim.fn.stdpath("data") .. "/lazy", -- directory where plugins will be installed
	spec = "plugins",
	lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json", -- lockfile generated after running update.
	defaults = {
		lazy = true, -- should plugins be lazy-loaded?
		version = nil,
	},
	install = {
		missing = true,
		colorscheme = { "tokyonight", "habamax" },
	},
	checker = {
		enabled = true,
		notify = false,
		-- check for updates every day
		frequency = 86400,
	},
	change_detection = {
		enabled = true,
		notify = false,
	},
	performance = {
		cache = {
			enabled = true,
		},
	},
	state = vim.fn.stdpath("state") .. "/lazy/state.json", -- state info for checker and other things
})
