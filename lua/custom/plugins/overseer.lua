-- Task runner (make, npm, cargo, vscode tasks, etc.)

return {
  {
    'stevearc/overseer.nvim',
    cmd = { 'OverseerRun', 'OverseerToggle', 'OverseerQuickAction' },
    opts = {},
    keys = {
      { '<leader>rr', '<cmd>OverseerRun<cr>', desc = '[R]un task' },
      { '<leader>rt', '<cmd>OverseerToggle<cr>', desc = '[R]un [T]ask list' },
    },
  },
}
