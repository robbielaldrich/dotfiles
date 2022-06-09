vim.g.mapleader = ","

-- Wrapper for keybindings.
-- https://blog.devgenius.io/create-custom-keymaps-in-neovim-with-lua-d1167de0f2c2
function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

vim.api.nvim_exec("set clipboard+=unnamedplus", true)

-- To know which scope a setting is in, try `:h <setting>`.
local o = vim.o -- Global options.
local wo = vim.wo -- Window options.
local bo = vim.bo -- Buffer options.

o.termguicolors = true

vim.cmd("colorscheme everforest")

wo.number = true

o.autowrite = true
o.updatetime = 100

map("n", "<leader>d", ":put =strftime('%a %d %b %Y')<CR>") -- Insert date.

-- vim-go
vim.g.go_fmt_command = "goimports"
vim.g.go_auto_type_info = 1
vim.g.go_auto_sameids = 1
vim.g.go_autodetect_gopath = 1
vim.g.go_list_type = "quickfix"
vim.g.go_highlight_types = 1
vim.g.go_highlight_fields = 1
vim.g.go_highlight_functions = 1
vim.g.go_highlight_function_calls = 1
vim.g.go_highlight_extra_types = 1
vim.g.go_highlight_generate_tags = 1

map("n", "<C-n>", ":cnext<CR>") -- Jump to next error with Ctrl-n.
map("n", "<C-m>", ":cprevious<CR>") -- Jump to previous error with Ctrl-m. 
map("n", "<leader>a", ":cclose<CR>") -- Close the quickfix window with <leader>a.

local custom_lsp_attach = function(client)
  -- See `:help nvim_buf_set_keymap()` for more information
  local opts = {noremap = true}
  vim.api.nvim_buf_set_keymap(0, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(0, 'n', '<c-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(0, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(0, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(0, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(0, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(0, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  vim.api.nvim_buf_set_keymap(0, 'n', 'd]', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  --vim.api.nvim_buf_set_keymap(0, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  --vim.api.nvim_buf_set_keymap(0, "n", "]d", vim.diagnostic.goto_next, opts)

  --vim.api.nvim_buf_set_keymap(0, "n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
  --vim.api.nvim_buf_set_keymap(0, "n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
  --vim.api.nvim_buf_set_keymap(0, "n", "<space>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
  --vim.api.nvim_buf_set_keymap(0, "n", "<space>q", function() vim.diagnostic.setqflist({open = true}) end, opts)
  --vim.api.nvim_buf_set_keymap(0, "n", "<space>ca", vim.lsp.buf.code_action, opts)
  -- ... and other keymappings for LSP

  -- Use LSP as the handler for omnifunc.
  --    See `:help omnifunc` and `:help ins-completion` for more information.
  vim.api.nvim_buf_set_option(0, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Use LSP as the handler for formatexpr.
  --    See `:help formatexpr` for more information.
  vim.api.nvim_buf_set_option(0, 'formatexpr', 'v:lua.vim.lsp.formatexpr()')

  -- For plugins with an `on_attach` callback, call them here. For example:
  -- require('completion').on_attach()
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

require'lspconfig'.pyright.setup{
  on_attach = custom_lsp_attach,
  capabilities = capabilities,
}

bo.tabstop = 2
bo.shiftwidth = 2
bo.expandtab = true

vim.api.nvim_command('autocmd FileType proto setlocal shiftwidth=4 tabstop=4')



