return {
    name = "Portfolio",
    version = "0.1.0",
    description = "A simple description of my little package.",
    tags = { "lua", "lit", "luvit" },
    license = "GPLv3",
    author = { name = "Amrit Bhogal", email = "ambhogal01@gmail.com" },
    homepage = "https://github.com/Frityet/Portfolio",
    dependencies = {
        "creationix/weblit"
    },
    files = {
        "**.lua",
        "!.luarocks/",
        "!test*"
    }
}