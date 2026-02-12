local lint = require("lint")
vim.env.NVIM_LINT_LOG_LEVEL = "debug"

-- 1. 定义各语言使用的 Linter
lint.linters_by_ft = {
	-- Golang: 行业标准的合集级 Linter
	go = { "golangcilint" },

	-- 前端: Svelte, JS, TS 统一使用 eslint
	javascript = { "eslint_d" },
	typescript = { "eslint_d" },
	svelte = { "eslint_d" },

	-- 其他
	sh = { "shellcheck" },
	lua = { "selene" },
}

-- 2. 配置触发时机
local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
	group = lint_augroup,
	callback = function()
		-- 只有在正常文件里才运行 lint
		if vim.opt.buftype:get() == "" then
			lint.try_lint()
		end
	end,
})

-- 3. 自定义 Linter 参数 (可选)
-- 比如 golangcilint，我们希望它在查找项目根目录时更智能
local golangcilint = lint.linters.golangcilint
-- lint.linters.golangcilint.append_fname = true
golangcilint.args = {
	"run",
	"--output.json.path=stdout",
	"--show-stats=false",
}
