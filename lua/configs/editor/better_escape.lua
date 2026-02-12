local status_ok, better_escape = pcall(require, "better_escape")
if not status_ok then
	return
end

better_escape.setup({
	-- [关键设置] 连按间隔时间 (毫秒)
	-- 如果你手速很快，可以设为 150；如果你经常误触，设为 250
	timeout = 200,

	-- 默认映射清除 (我们要自定义)
	default_mappings = false,

	mappings = {
		i = {
			j = {
				-- 输入 j 后，再输入 k，触发 <Esc>
				k = "<Esc>",
				-- 你也可以开启 jj -> Esc (如果习惯的话，解开下面这行)
				-- j = "<Esc>",
			},
			-- 你也可以加 k 开头的，比如 kj -> Esc
			-- k = {
			--     j = "<Esc>",
			-- },
		},
		c = {
			-- 在命令行模式下 (:) 也可以用 jk 退出
			j = {
				k = "<Esc>",
			},
		},
		t = {
			-- 在终端模式下也可以用 jk 退出 (可选)
			-- j = {
			--     k = "<C-\\><C-n>",
			-- },
		},
	},
})
