local xml_gen = require("xml-generator")
local xml = xml_gen.xml
local yield = coroutine.yield

return xml_gen.component(function (args)
    local date_format = args.date_format or "%A, %B %d, %Y"
    local time_format = args.time_format or "%H:%M:%S"
    args.date_format = nil
    args.time_format = nil

    local date = os.date(date_format)
    local time = os.date(time_format)

    yield(xml.span(args) {date})
    yield(xml.br(args))
    yield(xml.span(args) {time})
end)
