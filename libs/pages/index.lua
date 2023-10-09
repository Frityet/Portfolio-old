local xml_gen = require("xml-generator")
local xml = xml_gen.xml
local default_style = require("pages/default-style")
local utilities = require("utilities")

local url = utilities.html.link

return function (app)
    return xml.html {charset="utf8", lang="en"} {
        xml.head {
            xml.title "My Portfolio";
            default_style;

            xml_gen.style {
                ["details"] = {
                    ["font-family"] = "arial, sans-serif",
                    ["margin-left"] = "10px",
                    ["border-left"] = "1px solid #ccc",
                    ["padding-left"] = "5px",
                },

                ["summary"] = {
                    ["font-weight"] = "bold",
                    ["cursor"] = "pointer",
                    ["display"] = "list-item",
                    ["list-style"] = "disclosure-closed",
                },

                ["summary::-webkit-details-marker"] = {
                    ["display"] = "none",
                },

                ["details[open] summary"] = {
                    ["list-style"] = "disclosure-open",
                },

                ["div"] = {
                    ["padding"] = "2px",
                    ["margin-top"] = "2px",
                    ["margin-bottom"] = "2px",
                    ["border-radius"] = "3px",
                    ["background-color"] = "#f2f2f2",
                },

                ["details > div"] = {
                    ["margin-left"] = "10px",
                },
            };
            xml.link {href="style.css", rel="stylesheet"};
        };

        xml.body {
            xml.h1 "Amrit's Portfolio";
            xml.p {"Check out my ", url["projects"]("/projects"), " list!"};

            xml.div {
                xml.h2 "Debug:";
                utilities.html.tree(app)
            }
        }
    }
---@diagnostic enable: undefined-global
end
