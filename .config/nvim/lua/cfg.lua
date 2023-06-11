local telescope = require('telescope');
telescope.setup({
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {
        -- even more opts
      }
    }
  }
})
telescope.load_extension("ui-select")
telescope.load_extension("fzf")

require('nvim-treesitter.configs').setup({
  -- A list of parser names, or "all"
  ensure_installed = { "c", "lua", "rust" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- List of parsers to ignore installing (for "all")
  ignore_install = { "javascript" },

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = {},

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
})

-- Provide some indication that rust-analyzer is busy!
local lsp_status = require('lsp-status')
lsp_status.register_progress()

local nvim_lsp = require('lspconfig')

-- rust opts
local opts = {
    tools = { -- rust-tools options
        autoSetHints = true,
        inlay_hints = {
            show_parameter_hints = false,
            parameter_hints_prefix = "",
            other_hints_prefix = "=> ",
        },
    },

    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by rust-tools.nvim
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
    server = {
        -- on_attach is a callback called when the language server attachs to the buffer
        on_attach = lsp_status.on_attach,
        capabilities = lsp_status.capabilities,
        settings = {
            -- to enable rust-analyzer settings visit:
            -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
            -- and more: https://github.com/simrat39/rust-tools.nvim/wiki/Server-Configuration-Schema
            ["rust-analyzer"] = {
                -- enable clippy on save
                checkOnSave = {
                    command = "clippy",
                    --extraArgs= {"--target-dir", "/tmp/rust-analyzer-check"},
                    allFeatures = true,
                    allTargets = true
                },
                cargo = {
                    allFeatures = true
                    --features = {"tests"}
                },
                --rustfmt = {
                    --extraArgs = { "+nightly" }
                --}
            }
        }
    },
}
-- rust
require('rust-tools').setup(opts)
-- typescript
require("typescript").setup({
    disable_commands = false, -- prevent the plugin from creating Vim commands
    debug = false, -- enable debug logging for commands
    go_to_source_definition = {
        fallback = true, -- fall back to standard LSP definition on failure
    },
    server = { -- pass options to lspconfig's setup method
        on_attach = lsp_status.on_attach
    },
})
-- latex
nvim_lsp.texlab.setup {}
-- python
nvim_lsp.pyright.setup {}

-- dart/flutter
require("flutter-tools").setup {}

--bash
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'sh',
  callback = function()
    vim.lsp.start({
      name = 'bash-language-server',
      cmd = { 'bash-language-server', 'start' },
    })
  end,
})

-- Setup Completion
-- See https://github.com/hrsh7th/nvim-cmp#basic-configuration

-- Used for super-tab functionality
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local lspkind = require('lspkind')
local cmp = require'cmp'
cmp.setup({
  --completion = {
    --autocomplete = true
  --},
  -- Enable LSP snippets
  snippet = {
    expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    }),

    -- Add tab support
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn["vsnip#available"](1) == 1 then
        feedkey("<Plug>(vsnip-expand-or-jump)", "")
      elseif has_words_before() then
        cmp.complete()
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn["vsnip#jumpable"](-1) == 1 then
        feedkey("<Plug>(vsnip-jump-prev)", "")
      end
    end, { "i", "s" }),
  },

  -- Installed sources
  sources = {
    { name = 'nvim_lsp' }, --, trigger_characters={'.', ":"} },
    { name = 'vsnip' },
    { name = 'path' },
    { name = 'buffer' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'nvim_lsp_document_symbol' },
  },

  -- Fancy symbols
  formatting = {
    format = lspkind.cmp_format({
      --mode = 'symbol', -- show only symbol annotations
      mode = 'symbol_text', -- show both symbol & text for now
      maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)

      -- The function below will be called before any actual modifications from lspkind
      -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
      --before = function (entry, vim_item)
        --...
        --return vim_item
      --end
    })
  },
})

-- TODO potentially better completion sorting:
-- https://github.com/hrsh7th/nvim-cmp/issues/156#issuecomment-916338617

-- format on save
--vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]
