-- leader always first
vim.g.mapleader = " "
vim.opt.termguicolors = true
if vim.fn.has("nvim-0.11") == 0 then
	error("Need Neovim 0.11+ in order to use this config")
end

for _, cmd in ipairs({ "git", "rg", { "fd", "fdfind" } }) do
	local name = type(cmd) == "string" and cmd or vim.inspect(cmd)
	local commands = type(cmd) == "string" and { cmd } or cmd
	---@cast commands string[]
	local found = false

	for _, c in ipairs(commands) do
		if vim.fn.executable(c) == 1 then
			name = c
			found = true
		end
	end

	if not found then
		error(("`%s` is not installed"):format(name))
	end
end

require("config.lazy")
require("keymaps")
require("options")
require("autocmds")

