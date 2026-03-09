local codecompanion = require("codecompanion")
-- # 云端双雄备用
-- export ANTHROPIC_API_KEY="sk-ant-你的Claude秘钥"
-- export GEMINI_API_KEY="AIzaSy-你的Gemini秘钥"

codecompanion.setup({
	-- 【新增】：夺回大模型的人设控制权
	opts = {
		-- 1. 明确告诉插件我们的主语言是中文
		language = "Chinese",
		save_chats = true,

		-- 2. system_prompt 必须是一个函数！
		system_prompt = function()
			return [[
你是一个顶级的 AI 编程助手，深度集成在 Neovim 中。
你的主要任务是帮助用户编写、审查、重构代码，以及解答编程和 Neovim 配置相关的问题。

请遵守以下核心规则：
1. 默认使用**中文**进行回复，除非用户明确要求使用英文。
2. 解释要简洁专业，直奔主题，不要有过多的寒暄。
3. 当提供代码时，只提供最佳实践的、可运行的代码，并尽量带上关键的中文注释。
4. 必须如实回答你的底层模型身份（如 Gemini 1.5 Pro 或 Qwen）。
5. 严禁复读“我是 CodeCompanion”这种模糊的套话。
6. 你应当遵循第一性原理，用户不会永远正确，要提出你认为最好的方案。
]]
		end,
	},

	-- 1. 策略分离：聊天和 Agent 用云端 Gemini，行内补全用本地 Qwen 3.5
	strategies = {
		chat = {
			adapter = "gemini",

			-- 【新增】：自定义 Chat 窗口内部的交互快捷键
			keymaps = {
				send = {
					modes = {
						-- 普通模式下：按 <leader>s 发送
						n = "<leader>a",
						-- 插入模式下：按 Ctrl+回车 发送
						i = "<C-s>",
					},
				},
				close = {
					modes = {
						n = "q", -- 普通模式按 q 直接关闭聊天框
						i = "<C-c>", -- 插入模式按 Ctrl+c 也能直接退出
					},
				},
				-- 中断/停止 AI 生成的快捷键
				stop = {
					modes = {
						n = "<C-c>", -- 发现 AI 开始胡言乱语，普通模式按 Ctrl+c 强行打断
					},
				},
				-- 清除聊天记录
				clear = {
					modes = {
						n = "gx", -- 普通模式按 gx 清空当前对话
					},
				},
			},
		},
		-- inline = { adapter = "llama_cpp_local" },
		inline = { adapter = "deepseek" },
		agent = { adapter = "gemini" },
	},

	-- 2. 适配器配置
	adapters = {
		-- 配置云端 Gemini
		gemini = function()
			return require("codecompanion.adapters").extend("gemini", {
				env = {
					-- 云端主架构师：Gemini 的 API Key (可以在 Google AI Studio 获取)
					-- export GEMINI_API_KEY="AIzaSy-你的真实秘钥"
					api_key = "cmd:echo $GEMINI_API_KEY",
				},
				schema = {
					model = {
						-- CodeCompanion 默认通常会使用 flash 或 pro 模型
						-- 你可以在这里强制指定你想要的最强代码模型，例如 gemini-1.5-pro 或更新的版本
						default = "gemini-1.5-pro",
					},
				},
			})
		end,

		-- 本地 llama.cpp (Qwen 3.5) 配置保持不变
		llama_cpp_local = function()
			return require("codecompanion.adapters").extend("openai_compat", {
				env = {
					url = "http://127.0.0.1:8080",
					api_key = "sk-local",
				},
				name = "qwen3.5-local",
				schema = { model = { default = "qwen3.5" } },
			})
		end,

		deepseek = function()
			return require("codecompanion.adapters").extend("openai_compat", {
				env = {
					url = "https://api.deepseek.com", -- 官方 API 地址
					api_key = "cmd:echo $DEEPSEEK_API_KEY", -- 建议在系统变量中设置
				},
				name = "DeepSeek",
				schema = {
					model = {
						-- 可选：deepseek-chat (V3) 或 deepseek-reasoner (R1)
						default = "deepseek-chat",
					},
					-- 官方 API 建议调低 temperature 以获取更稳定的代码输出
					temperature = { default = 0.3 },
					max_tokens = { default = 4096 },
				},
			})
		end,
	},

	-- 3. 自定义提示词库保持不变，依然强制走本地极速生成
	prompt_library = {
		["AddComments"] = {
			strategy = "inline",
			description = "为选中的代码添加详细的中文注释",
			opts = {
				adapter = "llama_cpp_local", -- ⬅️ 保持本地 Qwen 3.5
				placement = "replace",
			},
			prompts = {
				{
					role = "system",
					content = "你是一个严谨的资深程序员。请为提供的代码添加清晰的中文注释。请直接输出包含注释的代码，不要输出任何额外的解释或 markdown 标记。",
				},
				{
					role = "user",
					content = function(context)
						return "请给这段代码加注释：\n\n" .. context.selection
					end,
				},
			},
		},

		["WriteTests"] = {
			strategy = "chat",
			description = "为选中的函数生成单元测试",
			opts = {
				adapter = "llama_cpp_local", -- ⬅️ 保持本地 Qwen 3.5
			},
			prompts = {
				{
					role = "system",
					content = "你是一个资深的测试工程师。请为用户提供的代码编写健壮的单元测试。包括正常情况和边界条件。直接输出代码。",
				},
				{
					role = "user",
					content = function(context)
						return "请为以下代码编写测试：\n\n" .. context.selection
					end,
				},
			},
		},
	},
	extensions = {
		history = {
			enabled = true,
			opts = {
				-- Keymap to open history from chat buffer (default: gh)
				keymap = "gh",
				-- Keymap to save the current chat manually (when auto_save is disabled)
				save_chat_keymap = "sc",
				-- Save all chats by default (disable to save only manually using 'sc')
				auto_save = true,
				-- Number of days after which chats are automatically deleted (0 to disable)
				expiration_days = 0,
				-- Picker interface (auto resolved to a valid picker)
				picker = "telescope", --- ("telescope", "snacks", "fzf-lua", or "default")
				---Optional filter function to control which chats are shown when browsing
				chat_filter = nil, -- function(chat_data) return boolean end
				-- Customize picker keymaps (optional)
				picker_keymaps = {
					rename = { n = "r", i = "<M-r>" },
					delete = { n = "d", i = "<M-d>" },
					duplicate = { n = "<C-y>", i = "<C-y>" },
				},
				---Automatically generate titles for new chats
				auto_generate_title = true,
				title_generation_opts = {
					---Adapter for generating titles (defaults to current chat adapter)
					adapter = nil, -- "copilot"
					---Model for generating titles (defaults to current chat model)
					model = nil, -- "gpt-4o"
					---Number of user prompts after which to refresh the title (0 to disable)
					refresh_every_n_prompts = 0, -- e.g., 3 to refresh after every 3rd user prompt
					---Maximum number of times to refresh the title (default: 3)
					max_refreshes = 3,
					format_title = function(original_title)
						-- this can be a custom function that applies some custom
						-- formatting to the title.
						return original_title
					end,
				},
				---On exiting and entering neovim, loads the last chat on opening chat
				continue_last_chat = false,
				---When chat is cleared with `gx` delete the chat from history
				delete_on_clearing_chat = false,
				---Directory path to save the chats
				dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
				---Enable detailed logging for history extension
				enable_logging = false,

				-- Summary system
				summary = {
					-- Keymap to generate summary for current chat (default: "gcs")
					create_summary_keymap = "gcs",
					-- Keymap to browse summaries (default: "gbs")
					browse_summaries_keymap = "gbs",

					generation_opts = {
						adapter = nil, -- defaults to current chat adapter
						model = nil, -- defaults to current chat model
						context_size = 90000, -- max tokens that the model supports
						include_references = true, -- include slash command content
						include_tool_outputs = true, -- include tool execution results
						system_prompt = nil, -- custom system prompt (string or function)
						format_summary = nil, -- custom function to format generated summary e.g to remove <think/> tags from summary
					},
				},

				-- Memory system (requires VectorCode CLI)
				memory = {
					-- Automatically index summaries when they are generated
					auto_create_memories_on_summary_generation = true,
					-- Path to the VectorCode executable
					vectorcode_exe = "vectorcode",
					-- Tool configuration
					tool_opts = {
						-- Default number of memories to retrieve
						default_num = 10,
					},
					-- Enable notifications for indexing progress
					notify = true,
					-- Index all existing memories on startup
					-- (requires VectorCode 0.6.12+ for efficient incremental indexing)
					index_on_startup = false,
				},
			},
		},
	},
})
