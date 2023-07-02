-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set:
--   https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
--
-- Use leader key settings in configuration.lua
local settings = require("configuration")
local utils = require("utils.functions")
local o = vim.opt

vim.g.mapleader = settings.mapleader
vim.g.maplocalleader = settings.maplocalleader
--

if settings.enable_statusline then
  o.showmode = false -- Dont show mode since we have a statusline
  o.ruler = true
  o.showcmd = true
  if settings.global_statusline then
    o.laststatus = 2
  else
    o.laststatus = 1
  end
else
  o.showmode = true -- Dont show mode since we have a statusline
  o.ruler = false
  o.showcmd = false
  o.laststatus = 0
end
if settings.enable_tabline then
  o.showtabline = settings.showtabline
else
  o.showtabline = 0
end

if utils.isNotEmpty(settings.grepprg) then
  o.grepprg = settings.grepprg
else
  o.grepprg = "rg --vimgrep"
end

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader = settings.mapleader
vim.g.maplocalleader = settings.maplocalleader
-- Register the 'text' filetype with Treesitter to be highlighted like markdown
vim.treesitter.language.register('markdown', 'text')

o.autowrite = true -- Enable auto write
o.clipboard = "unnamed" -- or "unnamedplus"
o.completeopt = "menu,menuone,noselect"
-- o.conceallevel = 3 -- Hide * markup for bold and italic
o.conceallevel = 0 -- so that `` is visible in markdown files
o.cmdheight = 0 -- more space in the neovim command line for displaying messages
o.fileencoding = "utf-8" -- the encoding written to a file
o.incsearch = true
o.hlsearch = true -- highlight all matches on previous search pattern
o.confirm = true -- Confirm to save changes before exiting modified buffer
o.cursorline = true -- Enable highlighting of the current line
o.expandtab = true -- Use spaces instead of tabs
o.formatoptions = "jcroqlnt" -- tcqj
o.grepformat = "%f:%l:%c:%m"
o.ignorecase = true -- Ignore case
o.inccommand = "nosplit" -- preview incremental substitute
o.list = settings.list -- Show some invisible characters (tabs...
o.listchars = settings.listchars
-- Fold options
o.foldcolumn = "0"
o.foldlevel = 49
o.foldlevelstart = 49
o.foldenable = true
--
o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
o.fillchars:append('stl: ');
o.mouse = settings.mouse -- Enable mouse mode
o.number = settings.number -- Print line number
o.pumblend = 10 -- Popup blend
o.pumheight = 10 -- Maximum number of entries in a popup
o.relativenumber = settings.relative_number -- Relative line numbers
o.scrolloff = 4 -- Lines of context
o.sidescrolloff = 8 -- Columns of context
o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,globals,winsize,winpos,terminal"
o.shiftround = true -- Round indent
o.shiftwidth = 2 -- the number of spaces inserted for each indentation
o.tabstop = 2 -- how many spaces a tab counts for
o.softtabstop = 2
o.shortmess:append({ W = true, I = true, c = true })
o.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text
o.smartcase = true -- Don't ignore case with capitals
o.smartindent = true -- Insert indents automatically
o.spelllang = { "en" }
o.spell = false     -- disable by default, enable in ftplugin or autocmd
o.spelloptions = { "noplainbuffer" }
o.splitbelow = true -- Put new windows below current
o.splitright = true -- Put new windows right of current
o.termguicolors = true -- True color support
o.timeoutlen = 300
o.ttimeoutlen = 0 -- Time in milliseconds to wait for a key code sequence to complete
o.undofile = true
o.undolevels = 10000
o.updatetime = 200 -- Save swap file and trigger CursorHold
o.wildmode = "longest:full,full" -- Command-line completion mode
o.winminwidth = 5 -- Minimum window width
o.wrap = true -- Enable line wrap

if vim.fn.has("nvim-0.9.0") == 1 then
  o.splitkeep = "screen"
  o.shortmess:append({ C = true })
end

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

-- Ignore some deprecation warnings
require("utils.deprecation-warnings")
