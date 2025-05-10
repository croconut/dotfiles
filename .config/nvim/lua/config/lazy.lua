local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
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
    root = vim.fn.stdpath("data") .. "/lazy",              -- directory where plugins will be installed
    spec = "plugins",
    lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json", -- lockfile generated after running update.
    defaults = {
        lazy = true,                                       -- should plugins be lazy-loaded?
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

vim.lsp.config('gdscript', {})
vim.lsp.enable('gdscript')
vim.lsp.config('dartls', { root_markers = { 'pubspec.yaml' } })
vim.lsp.enable('dartls')

require('mason-lspconfig').setup({
    ensure_installed = { "ts_ls", "rust_analyzer", "gopls", "templ", "bashls", "tailwindcss", "lua_ls", "zls", "yamlls", "sqlls", "pyright", "intelephense" },
    handlers = {
        -- this first function is the "default handler"
        -- it applies to every language server without a "custom handler"
        function(server_name)
            vim.lsp.config(server_name, {})
            vim.lsp.enable(server_name)
        end,
        ['ts_ls'] = function()
            vim.lsp.config('ts_ls', {
                settings = {
                    implicitProjectConfiguration = {
                        checkJs = true
                    },
                }
            })
            vim.lsp.enable('ts_ls')
        end,
    }
})


