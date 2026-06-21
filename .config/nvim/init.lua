-- Vim options copied from https://justinhj.github.io/2026/04/06/refreshing-your-neovim-config-for-0-12-0.html.

-- Prevents showing extra messages when using completion.
vim.opt.shortmess:append('c')
-- Sets the height of the command line area at the bottom.
vim.opt.cmdheight = 0
-- Displays the line number for the current line.
vim.opt.number = true
-- Time in milliseconds to wait for a mapped sequence to complete.
vim.opt.timeoutlen = 500
-- Time in milliseconds of inactivity before calling CursorHold or writing to swap.
vim.opt.updatetime = 4000
-- Ignores case when searching patterns.
vim.opt.ignorecase = true
-- Automatically switches to case-sensitive search if a capital letter is used.
vim.opt.smartcase = true
-- Configures the behavior of the insert mode completion menu.
vim.opt.completeopt = 'menu,menuone,noselect,popup'
-- Number of spaces that a <Tab> character represents.
vim.opt.tabstop = 2
-- Number of spaces to use for each step of automatic indentation.
vim.opt.shiftwidth = 2
-- Number of spaces that a <Tab> counts for during editing operations.
vim.opt.softtabstop = 2
-- Converts tabs into spaces when typing.
vim.opt.expandtab = true
-- Automatically inserts an extra level of indentation in some cases.
vim.opt.smartindent = true
-- Makes <Tab> insert 'shiftwidth' number of spaces at the start of a line.
vim.opt.smarttab = true

-- Enables the overall built-in neovim completion feature.
vim.o.autocomplete = true 

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_completion", { clear = true }),
  callback = function(args)
    local client_id = args.data.client_id
    if not client_id then
      return
    end

    local client = vim.lsp.get_client_by_id(client_id)
    if client and client:supports_method("textDocument/completion") then
      -- Enable native LSP completion for this client + buffer
      vim.lsp.completion.enable(true, client_id, args.buf, {
        autotrigger = true,   -- auto-show menu as you type (recommended)
        -- You can also set { autotrigger = false } and trigger manually with <C-x><C-o>
      })
    end
  end,
})

-- New UI opt-in
require('vim._core.ui2').enable({})

-- Packages.
vim.pack.add({
  'https://github.com/folke/tokyonight.nvim',
  'https://github.com/neovim/nvim-lspconfig',

  -- Run `:TSInstall <language>` once installed to get that language's treesitter support.
  -- Specify 'main' branch; 'master' is dep.
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', 
    version = 'main' }, 
})

vim.cmd[[colorscheme tokyonight]]

-- LSP.
require'lspconfig'.ols.setup {}

