-- Obsidian.nvim for markdown vault workflow
-- Reference: ~/.config/nvim_ancient
return {
  'obsidian-nvim/obsidian.nvim',
  version = '*',
  lazy = true,
  ft = 'markdown',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'MeanderingProgrammer/render-markdown.nvim',
  },
  config = function()
    require('obsidian').setup({
      workspaces = {
        { name = 'ObsidianVault', path = '/home/prakash/Documents/ubvault' },
      },
      completion = {
        nvim_cmp = false, -- Set true if using nvim-cmp; blink.cmp needs blink.compat for Obsidian sources
        min_chars = 2,
      },
      notes_subdir = 'inbox',
      new_notes_location = 'notes_subdir',
      daily_notes = {
        folder = 'notes/dailies',
        date_format = '%Y-%m-%d',
        alias_format = '%B %-d, %Y',
        default_tags = { 'daily-notes' },
        template = 'daily.md',
      },
      attachments = {
        folder = 'assets/imgs',
        img_name_func = function()
          return string.format('Pasted image %s', os.date '%Y%m%d%H%M%S')
        end,
        img_text_func = function(client, path)
          path = client:vault_relative_path(path) or path
          return string.format('![%s](%s)', path.name, path)
        end,
      },
      note_id_func = function(title)
        local suffix = ''
        if title ~= nil then
          suffix = title:gsub(' ', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
        else
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return tostring(os.time()) .. '-' .. suffix
      end,
      templates = {
        subdir = 'templates',
        date_format = '%Y-%m-%d',
        time_format = '%H:%M',
        tags = '',
        substitutions = {
          yesterday = function()
            return os.date('%Y-%m-%d', os.time() - 86400)
          end,
          tomorrow = function()
            return os.date('%Y-%m-%d', os.time() + 86400)
          end,
        },
      },
      open = { use_advanced_uri = true },
      log_level = vim.log.levels.INFO,
      ui = { enable = false }, -- using render-markdown.nvim
      frontmatter = { enabled = false },
      legacy_commands = false,
    })

    require('custom.obsidian-templates').setup()

    -- Keymaps (reference: nvim_ancient remaps)
    vim.keymap.set('n', '<leader>oc', '<cmd>lua require("obsidian").util.toggle_checkbox()<CR>', { desc = 'Obsidian [C]heckbox' })
    vim.keymap.set('n', '<leader>ot', '<cmd>Obsidian new_from_template<CR>', { desc = 'Obsidian [T]emplate' })
    vim.keymap.set('n', '<leader>ob', '<cmd>Obsidian backlinks<CR>', { desc = 'Obsidian [B]acklinks' })
    vim.keymap.set('n', '<leader>ol', '<cmd>Obsidian links<CR>', { desc = 'Obsidian [L]inks' })
    vim.keymap.set('n', '<leader>on', '<cmd>Obsidian new<CR>', { desc = 'Obsidian [N]ew note' })
    vim.keymap.set('n', '<leader>oq', '<cmd>Obsidian quick_switch<CR>', { desc = 'Obsidian [Q]uick switch' })
    vim.keymap.set('n', '<leader>of', '<cmd>Obsidian follow_link<CR>', { desc = 'Obsidian [F]ollow link' })
    vim.keymap.set('n', '<leader>od', '<cmd>Obsidian dailies<CR>', { desc = 'Obsidian [D]ailies' })
    vim.keymap.set('n', '<leader>ott', '<cmd>Obsidian tags<CR>', { desc = 'Obsidian [T]ags' })
    vim.keymap.set('n', '<leader>otoc', '<cmd>Obsidian toc<CR>', { desc = 'Obsidian [T]able of contents' })
    vim.keymap.set('n', '<leader>opi', '<cmd>Obsidian paste_img<CR>', { desc = 'Obsidian [P]aste [I]mage' })
    vim.keymap.set('n', '<leader>os', '<cmd>Obsidian search<CR>', { desc = 'Obsidian [S]earch' })
    vim.keymap.set('n', '<leader>oo', '<cmd>cd /home/prakash/Documents/ubvault<CR>', { desc = 'Obsidian open vault dir' })
  end,
}
