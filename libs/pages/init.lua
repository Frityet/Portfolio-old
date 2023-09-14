---@type { string : XML.Node | fun(app: any): XML.Node }
local pages = {
    [""] = require("pages/index");
    ["projects"] = require("pages/projects")
}

return pages
