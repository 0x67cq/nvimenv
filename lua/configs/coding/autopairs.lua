local status_ok, npairs = pcall(require, "nvim-autopairs")
if not status_ok then
	return
end

npairs.setup({
	check_ts = true, -- [核心] 开启 Treesitter 检查
	ts_config = {
		lua = { "string", "source" }, -- 在 Lua 的字符串和源码里不触发
		javascript = { "string", "template_string" }, -- 在 JS 模板字符串里不触发
		java = false, -- Java 全都检查
	},
	disable_filetype = { "TelescopePrompt", "spectre_panel" }, -- 在这些插件窗口里禁用
	fast_wrap = {
		map = "<M-e>", -- [Alt+e] 快速包裹 (高级技巧)
		chars = { "{", "[", "(", '"', "'" },
		pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
		offset = 0, -- Offset from pattern match
		end_key = "$",
		keys = "qwertyuiopzxcvbnmasdfghjkl",
		check_comma = true,
		highlight = "PmenuSel",
		highlight_grey = "LineNr",
	},
})

-- =============================================================================
-- [关键] 与 Nvim-CMP 的联动配置
-- =============================================================================
-- 如果没有这段，你补全函数时就不会自动加括号 ()
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local cmp_status_ok, cmp = pcall(require, "cmp")

if cmp_status_ok then
	-- 当确认补全(confirm_done)时，执行自动成对逻辑
	cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end
