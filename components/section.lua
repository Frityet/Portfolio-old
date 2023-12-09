local xml_gen = require("xml-generator")
local xml = xml_gen.xml
local yield = coroutine.yield

return xml_gen.component(function (args, children)
    local title = assert(args.title, "section component requires a title")
    local header_size = args.header_size or 1
    args.title = nil
    args.header_size = nil

    if header_size < 1 or header_size > 6 then
        error("header_size must be between 1 and 6")
    end

    local title_formatted = title:gsub("%s+", "-"):gsub("[^%w%-]", ""):lower()
    args.id = "section-"..title_formatted.."-header"
    yield(xml["h"..header_size](args){title})
    if #children > 0 then
        yield(xml.div {class="section-body", id="section-"..title_formatted}{children})
    end
end)
