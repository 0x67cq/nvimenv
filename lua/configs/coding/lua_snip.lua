local present, luasnip = pcall(require, "luasnip")
if not present then
	return
end

-- [1] 基础配置
luasnip.config.set_config({
	history = true, -- 允许你在跳出片段后，还能跳回来 (比如改了其他东西后想改参数)
	updateevents = "TextChanged,TextChangedI", -- 实时更新动态片段
})

-- [2] 加载 VSCode 格式的片段 (依赖 friendly-snippets)
require("luasnip.loaders.from_vscode").lazy_load()

-- [3] 关键：Svelte/前端 增强配置
-- 让 Svelte 文件能使用 html, javascript 和 css 的片段
luasnip.filetype_extend("svelte", { "html", "javascript", "css" })

-- 让 TypeScript 能使用 JavaScript 的片段
luasnip.filetype_extend("typescript", { "javascript" })

-- 让 Vue 能使用 html/js
luasnip.filetype_extend("vue", { "html", "javascript" })

-- [4] 自定义 Lua 片段加载器 (可选)
-- 如果你以后想在 lua/snippets/ 目录下写自己的 lua 格式片段，取消下面注释
require("luasnip.loaders.from_lua").load({ paths = "./lua/snippets" })
