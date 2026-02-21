-- JDTLS setup - runs every time a Java file is opened (Neovim ftplugin)

-- Google Java Style: 4-space indent, no tabs
vim.bo.tabstop = 4
vim.bo.shiftwidth = 4
vim.bo.softtabstop = 4
vim.bo.expandtab = true
vim.bo.textwidth = 100

local jdtls = require 'jdtls'
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok, blink = pcall(require, 'blink.cmp')
if ok and blink.get_lsp_capabilities then
  capabilities = blink.get_lsp_capabilities()
end

local function run_java_term(command)
  vim.cmd 'silent! %bwipeout! term://*'
  vim.cmd('vsplit | term ' .. command)
  vim.cmd 'wincmd p'
end

local root_markers = { 'pom.xml', 'build.gradle', '.git', 'mvnw', 'gradlew' }
local root_dir = jdtls.setup.find_root(root_markers)
if root_dir == '' then root_dir = vim.fn.expand '%:p:h' end

local project_name = vim.fn.fnamemodify(root_dir, ':p:h:t')
local workspace_dir = vim.fn.stdpath 'cache' .. '/jdtls-workspace/' .. project_name

local config = {
  cmd = { 'jdtls', '-data', workspace_dir },
  root_dir = root_dir,
  capabilities = capabilities,
  settings = {
    java = {
      configuration = { updateBuildConfiguration = 'automatic' },
      maven = { downloadSources = true },
      format = {
        settings = {
          url = 'https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml',
          profile = 'GoogleStyle',
        },
      },
    },
  },
  on_attach = function(client, bufnr)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { silent = true, buffer = bufnr })
    vim.keymap.set('n', '<leader>oi', jdtls.organize_imports, { desc = 'Organize Imports', buffer = bufnr })
    vim.keymap.set('n', '<leader>ev', jdtls.extract_variable, { desc = 'Extract Variable', buffer = bufnr })
    vim.keymap.set('v', '<leader>em', [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]], { desc = 'Extract Method', buffer = bufnr })

    if client.server_capabilities.codeLensProvider then
      vim.lsp.codelens.refresh({ bufnr = bufnr })
      -- Only refresh on InsertLeave; BufEnter caused flashing when navigating references
      vim.api.nvim_create_autocmd('InsertLeave', {
        buffer = bufnr,
        callback = function() vim.lsp.codelens.refresh({ bufnr = bufnr }) end,
      })
    end

    vim.keymap.set('n', '<leader>mb', function() run_java_term 'mvn compile' end, { desc = 'Maven Build', buffer = bufnr })
    vim.keymap.set('n', '<leader>mr', function() run_java_term 'mvn exec:java' end, { desc = 'Maven Run', buffer = bufnr })
    vim.keymap.set('n', '<leader>mc', function() run_java_term 'mvn clean compile' end, { desc = 'Maven Clean Build', buffer = bufnr })
    vim.keymap.set('n', '<leader>mt', function() run_java_term 'mvn test' end, { desc = 'Maven Run Tests', buffer = bufnr })
    vim.keymap.set('n', '<leader>jr', function()
      vim.cmd 'write'
      run_java_term('java ' .. vim.fn.expand '%:p')
    end, { desc = 'Run Single Java Class', buffer = bufnr })
  end,
}

jdtls.start_or_attach(config)
