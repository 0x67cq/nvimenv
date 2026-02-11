--[[
🟢 场景 A：智能补全函数 (CMP 联动)
* 以前：输入 fmt.Pri -> 选 Println -> 回车 -> 得到 fmt.Println -> 手动打 ( -> 变成 fmt.Println()。
* 现在：输入 fmt.Pri -> 选 Println -> 回车 -> 自动变成 fmt.Println(|) (光标在括号里)。
🟢 场景 B：Treesitter 智能防误触
* 场景：你在写注释 // todo: fix (bug)。
* 以前：打完 ( 会自动变成 // todo: fix (bug)，多了一个右括号。
* 现在：Autopairs 知道你在注释里，不会自作聪明地补全右括号。
🟢 场景 C：Fast Wrap (Alt + e)
* 场景：你写了 hello world，突然想给它加引号变成 "hello world"。
* 操作：
    1. 光标放在行尾。
    2. 按下 Alt + e。
    3. 输入 "。
    4. 它会自动把前面的单词包起来。
 ]]
return {
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter", -- [优化] 只有进入插入模式打字时才加载
		dependencies = {
			"hrsh7th/nvim-cmp", -- 依赖 cmp，因为我们要和它联动
		},
		config = function()
			-- 引用我们将要创建的配置文件
			require("configs.coding.autopairs")
		end,
	},
}
