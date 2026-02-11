local status_ok, comment = pcall(require, "Comment")
if not status_ok then
	return
end

comment.setup({
	-- [核心功能] 集成 Treesitter 上下文
	-- 效果：在 Svelte 的 script 标签里按 <leader>c 它是 //
	--       在 Svelte 的 div 标签里按 <leader>c 它是 pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),

	-- 忽略空行
	ignore = "^$",

	-- [自定义快捷键]
	toggler = {
		-- 普通模式下，注释当前行
		line = "<leader>c",
		-- block = "gbc", -- 块注释推荐保留默认 gbc
	},

	opleader = {
		-- Visual 模式下，注释选区
		-- line = "gc",
		block = "<leader>cc", -- 块注释选区
	},

	-- 默认映射配置 (如果你想完全自定义，可以把下面设为 false)
	mappings = {
		basic = true,
		extra = true,
	},
})

-- 关于 Ctrl+/ 的说明：
-- 绝大多数终端（iTerm2, Alacritty 等）无法正确发送 <C-/> 信号，它们发送的是 <C-_>。
-- 如果你非常想要 Ctrl+/，可以使用下面这行黑魔法：
-- vim.keymap.set("n", "<C-_>", require("Comment.api").toggle.linewise.current, { desc = "Toggle Comment" })
-- vim.keymap.set("v", "<C-_>", "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", { desc = "Toggle Comment" })
