local M = {}

local cmd = vim.cmd

-- hide statusline
-- tables fetched from load_config function
--M.hide_statusline = function()
--    local api = vim.api
--    local buftype = api.nvim_buf_get_option(0, "ft")
--
--    -- shown table from config has the highest priority
--    -- if vim.tbl_contains({}, buftype) then
--    --    api.nvim_set_option("laststatus", 2)
--    --    return
--    -- end
--
--    if vim.tbl_contains({ "help", "NvimTree", "terminal", "alpha" }, buftype) then
--        api.nvim_set_option("laststatus", 0)
--        return
--    end
--
--    api.nvim_set_option("laststatus", 2)
--end

---@param ft string
---@param command string
--[[ function M.setup_auto_format(ft, command) ]]
--[[     -- setup_auto_format("lua", "lua require('stylua-nvim').format_file()") ]]
--[[     if not command then ]]
--[[         command = "lua vim.lsp.buf.format()" ]]
--[[     end ]]
--[[     vim.cmd(string.format("autocmd BufWritePre *.%s %s", ft, command)) ]]
--[[ end ]]

M.map = function(mode, keys, command, opt)
    local options = { noremap = true, silent = true }
    if opt then
        options = vim.tbl_extend("force", options, opt)
    end

    -- all valid modes allowed for mappings
    -- :h map-modes
    local valid_modes = {
        [""] = true,
        ["n"] = true,
        ["v"] = true,
        ["s"] = true,
        ["x"] = true,
        ["o"] = true,
        ["!"] = true,
        ["i"] = true,
        ["l"] = true,
        ["c"] = true,
        ["t"] = true,
    }

    -- helper function for M.map
    -- can gives multiple modes and keys
    local function map_wrapper(sub_mode, lhs, rhs, sub_options)
        if type(lhs) == "table" then
            for _, key in ipairs(lhs) do
                map_wrapper(sub_mode, key, rhs, sub_options)
            end
        else
            if type(sub_mode) == "table" then
                for _, m in ipairs(sub_mode) do
                    map_wrapper(m, lhs, rhs, sub_options)
                end
            else
                if valid_modes[sub_mode] and lhs and rhs then
                    vim.api.nvim_set_keymap(sub_mode, lhs, rhs, sub_options)
                else
                    sub_mode, lhs, rhs = sub_mode or "", lhs or "", rhs or ""
                    print("Cannot set mapping [ mode = '" .. sub_mode .. "' | key = '" .. lhs .. "' | cmd = '" .. rhs .. "' ]")
                end
            end
        end
    end

    map_wrapper(mode, keys, command, options)
end
M.nmap = function(keys, command, opt)
    M.map("n", keys, command, opt)
end
M.imap = function(keys, command, opt)
    M.map("i", keys, command, opt)
end

-- load plugin after entering vim ui
M.packer_lazy_load = function(plugin, timer)
    if plugin then
        timer = timer or 0
        vim.defer_fn(function()
            require("packer").loader(plugin)
        end, timer)
    end
end

-- Highlights functions

-- Define bg color
-- @param group Group
-- @param color Color

M.bg = function(group, col)
    cmd("hi " .. group .. " guibg=" .. col)
end

-- Define fg color
-- @param group Group
-- @param color Color
M.fg = function(group, col)
    cmd("hi " .. group .. " guifg=" .. col)
end

-- Define bg and fg color
-- @param group Group
-- @param fgcol Fg Color
-- @param bgcol Bg Color
M.fg_bg = function(group, fgcol, bgcol)
    cmd("hi " .. group .. " guifg=" .. fgcol .. " guibg=" .. bgcol)
end

return M
