local xml_gen = require("xml-generator")
local xml = xml_gen.xml
local yield = coroutine.yield

--- Using `xml.details` and `xml.summary` to create a tree representing the table
return xml_gen.component(function (args, children)
    local data = assert(args.data, "tree component requires data")
    args.data = nil

    local function render_tree(data)
        for k, v in pairs(data) do
            local tree = xml.div(args) {
                xml.details {class="tree-node"} {
                    xml.summary {class="tree-node-summary"} {k},
                    function ()
                        if xml_gen.typename(v) == "table" then
                            render_tree(v)
                        else
                            yield(xml.p {class="tree-node-value"} {tostring(v)})
                        end
                    end
                }
            }

            yield(tree)
        end
    end

    render_tree(data)
end)
