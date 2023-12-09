#!/usr/bin/env ./lua
-- Copyright (C) 2023 Amrit Bhogal
--
-- This file is part of Portfolio.
--
-- Portfolio is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- Portfolio is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with Portfolio.  If not, see <http://www.gnu.org/licenses/>.

local vernum = _VERSION:match("%d+%.%d+")
package.path = ("?.lua;?/init.lua;lua_modules/share/lua/%s/?.lua;lua_modules/share/lua/%s/?/init.lua;"):format(vernum, vernum)--..package.path
package.cpath = ("lua_modules/lib/lua/%s/?.so;lua_modules/lib/lua/%s/?/init.so;"):format(vernum, vernum)--..package.cpath

local xml_gen = require("xml-generator")
local Path = require("Path")
local pprint = require("pprint")

local cwd = Path.current_directory
local site_dir, css_dir, build_dir = cwd/"static", cwd/"style", cwd/"build"

--turn off GC, its too slow
collectgarbage("stop")

---@type Path
local file_to_compile do
    if arg[1] then
        file_to_compile = Path.new(arg[1])
        if not file_to_compile:exists() then
            return --for watch mode
        end
        file_to_compile = assert(file_to_compile:relative_to(cwd))
    end
end

---@type _G
_G.lua = nil
_G.yield = coroutine.yield

local l_error = error
_G.error = function (msg)
    local time = os.date("%H:%M:%S")
    if not msg then
        msg = debug.traceback("Unknown error", 2)
    end

    io.stderr:write(string.format("\x1b[31m[%s] %s\x1b[0m\n", time, msg))
    os.exit(1)
end

local l_assert = assert
_G.assert = function (cond, msg)
    if not cond then error(debug.traceback(msg)) end
    return cond
end

local function log(...)
    local time = os.date("%H:%M:%S")
    print("\x1b[36m["..time.."]\x1b[0m ".. ... .."\x1b[0m")
end

---@param file Path
---@param to Path
local function compile_html(file, to)
    if not file:exists() then error("File does not exist: "..tostring(file)) end
    log("\x1b[33mCompiling \x1b[34m"..tostring(file).."\x1b[33m to \x1b[34m"..tostring(to:relative_to(cwd)).."\x1b[0m")
    local time = os.clock()


    local gen_fn, err = loadfile(tostring(file), "t", setmetatable({ require = require, yield = yield }, { __index = xml_gen.xml }))
    if not gen_fn then error(err) end
    ---@type boolean, XML.Node
    local ok, contents = pcall(gen_fn)
    if not ok then error(contents) end
    ---@type file*
    local f = nil
    if to:exists() then f = assert(io.open(tostring(to), "w+"))
    else f = assert(to:create("file", "w+")) --[[@as file*]] end

    f:write(tostring(contents))
    f:close()
    log("\x1b[32mDone\x1b[0m, \x1b[33mtook "..(os.clock() - time).." seconds\x1b[0m")
end

---@param file Path
---@param to Path
local function compile_css(file, to)
    log("\x1b[33mCompiling \x1b[34m"..tostring(file).."\x1b[33m to \x1b[34m"..tostring(to:relative_to(cwd)).."\x1b[0m")
    local time = os.clock()

    --First child is the actual CSS string, so get that
    ---@diagnostic disable-next-line: invisible
    local contents = xml_gen.style(assert(dofile(tostring(file)))).children[1]

    ---@type file*
    local f = nil
    if not to:exists() then f = assert(to:create("file", "w+")) --[[@as file*]]
    else f = assert(io.open(tostring(to), "w+")) end

    f:write(tostring(contents))
    f:close()
    log("\x1b[32mDone\x1b[0m, \x1b[33mtook "..(os.clock() - time).." seconds\x1b[0m")
end

if file_to_compile then
    if file_to_compile:parent_directory():name() ~= "static" and file_to_compile:parent_directory():name() ~= "style" then
        return --pass
    end

    local is_css = false
    --if it is in the `style` directory, then it is a CSS file
    if file_to_compile:pop(1, true) == css_dir:relative_to(cwd) then is_css = true end

    local dest = build_dir
    dest = dest/file_to_compile:pop(1)
    dest = dest:remove_extension()
    if is_css then
        dest = dest:add_extension("css")
        compile_css(file_to_compile, dest)
    else
        dest = dest:add_extension("html")
        compile_html(file_to_compile, dest)
    end

    return
end

for file in site_dir:find(".*%.lua$") do
    file = assert(file:relative_to(cwd))
    local dest = build_dir
    dest = dest/file:pop(1) --remove the `site/`
    dest = dest:remove_extension() --remove .lua
    dest = dest:add_extension("html") --add .html
    compile_html(file, dest)
end

for file in css_dir:find(".*%.lua$") do
    file = assert(file:relative_to(cwd))
    local dest = build_dir
    dest = dest/file:pop(1)
    dest = dest:remove_extension()
    dest = dest:add_extension("css")
    compile_css(file, dest)
end
