-- nvim-jdtls plugin spec (installs & loads the plugin)
-- ftplugin/java.lua runs start_or_attach per Java buffer
return {
  {
    'mfussenegger/nvim-jdtls',
    lazy = false, -- Load at startup so ftplugin/java.lua can require it
    config = function()
      -- Kill terminals keymap (global)
      vim.keymap.set('n', '<leader>tk', function()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.bo[buf].buftype == 'terminal' then
            vim.api.nvim_win_close(win, true)
            vim.api.nvim_buf_delete(buf, { force = true })
          end
        end
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.bo[buf].buftype == 'terminal' then vim.api.nvim_buf_delete(buf, { force = true }) end
        end
      end, { desc = 'Safe Kill Terminals Only' })
    end,
  },
}
