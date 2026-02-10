-- nvim 会自动加载 runtimepath/lua 路径,所以引用lua下的模块可以不用写lua.x
if vim.fn.has("nvim-0.10") == 1 then
	vim.lsp.buf_get_clients = function(bufnr)
		return vim.lsp.get_clients({ bufnr = bufnr })
	end
end
require("core")
require("lazyInit")
