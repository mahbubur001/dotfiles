return {
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        build = ":Copilot auth",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                panel = {
                    enabled = true,
                    auto_refresh = true,
                    keymap = {
                        -- panel keys must differ from suggestion keys (copilot.lua rejects duplicates)
                        jump_next = "]]",
                        jump_prev = "[[",
                        accept = "<CR>",
                        refresh = "r",
                        open = "<M-CR>",
                    },
                    layout = {
                        position = "bottom", -- | top | left | right
                        ratio = 0.4,
                    },
                },
                suggestion = {
                    enabled = true,
                    auto_trigger = true,
                    debounce = 75,
                    keymap = {
                        accept = "<c-a>",
                        accept_word = false,
                        accept_line = false,
                        next = "<c-j>",
                        prev = "<c-k>",
                        dismiss = "<C-e>",
                    },
                },
            })
        end,
    },

    -- {
    --     "zbirenbaum/copilot-cmp",
    --     -- after = { "copilot.lua" },
    --     config = function()
    --         require("copilot_cmp").setup()
    --     end,
    -- }
}
