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
   "lua ~> 5.1",
   "luaxmlgenerator ~> 0.4",
   "luafilesystem",
   "penlight"
}
build = {
   type = "builtin",
   modules = {

   }
}
