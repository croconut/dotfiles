return {
    {
        "folke/tokyonight.nvim",
        opts = { lazy = false }
    },
    { "folke/neodev.nvim", lazy = false },
    {
        "folke/which-key.nvim",
        opts = {},
        lazy = false,
        config = function(_, opts)
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require("which-key").setup(opts)
        end,
    },
    { -- Floating terminal
        "itmecho/neoterm.nvim",
        opts = {
            clear_on_run = true, -- run clear command before user specified commands
            position = "bottom", -- vertical/horizontal/fullscreen
            noinsert = false,    -- disable entering insert mode when opening the neoterm window
            height = 0.3,
        },
        lazy = false,
        config = function(_, opts)
            require("neoterm").setup(opts)
        end,
    },
    {
        "LunarVim/bigfile.nvim",
        lazy = false,
        opts = {
            filesize = 2,
            pattern = { "*" }, -- autocmd pattern or function see <### Overriding the detection of big files>
            features = {       -- features to disable
                "indent_blankline",
                "illuminate",
                "lsp",
                "treesitter",
                "syntax",
                "matchparen",
                "vimopts",
                "filetype",
            },
        },
    },
    {
        "numToStr/Comment.nvim",
        opts = {
            toggler = {
                line = "<C-/>",
            },
        },
        opleader = {
            line = "gc",
            block = "gb",
        },
        event = "FileType",
    },
    {
        "startup-nvim/startup.nvim",
        lazy = false,
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
        opts = {
            header = {
                type = "text",
                oldfiles_directory = false,
                align = "center",
                fold_section = false,
                title = "Header",
                margin = 2,
                content = require("startup.headers").hydra_header,
                highlight = "Statement",
                default_color = "",
                oldfiles_amount = 0,
            },
            -- name which will be displayed and command
            body = {
                type = "mapping",
                oldfiles_directory = false,
                align = "center",
                fold_section = false,
                title = "Startup Commands",
                margin = 3,
                content = {
                    { " Find File",     "Telescope find_files",            "<leader>ff" },
                    { "󰍉 Find Word",     "Telescope live_grep",             "<leader>fg" },
                    { " Open Terminal", "NeotermToggle",                   "<leader>tt" },
                    { " Colorschemes",  "Telescope colorscheme",           "<leader>fc" },
                    { " New File",      "lua require'startup'.new_file()", "<leader>nf" },
                },
                highlight = "String",
                default_color = "",
                oldfiles_amount = 0,
            },
            footer = {
                type = "text",
                oldfiles_directory = false,
                align = "center",
                fold_section = false,
                title = "Footer",
                margin = 3,
                content = require("startup.functions").quote(),
                highlight = "Constant",
                default_color = "",
                oldfiles_amount = 0,
            },
            options = {
                mapping_keys = true,
                cursor_column = 0.5,
                empty_lines_between_mappings = true,
                disable_statuslines = true,
                paddings = { 1, 3, 3, 0 },
            },
            mappings = {
                execute_command = "<CR>",
            },
            colors = {
                background = "#1f2227",
                folded_section = "#56b6c2",
            },
            parts = { "header", "body", "footer" },
        }
    }
}
