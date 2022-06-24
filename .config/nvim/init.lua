-- Plugins.
local use = require('packer').use
require('packer').startup(function()
  use 'wbthomason/packer.nvim' -- Package manager
  use 'neovim/nvim-lspconfig' -- Collection of configurations for the built-in LSP client
  use 'ziglang/zig.vim' -- Collection of configurations for the built-in LSP client
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/vim-vsnip'
end)


-- Wrapper for keybindings.
-- https://blog.devgenius.io/create-custom-keymaps-in-neovim-with-lua-d1167de0f2c2
function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local o = vim.o -- Global options.
local wo = vim.wo -- Window options.
local bo = vim.bo -- Buffer options.

-- Stuff.
vim.g.mapleader = ","

vim.api.nvim_exec("set clipboard+=unnamedplus", true)

o.termguicolors = true

vim.cmd("colorscheme everforest")

wo.number = true

vim.o.autowrite = true
o.updatetime = 100

map("n", "<leader>d", ":put =strftime('%a %d %b %Y')<CR>") -- Insert date.

bo.tabstop = 2
bo.shiftwidth = 2
bo.expandtab = true

vim.api.nvim_command('autocmd FileType proto setlocal shiftwidth=4 tabstop=4')

require('my_lsp_config')



