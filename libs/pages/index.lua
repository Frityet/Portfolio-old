local xml_gen = require("xml-generator")
local default_style = require("pages/default-style")
local utilities = require("utilities")

local weblit = require("weblit")

---@param app any
---@return XML.Node
return function (app)
    return xml_gen.generate_node(function (xml)
        return xml.html {charset="utf8", lang="en"} {
            xml.head {
                xml.title "Amrit's Portfolio";
                default_style;
                xml.link {href="style.css", rel="stylesheet"}
            };

            xml.body {
                xml.h1 "Amrit's Portfolio";

                xml.p {"Check out my ", xml.a {href="/projects"} "Projects", " list!"};

                xml.div {
                    xml.h2 "Info:";
                    -- xml_gen.html_table(app);
                    utilities.html.tree(weblit)
                }
            }
        }
    end)
end
