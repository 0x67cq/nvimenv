return {
	-- 1. 核心滚动条
	{
		"petertriho/nvim-scrollbar",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = {
			-- [修复] 引入 hlslens 依赖，解决报错
			"kevinhwang91/nvim-hlslens",
		},
		config = function()
			-- 先配置 hlslens (搜索增强)
			require("hlslens").setup({
				build_position_cb = function(plist, _, _, _)
					require("scrollbar.handlers.search").handler.show(plist.start_pos)
				end,
			})

			-- 搜索结束时清除滚动条高亮
			vim.cmd([[
                augroup scrollbar_search_hide
                    autocmd!
                    autocmd CmdlineLeave : lua require('scrollbar.handlers.search').handler.hide()
                augroup END
            ]])

			-- 加载你之前的 scrollbar 配置
			require("configs.editor.scrollbar")
		end,
	},
}
