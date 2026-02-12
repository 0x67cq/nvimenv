-- =============================================================================
-- 1. 持久化撤销 (Persistent Undo) - 核心功能
-- =============================================================================
-- 这段配置让你的撤销历史保存到磁盘上
-- 即使重启电脑，下次打开文件依然可以 "u" 回去
local target_path = vim.fn.stdpath("cache") .. "/undo"

-- 如果目录不存在，自动创建
if vim.fn.isdirectory(target_path) == 0 then
	vim.fn.mkdir(target_path, "p")
end

vim.opt.undodir = target_path
vim.opt.undofile = true

-- =============================================================================
-- 2. UndoTree 界面配置
-- =============================================================================
-- 布局风格:
-- 1: tree left, diff left
-- 2: tree left, diff bottom (推荐，看起来像 Git)
-- 3: tree right, diff right
-- 4: tree right, diff bottom
vim.g.undotree_WindowLayout = 2

-- 侧边栏宽度
vim.g.undotree_SplitWidth = 30

-- 差异窗口高度
vim.g.undotree_DiffpanelHeight = 10

-- 自动聚焦到 UndoTree 窗口
vim.g.undotree_SetFocusWhenToggle = 1

-- 树状图节点图标
vim.g.undotree_TreeNodeShape = "*"

-- 相对时间戳 (显示 "2 hours ago" 而不是具体日期)
vim.g.undotree_RelativeTimestamp = 1

-- 高亮差异行
vim.g.undotree_HighlightChangedText = 1

-- 仅在 UndoTree 激活时显示差异窗口
vim.g.undotree_DiffAutoOpen = 1
