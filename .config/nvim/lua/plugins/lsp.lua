return {
    {
        "nvim-treesitter/nvim-treesitter",
        version = false,
        event = { 'BufReadPre', 'BufNewFile' },
        build = ":TSUpdate",
        dependencies = {
            {
                "nvim-treesitter/nvim-treesitter-textobjects",
                init = function()
                    local plugin = require("lazy.core.config").spec.plugins["nvim-treesitter"]
                    local opts = require("lazy.core.plugin").values(plugin, "opts", false)
                    local enabled = false
                    if opts.textobjects then
                        for _, mod in ipairs({ "move", "select", "swap", "lsp_interop" }) do
                            if opts.textobjects[mod] and opts.textobjects[mod].enable then
                                enabled = true

                                break
                            end
                        end
                    end
                    if not enabled then
                        require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
                    end
                end,
            },
        },
        opts = {
            ensure_installed = "all",
            highlight = {
                enable = true,
            },
            ignore_install = { "jsdoc", "comment" }, -- sadly jsdoc is too slow, we'll just leave comments unparsed
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
    },
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v4.x',
        lazy = true,
        config = false,
    },
    {
        'williamboman/mason.nvim',
        lazy = false,
        config = true,
    },
    {
        'neovim/nvim-lspconfig',
        cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },
        },
        config = function()
            local lsp_zero = require('lsp-zero')

            -- lsp_attach is where you enable features that only work
            -- if there is a language server active in the file
            local lsp_attach = function(client, bufnr)
                local opts = { buffer = bufnr }

                vim.keymap.set('n', 'K', function()
                    vim.lsp.buf.hover()
                end, opts)
                vim.keymap.set('n', 'gd', function()
                    vim.lsp.buf.definition()
                end, opts)
                vim.keymap.set('n', 'gD', function()
                    vim.lsp.buf.declaration()
                end, opts)
                vim.keymap.set('n', 'gi', function()
                    vim.lsp.buf.implementation()
                end, opts)
                vim.keymap.set('n', 'go', function()
                    vim.lsp.buf.type_definition()
                end, opts)
                vim.keymap.set('n', 'gr', function()
                    vim.lsp.buf.references()
                end, opts)
                vim.keymap.set('n', 'gs', function()
                    vim.lsp.buf.signature_help()
                end, opts)
                vim.keymap.set('n', '<F2>', function()
                    vim.lsp.buf.rename()
                end, opts)
                vim.keymap.set({ 'n', 'x' }, '<F3>', function()
                    vim.lsp.buf.format({ async = true })
                end, opts)
                vim.keymap.set('n', '<F4>', function()
                    vim.lsp.buf.code_action()
                end, opts)
                vim.keymap.set({ 'n', 'x' }, '<leader>bf', function()
                    vim.lsp.buf.format({ async = false })
                end, opts)
                vim.keymap.set("n", "[d", function()
                    vim.diagnostic.goto_next()
                end, opts)
                vim.keymap.set("n", "]d", function()
                    vim.diagnostic.goto_prev()
                end, opts)
                vim.keymap.set("n", "<leader>rn", function()
                    vim.lsp.buf.rename()
                end, opts)
                vim.keymap.set("n", "<leader>rw", function()
                    vim.lsp.buf.workspace_symbol()
                end, opts)
                vim.keymap.set("n", "<leader>rd", function()
                    vim.diagnostic.open_float()
                end, opts)
                vim.keymap.set("n", "<leader>ra", function()
                    vim.lsp.buf.code_action()
                end, opts)
                vim.keymap.set("n", "<leader>rr", function()
                    vim.lsp.buf.references()
                end, opts)
                vim.keymap.set("n", "[d", function()
                    vim.diagnostic.goto_next()
                end, opts)
                vim.keymap.set("n", "]d", function()
                    vim.diagnostic.goto_prev()
                end, opts)
            end
            
            lsp_zero.extend_lspconfig({
                sign_text = true,
                lsp_attach = lsp_attach,
                capabilities = require('cmp_nvim_lsp').default_capabilities()
            })

       end
    },
}
