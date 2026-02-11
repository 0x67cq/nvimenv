--[[ 常用操作流
    唤出：按下 <Leader>e (我们在 plugins/plugin-nvim-tree.lua 里配的)。
        屏幕中间弹出一个框。
    导航：
        j / k：上下移动。
        l 或 Enter：进入文件夹 / 打开文件。
        h：收起当前文件夹 / 回到上一级目录。
    文件管理 (光标在目标位置按键)：
        a (Create): 新建。输入 components/Button.svelte 可直接创建目录和文件。
        r (Rename): 重命名。
        d (Delete): 删除。
        y: 复制文件名。
        gy: 复制绝对路径。
    关闭：
        再次按 <Leader>e。
        按 q。
        或者直接点击浮窗以外的区域（因为我加了 quit_on_focus_loss）。
 ]]
local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
	return
end

-- [按键映射] 仅在 NvimTree 窗口内生效
local function on_attach(bufnr)
	local api = require("nvim-tree.api")

	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	-- 默认映射：先加载默认的，再覆盖
	api.config.mappings.default_on_attach(bufnr)

	-- [自定义映射] Ranger 风格导航
	vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
	vim.keymap.set("n", "o", api.node.open.edit, opts("Open"))
	vim.keymap.set("n", "<2-LeftMouse>", api.node.open.edit, opts("Open"))
	vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
	vim.keymap.set("n", "<C-v>", api.node.open.vertical, opts("Open: Vertical Split"))
	vim.keymap.set("n", "<C-x>", api.node.open.horizontal, opts("Open: Horizontal Split"))
end

nvim_tree.setup({
	-- [核心设置]
	disable_netrw = true,
	hijack_netrw = true,
	sync_root_with_cwd = true, -- [新版] 自动同步根目录

	-- [外观设置]
	renderer = {
		root_folder_label = false, -- 不显示根目录长路径，简洁
		icons = {
			glyphs = {
				git = {
					unstaged = "",
					staged = "S",
					unmerged = "",
					renamed = "➜",
					deleted = "",
					untracked = "U",
					ignored = "◌",
				},
			},
		},
	},

	-- [诊断显示] 文件名旁显示错误图标
	diagnostics = {
		enable = true,
		show_on_dirs = true,
		icons = {
			hint = "",
			info = "",
			warning = "",
			error = "",
		},
	},

	-- [自动聚焦] 切换文件时，树自动定位到该文件
	update_focused_file = {
		enable = true,
		update_root = true,
	},

	-- [过滤规则]
	filters = {
		dotfiles = false, -- false = 显示点文件 (.env, .gitignore)
		custom = { ".git", "node_modules", ".cache" }, -- 彻底隐藏这些文件夹
	},

	-- [Git 集成]
	git = {
		enable = true,
		ignore = true, -- true = 变暗或隐藏 .gitignore 里的文件
	},

	-- [视图设置] 浮窗模式 (你原本的偏好)
	view = {
		width = 30,
		side = "left", -- 如果 float.enable = false，则靠左显示

		-- 浮窗配置
		float = {
			enable = true, -- 开启浮窗
			quit_on_focus_loss = true, -- [新增] 点击外部自动关闭
			open_win_config = function()
				local columns = vim.o.columns
				local lines = vim.o.lines
				local width = math.max(math.floor(columns * 0.5), 50)
				local height = math.max(math.floor(lines * 0.5), 20)
				local left = math.ceil((columns - width) * 0.5)
				local top = math.ceil((lines - height) * 0.5 - 2)
				return {
					relative = "editor",
					border = "rounded",
					width = width,
					height = height,
					row = top,
					col = left,
				}
			end,
		},
	},

	-- [操作行为]
	actions = {
		open_file = {
			quit_on_open = true, -- [建议] 打开文件后自动关闭浮窗，体验更像 Command Palette
			resize_window = true,
			window_picker = {
				enable = true,
			},
		},
	},
})
