local status_ok, gitsigns = pcall(require, "gitsigns")
if not status_ok then
	return
end

gitsigns.setup({
	-- 1. 侧边栏图标配置
	signs = {
		add = { text = "┃" },
		change = { text = "┃" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
		untracked = { text = "┆" },
	},

	-- 2. 预览窗口样式 (浮窗预览 hunk)
	preview_config = {
		border = "rounded",
		style = "minimal",
		relative = "cursor",
		row = 0,
		col = 1,
	},

	-- 3. 快捷键配置 (On Attach)
	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		-- =============================================================
		-- 导航 (Navigation)
		-- =============================================================
		-- ]c 跳到下一个修改处，[c 跳到上一个
		map("n", "]c", function()
			if vim.wo.diff then
				return "]c"
			end
			vim.schedule(function()
				gs.next_hunk()
			end)
			return "<Ignore>"
		end, { expr = true, desc = "Next Hunk" })

		map("n", "[c", function()
			if vim.wo.diff then
				return "[c"
			end
			vim.schedule(function()
				gs.prev_hunk()
			end)
			return "<Ignore>"
		end, { expr = true, desc = "Prev Hunk" })

		-- =============================================================
		-- 操作 (Actions)
		-- =============================================================
		-- <leader>ghp: 预览当前代码块在 Git 里的原始版本 (Preview)
		map("n", "<leader>ghp", gs.preview_hunk, { desc = "Preview Hunk" })

		-- <leader>ghb: 查看当前行的 Blame (谁写的，哪次提交)
		map("n", "<leader>ghb", function()
			gs.blame_line({ full = true })
		end, { desc = "Blame Line" })

		-- <leader>ghd: 查看当前文件的 Diff (Diff 模式)
		map("n", "<leader>ghd", gs.diffthis, { desc = "Diff This" })

		-- <leader>ghs: 暂存当前代码块 (Stage)
		map("n", "<leader>ghs", gs.stage_hunk, { desc = "Stage Hunk" })

		-- <leader>ghr: 撤销当前代码块的修改 (Reset)
		map("n", "<leader>ghr", gs.reset_hunk, { desc = "Reset Hunk" })

		-- Visual 模式下也可以 Stage/Reset 选中的行
		map("v", "<leader>ghs", function()
			gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end)
		map("v", "<leader>ghr", function()
			gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end)
	end,
})
