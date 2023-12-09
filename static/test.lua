---@diagnostic disable: undefined-global
return html {charset="utf8", lang="en"} {
    head {
        title "Test page";

        meta {name="viewport", content="width=device-width, initial-scale=1"};

        link {rel="stylesheet", href="style/index.css"};
    };

    body {
        h1 "This is a test page";

        function()
            for i = 1, 10 do
                yield(p "This is a test paragraph")
            end
        end
    }
}
