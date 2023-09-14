local xml_gen = require("xml-generator")
local default_style = require("pages/default-style")
local utilities = require("utilities")

local url = utilities.html.link


return xml_gen.declare_generator(function (app)
---@diagnostic disable: undefined-global
    return html {charset="utf8", lang="en"} {
        head {
            title "My Portfolio";
            default_style;
            link {href="style.css", rel="stylesheet"};
        };

        body {
            h1 "Amrit's Portfolio";
            p {"Check out my ", url["projects"]("/projects"), " list!"};
            div {
                h2 "Info:";
                utilities.html.tree(app)
            }
        }
    }
---@diagnostic enable: undefined-global
end)
