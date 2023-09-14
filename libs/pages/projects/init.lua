local lfs = require("lfs")
local xml_gen = require("xml-generator")

local path = require("path")

---@class Project
---@field name string?
---@field description string
---@field repository_link string
---@field image { src: string, alt: string?, width: integer?, height: integer? }?

---@param xml XML.GeneratorTable
---@param project Project
---@return XML.Node
local function render_project(xml, project)
    return xml.div {class="project"} {
        xml.h2(project.name);
        type(project.description) == "table" and project.description or xml.p(project.description);
        project.image and xml.img(project.image) or xml.div {};
        xml.a {href=project.repository_link, target="_blank", class="repo-url"} "Repository";
    }
end

---@type _G
---@diagnostic disable-next-line: lowercase-global
lua = nil

return function (app)
    app.page_title = "Projects"

    local project_dir = "libs/pages/projects"

    ---@type Project[]
    local projects = {}
    for file in lfs.dir(project_dir) do
        if file:sub(1, 1) == '.' then goto next end
        if path.extname(file) ~= ".lua" then goto next end
        if file == "init.lua" then goto next end

        local fname = file:gsub(path.extname(file), "")
        local fullpath = path.join(project_dir, file)

        print("Loading "..fullpath)
        projects[#projects+1] = loadfile(fullpath, "t", xml_gen.generator_metatable)()
        projects[#projects].name = projects[#projects].name or fname
        ::next::
    end


    return xml_gen.generate_node(function (xml)
        return xml.html {charset="utf8", lang="en"} {
            xml.head {
                xml.title "Amrit's Projects";

                require("pages/default-style");

                xml_gen.style {
                    [".project-list"] = {
                        ["display"] = "flex";
                        ["flex-direction"] = "column";
                        ["gap"] = "20px";
                        ["padding"] = "20px";
                        ["border-radius"] = "5px";
                        ["background-color"] = "#f9f9f9";
                        ["font-family"] = "arial, sans-serif";
                    };

                    [".project"] = {
                        ["border"] = "5px solid #dddddd";
                        ["border-radius"] = "5px";
                        ["padding"] = "15px";
                        ["background-color"] = "#f2f2f2";
                        ["box-shadow"] = "0 4px 8px rgba(0, 0, 0, 0.1)";
                        ["font-family"] = "arial, sans-serif";
                    };

                    [".project h2"] = {
                        ["margin-top"] = "0";
                    };

                    [".project img"] = {
                        ["max-width"] = "100%";
                        ["max-height"] = "100%";
                    };

                    [".project a.repo-url"] = {
                        ["display"] = "block";
                        ["text-align"] = "left";
                        --add padding all around
                        ["padding"] = "10px";
                        ["border-radius"] = "5px";
                        ["background-color"] = "#4CAF50";
                        ["color"] = "white";
                        ["text-decoration"] = "none";
                        ["font-size"] = "16px";
                        ["font-family"] = "arial, sans-serif";
                        --only fill the width of the text
                        ["width"] = "fit-content";
                        ["margin"] = "auto";
                    };
                };
            };

            xml.body {
                xml.h1 "Projects";

                xml.div {class="project-list"} {
                    function ()
                        for _, project in ipairs(projects) do
                            coroutine.yield(render_project(xml, project))
                        end
                    end
                }
            };
        };
    end)
end
