local settings = {}

-- Use comma rather than space as the leader key
settings.mapleader = ","
settings.maplocalleader = ","

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
settings.enable_codeium = false

return settings
