local xml = require("xml-generator")

return xml.style {
    [{"h1", "h2", "h3", "h4", "h5", "h6"}] = {
        ["font-family"] = "sans-serif"
    };

    ["table"] = {
        ["font-family"] = { "arial", "sans-serif" };
        ["border-collapse"] = "collapse";
        -- ["border"] = "2px solid black";
        ["table-layout"] = "fixed";
        ["width"] = "100%";
    };

    ["p"] = {
        ["font-family"] = { "arial", "sans-serif" };
    };

    ["tr:nth-child(even)"] = {
        ["background-color"] = "#dddddd";
    };

    -- ["div"] = {
    --     ["border-radius"] = "5px";
    --     ["background-color"] = "#f2f2f2";
    --     ["padding"] = "20px";
    -- };

    ["input[type=submit]"] = {
        ["background-color"] = "#4CAF50";
        ["border"] = "none";
        ["color"] = "white";
        ["padding"] = "15px 32px";
        ["text-align"] = "center";
        ["text-decoration"] = "none";
        ["display"] = "inline-block";
        ["font-size"] = "16px";
        ["margin"] = "4px 2px";
        ["cursor"] = "pointer";
    };

    ["input[type=checkbox]"] = {
        ["width"] = "20px";
        ["height"] = "20px";
    };
}

