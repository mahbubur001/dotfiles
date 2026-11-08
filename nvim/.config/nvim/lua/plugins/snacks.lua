-- snacks.nvim: dashboard, notifications, indent guides, smooth scroll,
-- buffer delete, input prompts and lazygit in one plugin
local logo = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]]

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    quickfile = { enabled = true },
    input = { enabled = true },
    scroll = { enabled = true },
    lazygit = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 3000,
      style = "compact",
    },
    indent = {
      enabled = true,
      animate = { enabled = false },
      scope = { enabled = true },
    },
    dashboard = {
      enabled = true,
      preset = {
        header = logo,
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":Telescope find_files" },
          { icon = " ", key = "g", desc = "Find Text", action = ":Telescope live_grep" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":Telescope oldfiles" },
          { icon = " ", key = "s", desc = "Restore Session", action = function() require("persistence").load() end },
          { icon = " ", key = "c", desc = "Config", action = ":e ~/.config/nvim/" },
          { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
      sections = {
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
        { section = "startup" },
      },
    },
  },
  keys = {
    { "Q", function() Snacks.bufdelete() end, desc = "Delete buffer" },
    { "<leader>Gg", function() Snacks.lazygit() end, desc = "Lazygit" },
    { "<leader>GL", function() Snacks.lazygit.log_file() end, desc = "Lazygit log (current file)" },
    { "<leader>un", function() Snacks.notifier.show_history() end, desc = "Notification history" },
    { "<leader>ud", function() Snacks.notifier.hide() end, desc = "Dismiss notifications" },
  },
}
