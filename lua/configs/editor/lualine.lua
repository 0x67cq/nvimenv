local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
	return
end

local hide_in_width = function()
	return vim.fn.winwidth(0) > 80
end

-- [组件] 诊断信息
local diagnostics = {
	"diagnostics",
	sources = { "nvim_diagnostic" },
	sections = { "error", "warn" },
	symbols = { error = " ", warn = " ", info = " " },
	colored = true,
	update_in_insert = false,
	always_visible = false,
}

-- [组件] Git Diff
local diff = {
	"diff",
	colored = true,
	symbols = { added = " ", modified = " ", removed = " " },
	cond = hide_in_width,
}

-- [组件] 模式 (Normal/Insert...)
local mode = {
	"mode",
	fmt = function(str)
		return str:sub(1, 1) -- 仅显示首字母 (N/I/V)，节省空间
	end,
}

-- [组件] 文件类型图标
local filetype = {
	"filetype",
	icons_enabled = true,
	icon = nil,
}

-- [组件] Git 分支
local branch = {
	"branch",
	icons_enabled = true,
	icon = "",
}

-- [自定义组件] 显示当前活跃的 LSP (如 gopls, svelte)
-- 这对调试非常有用，让你知道 LSP 到底起没起来
local function lsp_clients()
	local bufnr = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	if #clients == 0 then
		return "No LSP"
	end

	local client_names = {}
	for _, client in pairs(clients) do
		-- 过滤掉像 null-ls 这种通用名字，只保留核心 LSP
		if client.name ~= "null-ls" and client.name ~= "copilot" then
			table.insert(client_names, client.name)
		end
	end

	if #client_names == 0 then
		return ""
	end
	return "[" .. table.concat(client_names, ", ") .. "]"
end

-- =============================================================================
-- 主配置
-- =============================================================================
lualine.setup({
	options = {
		icons_enabled = true,
		theme = "gruvbox", -- 保持你的主题
		-- 使用三角形分隔符 (Powerline 风格)
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },

		disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline" },
		always_divide_middle = true,
		globalstatus = true, -- 全局状态栏 (底部只有一条)
	},
	sections = {
		lualine_a = { mode },
		lualine_b = { branch, diagnostics },
		lualine_c = {
			{ "filename", path = 1 }, -- path=1 显示相对路径，不只是文件名
		},
		-- [核心] 右侧显示: Diff | LSP名字 | 编码 | 文件类型
		lualine_x = {
			diff,
			{ lsp_clients, icon = " " }, -- 显示 LSP 状态
			"encoding",
			filetype,
		},
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	-- 扩展支持：让 NvimTree 和 ToggleTerm 激活时状态栏变色适配
	extensions = { "nvim-tree", "toggleterm", "lazy" },
})
