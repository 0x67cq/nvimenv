local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- [Native Check] 0.10+ 推荐使用 vim.uv 替代 vim.loop
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		lazyrepo,
		lazypath,
	})

	-- [错误处理] 如果克隆失败，直接报错退出，防止后续一堆红字
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end

vim.opt.rtp:prepend(lazypath)

-- [加载配置]
require("lazy").setup({
	spec = {
		-- 告诉 Lazy 去哪里找插件配置：lua/plugins/ 目录
		{ import = "plugins" },
	},
	-- [可选] 自动检查插件更新（默认是 false，建议 false，手动 :Lazy update 更稳）
	checker = { enabled = false },
	-- [UI 美化]
	ui = {
		border = "rounded", -- 设置圆角边框
	},
})
