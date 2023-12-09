return {
    ["*"] = {
        ["font-family"] = "sans-serif",
        -- ["font-size"] = "14px",
        ["line-height"] = "1.5",
        ["color"] = "#333",
        ["background-color"] = "#fff",
        ["-webkit-font-smoothing"] = "antialiased",
        ["-moz-osx-font-smoothing"] = "grayscale",
    },

    [".tree"] = {
        ["font-family"] = "monospace",
        ["font-size"] = "14px",
        ["line-height"] = "1.5",
        ["color"] = "#333",
        ["background-color"] = "#fff",
        ["-webkit-font-smoothing"] = "antialiased",
        ["-moz-osx-font-smoothing"] = "grayscale",
    },

    [".tree-node"] = {
        ["margin-left"] = "1em",
        --border to make it easier to see the tree
        ["border"] = "1px solid #ccc",
        ["border-radius"] = "3px",
        ["padding"] = "0.5em",
    },

    [".tree-node-summary"] = {
        ["cursor"] = "pointer",
    },

    [".tree-node-value"] = {
        ["margin-left"] = "1em",
    }
}
