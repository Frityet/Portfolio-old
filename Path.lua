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

---@diagnostic disable-next-line: deprecated
local unpack = unpack or table.unpack

local lfs = require("lfs")

local is_windows = package.config:sub(1, 1) == "\\"

---@class Path
---@field parts string[]
---@field current_directory Path
---@operator div(string|Path): Path
---@operator sub(number): Path
local Path = {}
Path.__index = Path

---@param path string
---@param ... string
---@return Path
function Path.new(path, ...)
    local parts = {}
    if path:sub(1, 1) == "/" or path:sub(1, 1) == "\\" then parts = { "/" } end

    for part in path:gmatch("[^/\\]+") do
        table.insert(parts, part)
    end
    for _, part in ipairs({...}) do
        table.insert(parts, part)
    end
    return setmetatable({ parts = parts }, Path)
end

---@return boolean
function Path:exists()
    local mode = self:type()
    return mode == "directory" or mode == "file"
end

function Path:type() return (lfs.attributes(tostring(self), "mode")) end

---@private
---@return boolean, string?
function Path:create_directory()
    local path = ""
    for _, part in ipairs(self.parts) do
        path = path..part.."/"

        local mode = lfs.attributes(path, "mode")
        if mode == nil then
            local ok, err = lfs.mkdir(path)
            if not ok then return false, err end
        elseif mode ~= "directory" then
            return false, "Path \""..path.."\" is not a directory"
        end
    end
    return true
end

---@overload fun(self: Path, type: "file", mode: openmode?): file*, string?
---@param type "directory"
---@return boolean | file*, string?
function Path:create(type, mode)
    if type == "directory" then return self:create_directory()
    elseif type == "file" then
        mode = mode or "w"
        local ok, err = (self - 1):create_directory()
        if not ok then return false, err end

        local file, err = io.open(tostring(self), mode)
        if not file then return false, err end

        return file
    else return false, "Invalid type \""..type.."\"" end
end

---@private
---@param path string | Path
---@return Path
function Path:__div(path)
    if type(path) == "table" then return Path.new(tostring(self), unpack(path.parts)) end
    --[[@cast path string]]

    local parts = {}
    for part in path:gmatch("[^/\\]+") do
        table.insert(parts, part)
    end

    return Path.new(tostring(self), unpack(parts))
end

---@private
---@param other Path
---@return boolean
function Path:__eq(other)
    if #self.parts ~= #other.parts then return false end
    for i = 1, #self.parts do
        if self.parts[i] ~= other.parts[i] then return false end
    end
    return true
end

---Removes `n` parts from the end of the path
---@param n number
---@param from_back boolean?
---@return Path
function Path:pop(n, from_back)
    local parts = {}
    if not from_back then
        for i = n + 1, #self.parts do table.insert(parts, self.parts[i]) end
    else
        for i = 1, #self.parts - n do table.insert(parts, self.parts[i]) end
    end
    return Path.new(unpack(parts))
end

---@return fun(): Path
function Path:entries()
    return coroutine.wrap(function ()
        for entry in lfs.dir(tostring(self)) do
            if entry ~= "." and entry ~= ".." then coroutine.yield(self/entry) end
        end
    end)
end

function Path:name()
    return self.parts[#self.parts]
end

---@param pattern string
---@return fun(): Path
function Path:find(pattern)
    return coroutine.wrap(function ()
        ---@param dir Path
        local function look_in_dir(dir)
            for entry in dir:entries() do
                if entry:type() == "directory" then
                    look_in_dir(entry)
                elseif entry:type() == "file" then
                    if entry:name():find(pattern) then coroutine.yield(entry) end
                end
            end
        end

        look_in_dir(self)
    end)
end

---@return string?, string?
function Path:read_all()
    local f, err = io.open(tostring(self), "r+b")
    if not f then return nil, err end
    --[[ @cast f file* ]]
    local data = f:read("*a")
    f:close()
    return data
end

---@return string?
function Path:extension()
    local name = self.parts[#self.parts]
    local i = name:find("%.")
    if i then return name:sub(i + 1) end
end

function Path:remove_extension()
    local parts = {}
    for i = 1, #self.parts - 1 do table.insert(parts, self.parts[i]) end
    table.insert(parts, (self:name():gsub("%..*$", "")))
    return Path.new(unpack(parts))
end

---@param extension string
function Path:add_extension(extension)
    local parts = {}
    for i = 1, #self.parts - 1 do table.insert(parts, self.parts[i]) end
    table.insert(parts, self:name().."."..extension)
    return Path.new(unpack(parts))
end

---@private
Path.__sub = Path.pop

---@private
---@return string
function Path:__tostring() return table.concat(self.parts, is_windows and "\\" or "/") end

function Path.temporary_directory()
    local path = os.tmpname()
    if is_windows then path = path:sub(1, -5) end
    return Path(path)
end

function Path:copy_to(dest)
    local src = tostring(self)
    local dest = tostring(dest)

    local ok, err = lfs.link(src, dest)
    if not ok then
        local src_file, err = io.open(src, "rb")
        if not src_file then return false, err end
        --[[ @cast src_file file* ]]

        local dest_file, err = io.open(dest, "wb")
        if not dest_file then return false, err end
        --[[ @cast dest_file file* ]]

        local data = src_file:read("*a")
        dest_file:write(data)

        src_file:close()
        dest_file:close()
    end

    return true
end

function Path:remove()
    local mode = self:type()
    if mode == "directory" then
        for entry in self:entries() do
            local ok, err = entry:remove()
            if not ok then return false, err end
        end
        return lfs.rmdir(tostring(self))
    elseif mode == "file" then return os.remove(tostring(self))
    else return false, "Path \""..tostring(self).."\" is not a file or directory" end
end

function Path:move_to(dest)
    local ok, err = self:copy_to(dest)
    if not ok then return false, err end

    return self:remove()
end

---@return Path
function Path:parent_directory()
    local parts = {}
    for i = 1, #self.parts - 1 do table.insert(parts, self.parts[i]) end
    return Path.new(unpack(parts) or self.parts[1])
end

--[[
```lua
local cwd = Path.current_directory
local some_long_path = /my/current/dir/and/then/some/other/dir
local dir = some_long_path:relative_to(cwd)
print(dir) -- prints "and/then/some/other/dir"
```
]]
---@param base Path
---@return Path?, string?
function Path:relative_to(base)
    local base_parts = base.parts
    local self_parts = self.parts

    local i = 1
    while i <= #base_parts and i <= #self_parts and base_parts[i] == self_parts[i] do i = i + 1 end

    if i == #base_parts + 1 then
        local parts = {}
        for j = i, #self_parts do table.insert(parts, self_parts[j]) end
        return Path.new(unpack(parts)), nil
    end
end

-- setmetatable(Path, { __call = function(_, ...) return Path.new(...) end })
Path.current_directory = Path.new(lfs.currentdir())
return Path
