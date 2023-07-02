local settings = require("settings")
vim.g.mapleader = settings.mapleader
vim.g.maplocalleader = settings.maplocalleader

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
