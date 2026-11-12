return {
  {
    -- morhetz/gruvbox, local copy from ~/Downloads/gruvbox-master
    dir = vim.fn.stdpath("data") .. "/themes/gruvbox",
    name = "gruvbox",
    lazy = false,
    priority = 1000,
    config = function()
      vim.o.background = "dark"
      vim.g.gruvbox_contrast_dark = "hard"
      vim.cmd.colorscheme("gruvbox")
    end,
  },

  {
    "sainnhe/gruvbox-material",
    enabled = false,
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_transparent_background = 0
      vim.g.gruvbox_material_foreground = "mix"
      vim.g.gruvbox_material_background = "hard"
      vim.g.gruvbox_material_ui_contrast = "high"
      vim.g.gruvbox_material_float_style = "bright"
      vim.g.gruvbox_material_statusline_style = "material"
      vim.g.gruvbox_material_cursor = "auto"

      -- vim.g.gruvbox_material_colors_override = { bg0 = '#16181A' } -- #0e1010
      -- vim.g.gruvbox_material_better_performance = 1

      vim.cmd.colorscheme("gruvbox-material")
    end,
  },

  -- { "bluz71/vim-moonfly-colors",  name = "moonfly",  lazy = false, priority = 1000 },
  -- { "bluz71/vim-nightfly-colors", name = "nightfly", lazy = false, priority = 1000 },
}
