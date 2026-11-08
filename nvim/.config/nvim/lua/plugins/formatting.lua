-- Formatting (conform.nvim) and linting (nvim-lint); replaces none-ls
return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo", "FormatEnable", "FormatDisable" },
    keys = {
      {
        "<leader>lf",
        function()
          require("conform").format({ async = true })
        end,
        mode = { "n", "v" },
        desc = "Format",
      },
      {
        "<leader>uf",
        function()
          vim.g.autoformat = not vim.g.autoformat
          vim.notify("Format on save " .. (vim.g.autoformat and "enabled" or "disabled"))
        end,
        desc = "Toggle format on save",
      },
    },
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "black" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },
        proto = { "buf" },
        terraform = { "terraform_fmt" },
        tf = { "terraform_fmt" },
        ["terraform-vars"] = { "terraform_fmt" },
        yaml = { "yamlfmt" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        html = { "prettier" },
        markdown = { "prettier" },
        graphql = { "prettier" },
      },
      default_format_opts = { lsp_format = "fallback" },
      -- off by default (as before); toggle with <leader>uf
      format_on_save = function()
        if vim.g.autoformat then
          return { timeout_ms = 1000 }
        end
      end,
    },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
      vim.api.nvim_create_user_command("FormatEnable", function()
        vim.g.autoformat = true
      end, { desc = "Enable format on save" })
      vim.api.nvim_create_user_command("FormatDisable", function()
        vim.g.autoformat = false
      end, { desc = "Disable format on save" })
    end,
  },

  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile", "BufWritePost" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        go = { "golangcilint" },
        terraform = { "terraform_validate" },
        yaml = { "yamllint" },
        markdown = { "markdownlint-cli2" },
      }

      vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
        callback = function()
          -- only run linters whose executable is installed
          local names = vim.tbl_filter(function(name)
            local linter = lint.linters[name]
            local cmd = type(linter) == "table" and linter.cmd or nil
            if type(cmd) == "function" then
              cmd = cmd()
            end
            return cmd and vim.fn.executable(cmd) == 1
          end, lint.linters_by_ft[vim.bo.filetype] or {})
          lint.try_lint(names)
        end,
      })
    end,
  },

  -- Keep formatter/linter binaries installed via Mason
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    event = "VeryLazy",
    opts = {
      ensure_installed = {
        "prettier",
        "stylua",
        "eslint_d",
        "golangci-lint",
        "shellcheck",
        "yamllint",
        "buf",
        "shfmt",
        "yamlfmt",
        "black",
        "markdownlint-cli2",
      },
    },
  },
}
