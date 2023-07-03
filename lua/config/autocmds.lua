-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
local settings = require("configuration")
local autocmd = vim.api.nvim_create_autocmd

local function augroup(name)
  return vim.api.nvim_create_augroup("lazyman_" .. name, { clear = true })
end

-- Check if we need to reload the file when it changed
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  command = "checktime",
})

-- Auto insert mode for Terminal
autocmd({ "WinEnter", "BufWinEnter", "TermOpen" }, {
  callback = function(args)
    if vim.startswith(vim.api.nvim_buf_get_name(args.buf), "term://") then
      vim.opt_local.wrap = true
      vim.opt_local.spell = false
      vim.cmd("startinsert")
    end
  end,
})

autocmd({ "TermOpen" }, {
  pattern = { "*" },
  callback = function()
    vim.opt_local["number"] = false
    vim.opt_local["signcolumn"] = "no"
    vim.opt_local["foldcolumn"] = "0"
  end,
})

-- resize splits if window got resized
autocmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- go to last loc when opening a buffer
autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
    vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "lightgreen" })
  end,
})

-- popup completion menu if there is something before the cursor and nothing after.
autocmd({ "TextChangedI", "TextChangedP" }, {
  callback = function()
    local line = vim.api.nvim_get_current_line()
    local cursor = vim.api.nvim_win_get_cursor(0)[2]

    local current = string.sub(line, cursor, cursor + 1)
    if current == "." or current == "," or current == " " then
      require("cmp").close()
    end

    local before_line = string.sub(line, 1, cursor + 1)
    local after_line = string.sub(line, cursor + 1, -1)
    if not string.match(before_line, "^%s+$") then
      if after_line == "" or string.match(before_line, " $") or string.match(before_line, "%.$") then
        require("cmp").complete()
      end
    end
  end,
  pattern = "*",
})

-- close some filetypes with <q>
autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "query", -- :InspectTree
    "spectre_panel",
    "startuptime",
    "tsplayground",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- wrap and check for spell in text filetypes
autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "gitcommit", "markdown", "text" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Get GUI config when entering UI
autocmd("UIEnter", {
  once = true,
  callback = function()
    require("ginit")
  end,
})

local alpha_group = vim.api.nvim_create_augroup("alpha_autocmd", { clear = true })

autocmd("User", {
  desc = "Disable status and tablines for alpha",
  group = alpha_group,
  pattern = "AlphaReady",
  callback = function()
    vim.opt.laststatus = 0
    vim.opt.showtabline = 0
    vim.opt_local.winbar = nil
    if settings.enable_statusline then
      require("lualine").hide({
        place = { "statusline", "tabline", "winbar" },
        unhide = false,
      })
    end
    autocmd("BufUnload", {
      desc = "Reenable status and tablines for alpha",
      group = alpha_group,
      pattern = "<buffer>",
      callback = function()
        local config = require("configuration")
        if config.enable_statusline then
          if config.global_statusline then
            vim.opt.laststatus = 3
          else
            vim.opt.laststatus = 2
          end
        else
          vim.opt.laststatus = 0
        end
        vim.opt.showtabline = require("configuration").showtabline
        if settings.enable_statusline then
          require("lualine").hide({
            place = { "statusline", "tabline", "winbar" },
            unhide = true,
          })
        end
      end,
    })
  end,
})
autocmd("VimEnter", {
  desc = "Start Alpha when vim is opened with no arguments",
  group = alpha_group,
  callback = function()
    local should_skip = false
    if vim.fn.argc() > 0 or vim.fn.line2byte(vim.fn.line("$")) ~= -1 or not vim.o.modifiable then
      should_skip = true
    else
      for _, arg in pairs(vim.v.argv) do
        if arg == "-b" or arg == "-c" or vim.startswith(arg, "+") or arg == "-S" then
          should_skip = true
          break
        end
      end
    end
    if not should_skip then
      require("alpha").start(true, require("alpha").default_config)
    end
  end,
})

-- Disable some things for large files
local aug = vim.api.nvim_create_augroup("buf_large", { clear = true })
vim.api.nvim_create_autocmd({ "BufReadPre" }, {
  callback = function()
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()))
    if ok and stats and (stats.size > 1000000) then
      vim.b.large_buf = true
      vim.cmd("syntax off")
      vim.cmd("IlluminatePauseBuf") -- disable vim-illuminate
      vim.cmd("IndentBlanklineDisable") -- disable indent-blankline.nvim
      vim.opt_local.foldmethod = "manual"
      vim.opt_local.spell = false
    else
      vim.b.large_buf = false
    end
  end,
  group = aug,
  pattern = "*",
})
