---@diagnostic disable: undefined-global

local link = lua.require("utilities").html.link

return {
    description = div {
        p "This is a portfolio website for Amrit (Frityet).";
        p {"It is written in Lua, using the ", link["Luvit"]("https://luvit.io"), " runtime."};
        p {"It uses a ", link["custom Lua -> XML DSL"]("https://github.com/Frityet/LuaXMLGenerator"), " to generate HTML and CSS"};
        p "No Javascript!";
    },
    repository_link = "https://github.com/Frityet/Portfolio"
}


