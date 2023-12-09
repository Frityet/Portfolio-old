---@diagnostic disable: lowercase-global
rockspec_format = "3.0"
package = "Portfolio"
version = "dev-1"
source = {
   url = "git+https://github.com/Frityet/Portfolio.git"
}
description = {
   summary = "My portfolio",
   homepage = "https://github.com/Frityet/Portfolio",
   license = "GPLv3"
}
dependencies = {
   "lua >= 5.1",
   "luaxmlgenerator >= 1.0.0",
   "penlight",
   "luasocket",
   "luasec",
}
test_dependencies = {
   "pegasus",
   "tabular"
}
test = {
   type = "command",
   script = "serve.lua"
}
build = {
   type = "builtin",
   modules = {

   }
}
