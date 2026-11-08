return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    { "j-hui/fidget.nvim",       opts = {} },
    { "b0o/schemastore.nvim" },
    { "hrsh7th/cmp-nvim-lsp" },
  },
  config = function()
    require("mason").setup({
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end

        map("gd", require("telescope.builtin").lsp_definitions, "Goto Definition")
        map("gr", require("telescope.builtin").lsp_references, "Goto References")
        map("gi", require("telescope.builtin").lsp_implementations, "Goto Implementation")
        map("go", require("telescope.builtin").lsp_type_definitions, "Type Definition")
        map("<leader>p", require("telescope.builtin").lsp_document_symbols, "Document Symbols")
        map("<leader>ws", require("telescope.builtin").lsp_workspace_symbols, "Workspace Symbols")
        map("<leader>Ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace Symbols")

        map("gl", vim.diagnostic.open_float, "Open Diagnostic Float")
        map("K", vim.lsp.buf.hover, "Hover Documentation")
        map("gs", vim.lsp.buf.signature_help, "Signature Documentation")
        map("gD", vim.lsp.buf.declaration, "Goto Declaration")

        map("<leader>v", "<cmd>vsplit | lua vim.lsp.buf.definition()<cr>", "Goto Definition in Vertical Split")

        local wk = require("which-key")
        wk.add({
          { "<leader>la", vim.lsp.buf.code_action,                           desc = "Code Action" },
          { "<leader>lA", vim.lsp.buf.code_action, mode = "v",                desc = "Range Code Actions" },
          { "<leader>ls", vim.lsp.buf.signature_help,                        desc = "Display Signature Information" },
          { "<leader>lr", vim.lsp.buf.rename,                                desc = "Rename all references" },
          { "<leader>lf", vim.lsp.buf.format,                                desc = "Format" },
          { "<leader>li", require("telescope.builtin").lsp_implementations,  desc = "Implementation" },
          { "<leader>lw", require("telescope.builtin").diagnostics,          desc = "Diagnostics" },
          { "<leader>lc", require("config.utils").copyFilePathAndLineNumber, desc = "Copy File Path and Line Number" },

          -- W = {
          --   name = "+Workspace",
          --   a = { vim.lsp.buf.add_workspace_folder, "Add Folder" },
          --   r = { vim.lsp.buf.remove_workspace_folder, "Remove Folder" },
          --   l = {
          --     function()
          --       print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          --     end,
          --     "List Folders",
          --   },
          -- },

          { "<leader>Wa", vim.lsp.buf.add_workspace_folder,                  desc = "Workspace Add Folder" },
          { "<leader>Wr", vim.lsp.buf.remove_workspace_folder,               desc = "Workspace Remove Folder" },
          {
            "<leader>Wl",
            function()
              print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end,
            desc = "Workspace List Folders",
          }
        })

        -- Thank you teej
        -- https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua#L502
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.server_capabilities.documentHighlightProvider then
          local highlight_augroup = vim.api.nvim_create_augroup("nvim-lsp-highlight", { clear = false })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })
          vim.api.nvim_create_autocmd("LspDetach", {
            group = vim.api.nvim_create_augroup("nvim-lsp-detach", { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds({ group = "nvim-lsp-highlight", buffer = event2.buf })
            end,
          })
        end
      end,
    })

    -- local capabilities = vim.lsp.protocol.make_client_capabilities()
    -- capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

    -- mason-lspconfig v2 removed setup_handlers; configure via vim.lsp.config
    -- and let mason-lspconfig auto-enable installed servers.
    vim.lsp.config("*", { capabilities = capabilities })
    for server_name, server_config in pairs(require("plugins.lsp.servers")) do
      vim.lsp.config(server_name, server_config)
    end

    require("mason-lspconfig").setup({
      ensure_installed = vim.tbl_keys(require("plugins.lsp.servers")),
      -- typescript-tools.nvim provides the TS server
      automatic_enable = { exclude = { "ts_ls" } },
    })

    -- Gleam LSP
    -- For some reason mason doesn't work with gleam lsp
    vim.lsp.enable("gleam")

    vim.diagnostic.config({
      title = false,
      underline = true,
      virtual_text = true,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.HINT] = "󰠠 ",
          [vim.diagnostic.severity.INFO] = " ",
        },
      },
      update_in_insert = false,
      severity_sort = true,
      float = {
        source = "if_many",
        style = "minimal",
        border = "rounded",
        header = "",
        prefix = "",
      },
    })
  end,
}
