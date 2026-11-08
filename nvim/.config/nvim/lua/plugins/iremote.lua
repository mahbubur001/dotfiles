-- iRemote: PhpStorm-style deployment (SFTP/FTP/FTPS/WebDAV), sharing .vscode/iremote.json with the VS Code extension.
-- Installed from GitHub; with `dev = true` lazy.nvim uses the local checkout at ~/dev/iremote instead when it exists
-- (see `dev` in config/lazy.lua), so changes made there are live without pushing.
return {
  "mahbubur001/iremote",
  name = "iremote",
  dev = true,
  build = "npm ci && npm run build",
  event = { "BufReadPost", "BufNewFile" },
  cmd = "IRemote",
  opts = {},
  keys = {
    { "<leader>dm", function() require("iremote").menu() end, desc = "iRemote menu" },
    { "<leader>de", function() require("iremote").settings() end, desc = "Deployment settings" },
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
