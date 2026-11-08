-- iRemote: PhpStorm-style deployment (SFTP/FTP/FTPS/WebDAV), sharing .vscode/iremote.json with the VS Code extension.
-- Local checkout of https://github.com/mahbubur001/iremote; skipped on machines without it.
local dir = vim.fn.expand("~/dev/iRemote")

return {
  dir = dir,
  name = "iremote",
  cond = vim.fn.isdirectory(dir) == 1,
  build = "npm ci && npm run build",
  event = { "BufReadPost", "BufNewFile" },
  cmd = "IRemote",
  opts = {},
  keys = {
    { "<leader>du", function() require("iremote").upload() end, desc = "Upload to default server" },
    { "<leader>dd", function() require("iremote").download() end, desc = "Download from default server" },
    { "<leader>dc", function() require("iremote").compare() end, desc = "Compare with deployed version" },
    { "<leader>ds", function() require("iremote").select_server() end, desc = "Select default server" },
    { "<leader>da", function() require("iremote").set_auto_upload() end, desc = "Automatic upload mode" },
    { "<leader>db", function() require("iremote").open_in_browser() end, desc = "Open in browser" },
    { "<leader>dl", function() require("iremote").show_log() end, desc = "Transfer log" },
    { "<leader>dx", function() require("iremote").cancel() end, desc = "Cancel transfers" },
    { "<leader>dr", function() require("iremote").remote_browser() end, desc = "Remote Host" },
    { "<leader>dS", function() require("iremote").sync() end, desc = "Sync with deployed" },
    { "<leader>di", function() require("iremote").import_phpstorm() end, desc = "Import PhpStorm deployment" },
  },
}
