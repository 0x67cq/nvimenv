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
	-- 历史记录
	cycle_history_next = "<C-j>",
	cycle_history_prev = "<C-k>",
	-- 上下移动 (列表内)
	move_selection_next = "<C-n>",
	move_selection_previous = "<C-p>",
	-- 关闭
	close = "<C-c>",
	n_close = "<esc>",
	-- 选择
	select_default = "<CR>",
	select_horizontal = "<C-x>",
	select_vertical = "<C-v>",
	-- 滚动预览窗口
	preview_scrolling_up = "<C-u>",
	preview_scrolling_down = "<C-d>",
}

-- [全局启动快捷键]
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("n", "<leader>fb", ":Telescope buffers <CR>", opts) -- 找已打开的 Buffer
keymap("n", "<leader>ff", ":Telescope find_files <CR>", opts) -- 找文件
keymap("n", "<leader>fa", ":Telescope find_files follow=true no_ignore=true hidden=true <CR>", opts) -- 找所有文件(含隐藏)
keymap("n", "<leader>gm", ":Telescope git_commits <CR>", opts) -- Git 提交记录
keymap("n", "<leader>gs", ":Telescope git_status <CR>", opts) -- Git 状态
keymap("n", "<leader>fh", ":Telescope help_tags <CR>", opts) -- 查帮助文档
keymap("n", "<leader>fw", ":Telescope live_grep <CR>", opts) -- 全局搜索文字
keymap("n", "<leader>fo", ":Telescope oldfiles <CR>", opts) -- 最近打开的文件
keymap("n", "<leader>pm", ":lua require'telescope'.extensions.project.project{}<CR>", opts) -- 项目管理

-- 搜索光标下的单词
keymap(
	"n",
	"<leader>fg",
	":lua require('telescope.builtin').grep_string({search = vim.fn.expand('<cword>')})<CR>",
	opts
)

telescope.setup({
	-- 1. 默认配置
	defaults = {
		buffer_previewer_maker = new_maker, -- 挂载防卡死预览器
		prompt_prefix = " ",
		selection_caret = " ",
		entry_prefix = "  ",
		initial_mode = "insert",

		-- 搜索参数 (ripgrep)
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
			"--hidden", -- 搜索隐藏文件
			"--glob=!.git/", -- 排除 .git 目录
		},

		-- 弹窗内快捷键
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
			},
		},

		file_ignore_patterns = { "node_modules", "dist", ".git" },
		path_display = { shorten = { len = 3, exclude = { 1, -1 } } }, -- 路径缩短显示 a/b/c/filename
		winblend = 0,
		border = {},
		color_devicons = true,
	},

	-- 2. 界面选择器配置 (独立于 defaults)
	pickers = {
		find_files = {
			theme = "dropdown",
			previewer = false, -- 找文件时不预览，速度更快
			find_command = { "fd", "--type=file", "--hidden", "--smart-case" },
		},
		live_grep = {
			only_sort_text = true,
			theme = "ivy", -- 搜索文字时建议用 ivy 主题（底部面板），能看到更多预览内容
		},
	},

	-- 3. 扩展插件配置 (独立于 defaults)
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
		project = {
			base_dirs = {
				"~/syncnote", -- 你的项目根目录
				-- "~/workspace", -- 可以加更多
			},
			hidden_files = true,
			theme = "dropdown",
			order_by = "asc",
			sync_with_nvim_tree = true, -- 打开项目时自动同步左侧文件树
		},
	},
})

-- 加载扩展
pcall(telescope.load_extension, "fzf")
pcall(telescope.load_extension, "project")
