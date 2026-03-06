local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
	return
end

local actions = require("telescope.actions")
local previewers = require("telescope.previewers")
local Job = require("plenary.job")

-- [高级功能] 防止预览二进制文件导致卡死
local new_maker = function(filepath, bufnr, opts)
	filepath = vim.fn.expand(filepath)
	Job:new({
		command = "file",
		args = { "--mime-type", "-b", filepath },
		on_exit = function(j)
			local mime_type = vim.split(j:result()[1], "/")[1]
			if mime_type == "text" then
				previewers.buffer_previewer_maker(filepath, bufnr, opts)
			else
				vim.schedule(function()
					vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "BINARY FILE" })
				end)
			end
		end,
	}):sync()
end

-- [按键映射表]
local m = {
	cycle_history_next = "<C-j>",
	cycle_history_prev = "<C-k>",
	move_selection_next = "<C-n>",
	move_selection_previous = "<C-p>",
	close = "<C-c>",
	n_close = "<esc>",
	select_default = "<CR>",
	select_horizontal = "<C-x>",
	select_vertical = "<C-v>",
	preview_scrolling_up = "<C-u>",
	preview_scrolling_down = "<C-d>",
}

-- [全局启动快捷键]
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("n", "<leader>fb", ":Telescope buffers <CR>", opts)
keymap("n", "<leader>ff", ":Telescope find_files <CR>", opts)
keymap("n", "<leader>fa", ":Telescope find_files follow=true no_ignore=true hidden=true <CR>", opts)
keymap("n", "<leader>gm", ":Telescope git_commits <CR>", opts)
keymap("n", "<leader>gs", ":Telescope git_status <CR>", opts)
keymap("n", "<leader>fh", ":Telescope help_tags <CR>", opts)
keymap("n", "<leader>fw", ":Telescope live_grep <CR>", opts)
keymap("n", "<leader>fo", ":Telescope oldfiles <CR>", opts)
keymap("n", "<leader>pm", ":lua require'telescope'.extensions.project.project{}<CR>", opts)

-- 搜索光标下的单词
keymap(
	"n",
	"<leader>fg",
	":lua require('telescope.builtin').grep_string({search = vim.fn.expand('<cword>')})<CR>",
	opts
)

-- Telescope 主配置
telescope.setup({
	-- 1. 默认配置
	defaults = {
		buffer_previewer_maker = new_maker,
		prompt_prefix = " ",
		selection_caret = " ",
		entry_prefix = "  ",
		initial_mode = "insert",

		-- UI 视觉优化：保留圆角和真彩色
		winblend = 0,
		border = {},
		borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
		color_devicons = true,
		set_env = { ["COLORTERM"] = "truecolor" },
		path_display = { shorten = { len = 3, exclude = { 1, -1 } } },

		-- 搜索参数优化：忽略 node_modules 防止搜索过慢
		file_ignore_patterns = { "node_modules", "dist", ".git" },
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
			"--hidden",
			"--glob=!.git/",
		},

		-- 弹窗内快捷键：Insert 和 Normal 模式对齐
		mappings = {
			i = {
				[m.cycle_history_next] = actions.cycle_history_next,
				[m.cycle_history_prev] = actions.cycle_history_prev,
				[m.move_selection_next] = actions.move_selection_next,
				[m.move_selection_previous] = actions.move_selection_previous,
				[m.close] = actions.close,
				[m.select_default] = actions.select_default,
				[m.select_horizontal] = actions.select_horizontal,
				[m.select_vertical] = actions.select_vertical,
				[m.preview_scrolling_up] = actions.preview_scrolling_up,
				[m.preview_scrolling_down] = actions.preview_scrolling_down,
				["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
			},
			n = {
				[m.n_close] = actions.close,
				[m.select_default] = actions.select_default,
				[m.select_horizontal] = actions.select_horizontal,
				[m.select_vertical] = actions.select_vertical,
				-- 【关键优化】在 Normal 模式下也能用 Ctrl 键上下移动和滚动预览
				[m.move_selection_next] = actions.move_selection_next,
				[m.move_selection_previous] = actions.move_selection_previous,
				[m.preview_scrolling_up] = actions.preview_scrolling_up,
				[m.preview_scrolling_down] = actions.preview_scrolling_down,
				["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
			},
		},
	},

	-- 2. 界面选择器配置 (修复了层级，如果你喜欢居中大窗口，把 theme 注释掉即可)
	pickers = {
		find_files = {
			-- theme = "dropdown",  -- 注释掉这两行，使用默认带预览的居中大窗口，体验往往更好
			-- previewer = false,
			find_command = { "fd", "--type=file", "--hidden", "--smart-case" },
		},
		live_grep = {
			only_sort_text = true,
			-- theme = "ivy",       -- 同理，注释掉以使用居中大窗口
		},
	},

	-- 3. 扩展插件配置
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
		project = {
			base_dirs = { "~/syncnote" },
			hidden_files = true,
			theme = "dropdown",
			order_by = "asc",
			sync_with_nvim_tree = true,
		},
	},
})

-- 加载扩展
pcall(telescope.load_extension, "fzf")
pcall(telescope.load_extension, "project")
