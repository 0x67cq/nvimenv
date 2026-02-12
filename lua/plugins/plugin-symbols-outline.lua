--[[ 打开大纲: 按 <leader>o。
浏览代码:
右侧会出现一个树状图，列出当前文件的所有函数、结构体、变量。
随着你在左侧代码里移动光标，右侧大纲会自动高亮你所在的函数（Autofocus）。
快速跳转:
在右侧大纲里按 Enter，左侧代码直接跳过去。
操作:
在函数名上按 r 可以直接重命名（Rename）。
在函数名上按 a 可以触发代码操作（Code Action）� ]]


return {
    {
        "hedyhli/outline.nvim",

        lazy = true,
        cmd = { "SymbolsOutline", "SymbolsOutlineOpen" },
        keys = {
            -- [懒加载] 按下 <leader>o 才加载插件
            { "<leader>o", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" },
        },
        config = function()
            require("configs.coding.symbols-outline")
        end,
    },
}
