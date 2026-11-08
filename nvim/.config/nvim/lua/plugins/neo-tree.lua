-- Theme-aware highlights so the explorer blends with the active colorscheme
local function set_highlights()
  local hl = function(name, opts)
    vim.api.nvim_set_hl(0, name, opts)
  end
  hl("NeoTreeFloatBorder", { link = "FloatBorder" })
  hl("NeoTreeFloatTitle", { link = "Title" })
  hl("NeoTreeTitleBar", { link = "Title" })
  hl("NeoTreeRootName", { link = "Title" })
  hl("NeoTreeIndentMarker", { link = "NonText" })
  hl("NeoTreeExpander", { link = "Comment" })
  hl("NeoTreeDotfile", { link = "Comment" })
  hl("NeoTreeFileStats", { link = "Comment" })
  hl("NeoTreeFileStatsHeader", { link = "Comment" })
  hl("NeoTreeTabActive", { link = "TabLineSel" })
  hl("NeoTreeTabInactive", { link = "TabLine" })
  hl("NeoTreeTabSeparatorActive", { link = "TabLineSel" })
  hl("NeoTreeTabSeparatorInactive", { link = "TabLine" })
end

-- iRemote's Remote Host tab (local checkout; see lua/plugins/iremote.lua)
local has_iremote = vim.fn.isdirectory(vim.fn.expand("~/dev/iRemote")) == 1

return {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  event = "VeryLazy",
  keys = {
    { "<leader>e", "<cmd>Neotree toggle float reveal<cr>", desc = "Float File Explorer" },
    { "<leader><Tab>", "<cmd>Neotree toggle left reveal<cr>", desc = "Left File Explorer" },
  },
  config = function()
    set_highlights()
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("neo-tree-highlights", { clear = true }),
      callback = set_highlights,
    })

    local sources = { "filesystem", "buffers", "git_status", "document_symbols" }
    local selector = {
      { source = "filesystem", display_name = " 󰉓 Files " },
      { source = "buffers", display_name = " 󰈚 Bufs " },
      { source = "git_status", display_name = " 󰊢 Git " },
      { source = "document_symbols", display_name = "  Symbols " },
    }
    local extra_handlers = {}
    if has_iremote then
      table.insert(sources, "iremote.neotree")
      table.insert(selector, { source = "iremote", display_name = " 󰒍 Remote " })
      -- create / delete / rename in neo-tree → default server (follows the project's auto-upload options)
      extra_handlers = require("iremote").neo_tree_event_handlers()
    end

    require("neo-tree").setup({
      sources = sources,
      close_if_last_window = true,
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_modified_markers = true,
      enable_diagnostics = true,
      sort_case_insensitive = true,

      default_component_configs = {
        container = {
          enable_character_fade = true,
          right_padding = 1,
        },
        indent = {
          indent_size = 2,
          padding = 1,
          with_markers = true,
          indent_marker = "│",
          last_indent_marker = "╰",
          with_expanders = true,
          expander_collapsed = "",
          expander_expanded = "",
        },
        icon = {
          folder_closed = "󰉋",
          folder_open = "󰝰",
          folder_empty = "󰉖",
          folder_empty_open = "󰷏",
          default = "󰈚",
        },
        modified = {
          symbol = "●",
          highlight = "NeoTreeModified",
        },
        name = {
          trailing_slash = false,
          use_git_status_colors = true,
        },
        git_status = {
          symbols = {
            -- Change type
            added = "",
            deleted = "",
            modified = "",
            renamed = "󰁕",
            -- Status type
            untracked = "",
            ignored = "",
            unstaged = "󰄱",
            staged = "",
            conflict = "",
          },
          align = "right",
        },
        diagnostics = {
          symbols = {
            hint = "󰠠",
            info = "",
            warn = "",
            error = "",
          },
        },
        -- extra columns only render when the window is wide enough
        file_size = { enabled = true, required_width = 70 },
        type = { enabled = false },
        last_modified = { enabled = true, required_width = 90 },
        created = { enabled = false },
        symlink_target = { enabled = true },
      },

      window = {
        position = "float",
        width = 35,
        popup = {
          size = { height = "80%", width = "60%" },
          position = "50%",
          title = function(state)
            local names = {
              filesystem = "Files",
              buffers = "Buffers",
              git_status = "Git",
              document_symbols = "Symbols",
            }
            return " 󰙅 " .. (names[state.name] or state.name) .. " "
          end,
        },
        mappings = {
          ["<space>"] = "none", -- keep <space> free for leader
          ["l"] = "open",
          ["h"] = "close_node",
          ["<cr>"] = "open",
          ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = false } },
          ["s"] = "open_vsplit",
          ["S"] = "open_split",
          ["Y"] = "copy_path",
          ["<tab>"] = "next_source",
          ["<s-tab>"] = "prev_source",
        },
      },

      commands = {
        copy_path = function(state)
          local path = state.tree:get_node():get_id()
          vim.fn.setreg("+", path)
          vim.notify("Copied: " .. path)
        end,
      },

      filesystem = {
        use_libuv_file_watcher = true,
        follow_current_file = { enabled = true, leave_dirs_open = false },
        group_empty_dirs = true,
        hijack_netrw_behavior = "open_default",
        filtered_items = {
          visible = true, -- show hidden items dimmed instead of removing them
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = {
            "node_modules",
          },
          never_show = {
            ".git",
            ".DS_Store",
            "thumbs.db",
          },
        },
      },

      buffers = {
        follow_current_file = { enabled = true },
        group_empty_dirs = true,
      },

      source_selector = {
        winbar = true,
        content_layout = "center",
        tabs_layout = "equal",
        separator = { left = "", right = "" },
        show_separator_on_edge = true,
        sources = selector,
      },

      event_handlers = vim.list_extend({
        {
          event = "neo_tree_window_after_open",
          handler = function(args)
            if args.position == "left" or args.position == "right" then
              vim.cmd("wincmd =")
            end
          end,
        },
        {
          event = "neo_tree_window_after_close",
          handler = function(args)
            if args.position == "left" or args.position == "right" then
              vim.cmd("wincmd =")
            end
          end,
        },
      }, extra_handlers),
    })
  end,
}
