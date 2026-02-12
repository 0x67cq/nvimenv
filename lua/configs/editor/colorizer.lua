local status_ok, colorizer = pcall(require, "colorizer")
if not status_ok then
	return
end

colorizer.setup({
	-- 1. 全局配置 (针对所有文件类型)
	"*",

	-- 2. 针对特定文件类型的增强配置
	css = {
		rgb_fn = true, -- CSS rgb() and rgba() functions
		hsl_fn = true, -- CSS hsl() and hsla() functions
		css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
		css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
	},
	html = {
		names = true, -- "Name" codes like Blue or red
	},
	javascript = {
		names = true, -- Enable "Name" codes
		rgb_fn = true, -- Enable RGB functions
	},
	typescript = {
		names = true,
		rgb_fn = true,
	},
	vue = {
		names = true,
		rgb_fn = true,
	},
	svelte = {
		names = true,
		rgb_fn = true,
	},
}, {
	-- 3. 显示模式
	mode = "background", -- "foreground" | "background"
	-- 设为 "background" (默认) 会把背景色变成对应的颜色 (更直观)
	-- 设为 "foreground" 只会改变文字颜色
})
