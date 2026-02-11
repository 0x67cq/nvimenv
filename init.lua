-- [性能优化] 开启 Lua 字节码缓存加载器
if vim.loader then
	vim.loader.enable()
end

vim.g.mapleader = ";"
vim.g.maplocalleader = ";"

-- nvim 会自动加载 runtimepath/lua 路径,所以引用lua下的模块可以不用写lua.x

--[[ Neovim 如何查找和加载 Lua 文件 的一个核心机制。理解这个机制对于拆分配置文件至关重要。
在 require 一个文件时，不用写 lua 这个目录名。
    ❌ 错误写法：require("lua.core") 或 require("lua.plugins")
    ✅ 正确写法：require("core") 或 require("plugins")
深入原理：Runtimepath 与 Lua 路径
Neovim 在启动时，会维护一个叫 runtimepath 的列表（类似于系统的 PATH 环境变量）。
    默认结构：你的配置目录 ~/.config/nvim 被自动加入了 runtimepath。
    Lua 的特殊待遇：Neovim 规定，所有位于 runtimepath 下名为 lua/ 的子目录，都会被自动添加到 Lua 的搜索路径 (package.path) 中。
]]
require("core")
require("lazyInit")
