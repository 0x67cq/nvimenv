local status_ok, cmp = pcall(require, "cmp")
if not status_ok then
	return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
	return
end

-- [图标插件] 用于给补全列表加图标
local lspkind_status_ok, lspkind = pcall(require, "lspkind")
-- 建议确保 lspkind 已安装，否则补全列表会很丑

cmp.setup({
	-- [1] 片段引擎 (必须配置)
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},

	-- [2] 窗口样式 (加个边框更好看)
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},

	-- [3] 按键映射
	mapping = cmp.mapping.preset.insert({
		-- 上下选择
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-p>"] = cmp.mapping.select_prev_item(),

		-- 滚动文档 (比如看函数参数很长)
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),

		-- 显示补全菜单 (手动触发)
		["<C-Space>"] = cmp.mapping.complete(),

		-- 取消补全
		["<C-e>"] = cmp.mapping.abort(),

		-- [确认选择]
		-- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
		["<CR>"] = cmp.mapping.confirm({ select = true }),

		-- [Tab 键逻辑]
		-- 很多现代配置喜欢用 Tab 选下一个，如果你习惯 Tab 确认，可以用上面的 confirm 逻辑
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),

		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}),

	-- [4] 格式化 (外观)
	formatting = {
		expandable_indicator = true,
		fields = { "kind", "abbr", "menu" }, -- 图标, 文本, 来源
		format = lspkind_status_ok
				and lspkind.cmp_format({
					mode = "symbol_text", -- 显示 图标 + 文字
					maxwidth = 50,
					ellipsis_char = "...",
					menu = {
						nvim_lsp = "[LSP]",
						luasnip = "[Snip]",
						buffer = "[Buf]",
						path = "[Path]",
					},
				})
			or nil, -- 如果没装 lspkind 就用默认的
	},

	-- [5] 补全源 (顺序决定优先级)
	sources = cmp.config.sources({
		{ name = "nvim_lsp" }, -- 语言服务
		{ name = "luasnip" }, -- 代码片段
	}, {
		{ name = "buffer" }, -- 当前文件文字
		{ name = "path" }, -- 文件路径
	}),

	-- [6] 实验性功能: 幽灵文字
	-- 当你打字时，后面会显示灰色的预测文字
	experimental = {
		ghost_text = true,
	},
})

-- [Git] 针对 git commit 启用特定源
cmp.setup.filetype("gitcommit", {
	sources = cmp.config.sources({
		{ name = "git" },
	}, {
		{ name = "buffer" },
	}),
})

-- [Cmdline] 查找模式 /
cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

-- [Cmdline] 命令模式 :
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})
