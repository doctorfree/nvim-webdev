local settings = require("configuration")
local neoscroll = {}
if settings.enable_smooth_scrolling then
  neoscroll = {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    config = function()
      require("config.neoscroll")
    end,
  }
end

local terminal_nvim = {}
if settings.enable_terminal then
  terminal_nvim = {
    "rebelot/terminal.nvim",
    cmd = {
      "Asciiville",
      "TermOpen",
      "TermToggle",
      "TermRun",
      "Lazygit",
      "IPython",
      "Lazyman",
      "Lazyconf",
      "Webdev",
      "Htop",
    },
    lazy = false,
    config = function()
      require("config.terminal_nvim")
    end,
  }
end

return {
  neoscroll,
  terminal_nvim
}
