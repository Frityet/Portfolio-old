package.path = package.path..";lua_modules/share/lua/5.1/?.lua;lua_modules/share/lua/5.1/?/init.lua"
package.cpath = package.cpath..";lua_modules/lib/lua/5.1/?.so"

local weblit = require("weblit-app")
local pages = require("pages")

local app = weblit.bind {
    host = "0.0.0.0",
    port = 8080
}

app.use(require("weblit-logger"))
-- app.use(require("weblit-auto-headers"))

---@type { string : string }
local page_cache = {}

for name, page in pairs(pages) do
    if type(page) == "function" then
        p("Function page /"..name)
        app.route({
            method = "GET",
            path = "/"..name,
        }, function (req, res, go)
            res.code = 200
            res.headers["Content-Type"] = "text/html"
            res.body = tostring(page { request = req, result = res })

            return go()
        end)
    else
        p("Static page /"..name)
        if not page_cache[name] then page_cache[name] = tostring(page) end
        app.route({
            method = "GET",
            path = "/"..name
        }, function (req, res, go)
            res.code = 200
            res.headers["Content-Type"] = "text/html"
            res.body = page_cache[name]
        end)
    end
end

app.start()
