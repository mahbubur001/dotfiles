local util = require("util")

require("kommentary.config").configure_language("default", {
    prefer_single_line_comments = true
})

util.nmap("<leader>/", "<Plug>kommentary_line_default")
util.vmap("<leader>/", "<Plug>kommentary_visual_default")
