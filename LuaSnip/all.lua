-- Place this in ${HOME}/.config/nvim/LuaSnip/all.lua

local ls = require("luasnip")
local s = ls.snippet
-- local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
--local f = ls.function_node
--local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
--local fmta = require("luasnip.extras.fmt").fmta
--local rep = require("luasnip.extras").rep

return {
    -- A snippet that expands the trigger "hi" into the string "Hello, world!".
    s(
    { trig = "hi" },
    { t("Hello, pankaj!") }
    ),
    s(
    { trig = "foo" },
    { t("Another snippet.") }
    ),
    s(
    {trig="sqlx!query", dscr="Expand a sqlx query to full expression"},
    fmt(
    [[
    sqlx::query<_,$@>(r#"$@"#)
    .execute(&pool)
    .await
    ]],
    {i(1), i(2)},
    {delimiters = "$@"}
    )
    )
}


