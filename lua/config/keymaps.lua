-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local Util = require("lazyvim.util")
-- Silent keymap option
local opts = { silent = true }

local function map(mode, lhs, rhs, mapopts)
  local keys = require("lazy.core.handler").handlers.keys
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    mapopts = mapopts or {}
    mapopts.silent = mapopts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, mapopts)
  end
end

-- Plugin Management
map("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Lazy Menu" })
map("n", "<leader>U", "<cmd>Lazy update<cr>", { desc = "Lazy Update" })
-- Options
map("n", "<leader>o", "<cmd>options<cr>", { desc = "Options" })

-- Press jj,jk fast to enter
map("i", "jj", "<ESC>", opts)
map("i", "jk", "<ESC>", opts)

-- Close buffers
if Util.has("mini.bufremove") then
  map("n", "<S-q>", function()
    require("mini.bufremove").delete(0, false)
    local bufs = vim.fn.getbufinfo({ buflisted = true })
    -- open alpha if no buffers are left
    if not bufs[2] and Util.has("alpha-nvim") then
      require("alpha").start(true)
    end
  end, opts)
else
  map("n", "<S-q>", "<cmd>bd<CR>", opts)
end

-- Dashboard
-- Add keymap to open alpha dashboard
map("n", "<leader>;", function()
  -- close all open buffers before open dashboard
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    local buftype = vim.api.nvim_buf_get_option(bufnr, "buftype")
    if buftype ~= "terminal" then
      vim.api.nvim_buf_delete(bufnr, { force = true })
    end
  end

  if Util.has("alpha-nvim") then
    require("alpha").start(true)
  end
end, opts)

-- NullLs Info keymap
if Util.has("null-ls.nvim") then
  map("n", "<leader>cn", "<cmd>NullLsInfo<CR>", opts)
end

-- Trouble
-- Add keymap only show FIXME
if Util.has("todo-comments.nvim") then
  -- show fixme on telescope
  map("n", "<leader>xf", "<cmd>TodoTelescope keywords=FIX,FIXME<CR>")
end

-- Gitsigns
-- Add toggle gitsigns blame line
if Util.has("gitsigns.nvim") then
  map("n", "<leader>ub", "<cmd>lua require('gitsigns').toggle_current_line_blame()<CR>", {
    desc = "Toggle current line blame",
  })
end
