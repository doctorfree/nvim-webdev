local settings = require("configuration")
local configuration_lua = vim.fn.stdpath("config") .. "/lua/configuration.lua"

return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  opts = function()
    local dashboard = require("alpha.themes.dashboard")
    local file_btn = dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>")
    file_btn.opts.hl = "AlphaShortcut"
    local new_btn = dashboard.button("n", " " .. " New file", ":ene <BAR> startinsert <CR>")
    new_btn.opts.hl = "AlphaButton"
    local project_btn =
      dashboard.button("p", " " .. " Find project", ":lua require('telescope').extensions.projects.projects()<CR>")
    project_btn.opts.hl = "AlphaShortcut"
    local recent_btn = dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>")
    recent_btn.opts.hl = "AlphaButton"
    local livegrep_btn = dashboard.button("g", " " .. " Find text", ":Telescope live_grep <CR>")
    livegrep_btn.opts.hl = "AlphaShortcut"
    local session_btn =
      dashboard.button("s", "勒" .. " Last Session", [[:lua require("persistence").load({ last = true }) <cr>]])
    session_btn.opts.hl = "AlphaButton"
    local settings_btn = dashboard.button("c", "  Webdev Configuration", ":e " .. configuration_lua .. "<CR>")
    if settings.enable_terminal then
      settings_btn = dashboard.button("c", "  Webdev Configuration", ":Webdev<CR>")
    end
    settings_btn.opts.hl = "AlphaShortcut"
    local health_btn = dashboard.button("h", "  Neovim Health", ":checkhealth<CR>")
    health_btn.opts.hl = "AlphaButton"
    local lazy_btn = dashboard.button("l", "鈴" .. " Lazy", ":Lazy<CR>")
    lazy_btn.opts.hl = "AlphaShortcut"
    local quit_btn = dashboard.button("q", " " .. " Quit", ":qa<CR>")
    quit_btn.opts.hl = "AlphaButton"

    local header = require("config.headers")["random"]
    if settings.enable_dashboard_header == false then
      header = ""
    end

    dashboard.section.header.val = header
    dashboard.section.header.opts.hl = "AlphaHeader"
    dashboard.section.buttons.val = {
      file_btn,
      new_btn,
      project_btn,
      recent_btn,
      livegrep_btn,
      session_btn,
      settings_btn,
      health_btn,
      lazy_btn,
      quit_btn,
    }
    dashboard.section.footer.val = "github.com/doctorfree/nvim-lazyman"
    dashboard.section.footer.opts.hl = "AlphaFooter"

    return dashboard
  end,
  config = function(_, dashboard)
    -- close Lazy and re-open when the dashboard is ready
    if vim.o.filetype == "lazy" then
      vim.cmd.close()
      vim.api.nvim_create_autocmd("User", {
        pattern = "AlphaReady",
        callback = function()
          require("lazy").show()
        end,
      })
    end

    require("alpha").setup(dashboard.opts)
  end,
}
