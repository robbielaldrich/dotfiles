vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Options -------------------------------------------------------------------

-- UI
vim.opt.number = true   -- Show the line number for the current line.
vim.opt.cmdheight = 0   -- Hide the command line when it isn't in use.

-- Timing (ms)
vim.opt.timeoutlen = 500   -- Wait this long for a mapped key sequence to complete.
vim.opt.updatetime = 4000  -- Idle time before CursorHold fires / swap is written.

-- Search
vim.opt.ignorecase = true  -- Case-insensitive search...
vim.opt.smartcase = true   -- ...unless the pattern contains a capital letter.

-- Indentation: 2 spaces, never tabs
vim.opt.tabstop = 2        -- Width of a literal <Tab> character.
vim.opt.shiftwidth = 2     -- Width of each auto-indent step (>>, <<, ==).
vim.opt.softtabstop = 2    -- Width <Tab>/<BS> use while editing.
vim.opt.expandtab = true   -- Insert spaces instead of tabs.
vim.opt.smartindent = true -- Auto-indent after `{`, keywords, etc.
vim.opt.smarttab = true    -- <Tab> at line start indents by 'shiftwidth'.

-- Clipboard
vim.opt.clipboard:append('unnamedplus') -- Yank/delete/put use the system clipboard.

-- Completion ----------------------------------------------------------------

-- Built-in autocompletion (Neovim 0.12+) shows the completion menu as you type.
--
-- Sources come from 'complete'; appending 'o' (omnifunc) adds LSP candidates.
-- Neovim sets omnifunc to vim.lsp.omnifunc on LspAttach, and that path also
-- applies accept-time side effects (snippet expansion, auto-imports, commands),
-- so vim.lsp.completion.enable() isn't needed.
--
-- 'autocomplete' is buffer-scoped; it's disabled in the Telescope prompt below.
vim.o.autocomplete = true
vim.opt.complete:append('o')

-- <Tab> accepts a completion when the popup menu is visible. With 'noselect',
-- nothing is selected at first, so pick the top item before confirming.
-- Otherwise <Tab> behaves normally.
vim.keymap.set('i', '<Tab>', function()
  if vim.fn.pumvisible() == 0 then
    return '<Tab>'
  end
  return vim.fn.complete_info({ 'selected' }).selected == -1 and '<C-n><C-y>' or '<C-y>'
end, { expr = true })

-- Plugins -------------------------------------------------------------------

-- Must come before any require() of these plugins.
vim.pack.add({
  'https://github.com/folke/tokyonight.nvim',
  'https://github.com/neovim/nvim-lspconfig',

  -- Run `:TSInstall <language>` to add treesitter support for a language.
  -- Pin to 'main'; the 'master' branch is deprecated.
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },

  -- Telescope and its required dependency.
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-telescope/telescope.nvim',
})

vim.cmd.colorscheme('tokyonight')

-- LSP -----------------------------------------------------------------------

-- Go templates; gopls attaches to the 'gotmpl' filetype, which Neovim doesn't
-- define by default. `.tmpl` is left out since other tools use it too.
vim.filetype.add({
  extension = {
    gotmpl = 'gotmpl',
    gohtml = 'gotmpl',
  },
})

vim.lsp.config('gopls', {
  settings = {
    gopls = {
      gofumpt = true,
      staticcheck = true,
      analyses = {
        unusedparams = true,
      },
    },
  },
})

-- Requires lua-language-server on PATH (see README).
vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      -- Neovim embeds LuaJIT and exposes the global `vim`.
      runtime = { version = 'LuaJIT' },
      diagnostics = { globals = { 'vim' } },
      -- Make Neovim's runtime (vim.api, vim.lsp, ...) known for completion/hover.
      workspace = {
        checkThirdParty = false,
        library = { vim.env.VIMRUNTIME },
      },
      -- Built-in formatter (EmmyLuaCodeStyle). Values must be strings.
      format = {
        enable = true,
        defaultConfig = {
          indent_style = 'space',
          indent_size = '2',
          quote_style = 'single',
        },
      },
    },
  },
})

vim.lsp.enable({ 'gopls', 'lua_ls' })

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp_attach', { clear = true }),
  callback = function(args)
    local buf = args.buf
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

    -- Format on save with any server that supports it.
    if client:supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('lsp_format_' .. buf, { clear = true }),
        buffer = buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = buf, id = client.id, async = false })
        end,
      })
    end

    local t = require('telescope.builtin')
    vim.keymap.set('n', 'gd', t.lsp_definitions,                       { buffer = buf, desc = 'Go to definition' })
    vim.keymap.set('n', 'gr', t.lsp_references,                        { buffer = buf, desc = 'Find references' })
    vim.keymap.set('n', 'gi', t.lsp_implementations,                   { buffer = buf, desc = 'Go to implementation' })
    vim.keymap.set('n', 'gT', t.lsp_type_definitions,                  { buffer = buf, desc = 'Go to type definition' })
    vim.keymap.set('n', '<leader>ds', t.lsp_document_symbols,          { buffer = buf, desc = 'Document symbols' })
    vim.keymap.set('n', '<leader>ws', t.lsp_dynamic_workspace_symbols, { buffer = buf, desc = 'Workspace symbols' })
    vim.keymap.set('n', 'K', vim.lsp.buf.hover,                        { buffer = buf, desc = 'Hover docs' })
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename,              { buffer = buf, desc = 'Rename symbol' })
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action,         { buffer = buf, desc = 'Code action' })
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next,                { buffer = buf, desc = 'Next diagnostic' })
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev,                { buffer = buf, desc = 'Prev diagnostic' })
  end,
})

-- Telescope -----------------------------------------------------------------

-- Disable built-in autocomplete in Telescope's prompt; otherwise the popup
-- fires on every keystroke and covers the picker results.
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'TelescopePrompt',
  callback = function()
    vim.bo.autocomplete = false
  end,
})

local t = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', t.find_files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', t.live_grep,  { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fb', t.buffers,    { desc = 'Buffers' })
