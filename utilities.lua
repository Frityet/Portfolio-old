local xml_gen = require("xml-generator")
local xml = xml_gen.xml

---@param x any
---@return type | string
local function typename(x)
    local mt = getmetatable(x)
    if mt and mt.__name then
        return mt.__name
    else
        return type(x)
    end
end

---@class utilities
local export = {

    html = {}
}

---Table -> Tree using &ltdetails&gt and &ltsummary&gt
---@param tbl table
---@return XML.Node
function export.html.tree(tbl)
    return xml.div {
        function()
            local function getval(v)
                local tname = typename(v)
                if tname == "XML.Node" then return v, false end

                if typename(v) ~= "table" or (getmetatable(v) or {}).__tostring then
                    return xml.p(tostring(v)), false
                end

                return export.html.tree(v), true
            end

            for i, v in ipairs(tbl) do
                local val, is_tree = getval(v)
                if is_tree then
                    coroutine.yield(
                        xml.details {
                            xml.summary(tostring(i)),
                            val
                        }
                    )
                else
                    coroutine.yield(
                        xml.table {
                            xml.tr {
                                xml.td(tostring(i)),
                                xml.td(val),
                            }
                        }
                    )
                end

                tbl[i] = nil
            end

            for k, v in pairs(tbl) do
                local val, is_tree = getval(v)
                if is_tree then
                    coroutine.yield(
                        xml.details {
                            xml.summary(tostring(k)),
                            val
                        }
                    )
                else
                    coroutine.yield(
                        xml.table {
                            xml.tr {
                                xml.td(tostring(k)),
                                xml.td(val),
                            }
                        }
                    )
                end
            end
        end
    }
end

---Usage:
---```lua
---link["caption"]\("url")
---```
---@type { [string] : fun(url: string): XML.Node }
export.html.link = setmetatable({}, {
    __index = function(_, caption)
        return function(url)
            return xml.a { href = url } (caption)
        end
    end
})

return export
