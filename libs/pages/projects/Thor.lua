---@diagnostic disable: undefined-global

local link = lua.require("utilities").html.link

return {
    description = div {
        p { "Program to manage mods found on ", link["Thunderstore"]("https://thunderstore.io"), " for many games" };
        p { "Written in Objective C using the ", link["ObjFW"]("https://objfw.nil.im"), " runtime and library" }
    },
    repository_link = "https://github.com/Frityet/Thor"
}
