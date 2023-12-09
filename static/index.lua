---@diagnostic disable: undefined-global

local xml_gen = require("xml-generator")
local datetime = require("components.datetime")
local section = require("components.section")
local tree = require("components.tree")

local sample_data = {
    foo="bar",
    baz="qux",
    quux="quuz",
    corge="grault",
    garply="waldo",
    fred="plugh",
    xyzzy="thud",
    sub = {
        foo="bar",
        baz="qux",
        quux="quuz",
        corge="grault",
        garply="waldo",
        fred="plugh",
        xyzzy="thud",
        sub = {
            foo="bar",
            baz="qux",
            quux="quuz",
            corge="grault",
            garply="waldo",
            fred="plugh",
            xyzzy="thud",
            sub = {
                foo="bar",
                baz="qux",
                quux="quuz",
                corge="grault",
                garply="waldo",
                fred="plugh",
                xyzzy="thud",
                sub = {
                    foo="bar",
                    baz="qux",
                    quux="quuz",
                    corge="grault",
                    garply="waldo",
                    fred="plugh",
                    xyzzy="thud",
                    sub = {
                        foo="bar",
                        baz="qux",
                        quux="quuz",
                        corge="grault",
                        garply="waldo",
                        fred="plugh",
                        xyzzy="thud",
                        sub = {
                            foo="bar",
                            baz="qux",
                            quux="quuz",
                            corge="grault",
                            garply="waldo",
                            fred="plugh",
                            xyzzy="thud",
                            sub = {
                                foo="bar",
                                baz="qux",
                                quux="quuz",
                                corge="grault",
                                garply="waldo",
                                fred="plugh",
                                xyzzy="thud",
                                sub = {
                                    foo="bar",
                                    baz="qux",
                                    quux="quuz",
                                    corge="grault",
                                    garply="waldo",
                                    fred="plugh",
                                    xyzzy="thud",
                                    sub = {
                                        foo="bar",
                                        baz="qux",
                                        quux="quuz",
                                        corge="grault",
                                        garply="waldo",
                                        fred="plugh",
                                        xyzzy="thud",
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

return html {charset="utf8", lang="en"} {
    head {
        title "Hello, World!";

        meta {name="viewport", content="width=device-width, initial-scale=1"};
        link {rel="stylesheet", href="index.css"};
    };

    body {
        section {title="Hello, World!"} {
            section {title="Here is the current date (at compile time):", header_size=2} {
                datetime {date_format="%d %B, %Y", time_format="%H:%M:%S"};

                tree {data={sample_data}, class="tree"};
            };
        }

    }
}
