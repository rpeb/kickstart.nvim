-- Configurable startup/dashboard screen
-- Disabled on startup to avoid "Cursor position outside buffer" race condition.
-- Use :Startup to show manually.

return {
  {
    'startup-nvim/startup.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'nvim-telescope/telescope-file-browser.nvim',
    },
    config = function()
      vim.g.startup_disable_on_startup = true
      require('startup').setup {}
    end,
  },
}
