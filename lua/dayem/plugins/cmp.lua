return {
  "hrsh7th/nvim-cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-cmdline",
    "f3fora/cmp-spell",
    "onsails/lspkind.nvim",
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local lspkind = require("lspkind")
    local lsp_utils = require("dayem.utils.lsp")

    require("luasnip.loaders.from_vscode").lazy_load()
    require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/lua/dayem/snippets" })

    local function in_snippet()
      return luasnip.session.current_nodes[vim.api.nvim_get_current_buf()] and true or false
    end

    local function in_whitespace()
      local col = vim.fn.col(".") - 1
      return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
    end

    local function in_leading_indent()
      local col = vim.fn.col(".")
      local line = vim.fn.getline(".")
      return line:sub(1, col):match("^%s*$") ~= nil
    end

    local function smart_tab()
      if cmp.visible() then
        if #cmp.get_entries() == 1 then
          cmp.confirm({ select = true })
        else
          cmp.select_next_item()
        end
      elseif luasnip.locally_jumpable(1) then
        luasnip.jump(1)
      elseif in_whitespace() then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
      else
        cmp.complete()
      end
    end

    local function smart_bs()
      if luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      elseif in_leading_indent() then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-d>", true, false, true), "n", false)
      else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<BS>", true, false, true), "n", false)
      end
    end

    local function confirm(opts)
      opts = vim.tbl_extend("force", {
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
      }, opts or {})
      return function(fallback)
        if cmp.visible() and cmp.get_selected_entry() then
          cmp.confirm(opts)
        else
          fallback()
        end
      end
    end

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-j>"] = cmp.mapping.select_next_item(),
        ["<C-k>"] = cmp.mapping.select_prev_item(),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
        ["<Tab>"] = cmp.mapping(smart_tab, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(smart_bs, { "i", "s" }),
      }),
      sources = cmp.config.sources({
        { name = "luasnip", priority = 1000 },
        { name = "nvim_lsp", priority = 900 },
        { name = "buffer", priority = 700 },
        { name = "path", priority = 600 },
        {
          name = "spell",
          priority = 500,
          option = {
            enable_in_context = function()
              local filetype = vim.bo.filetype
              return filetype == "markdown" or filetype == "text"
            end,
          },
        },
      }),
      formatting = {
        format = lspkind.cmp_format({
          mode = "symbol_text",
          maxwidth = 50,
          ellipsis_char = "...",
          symbol_map = {
            Text = "󰉿",
            Method = "󰆧",
            Function = "󰊕",
            Constructor = "",
            Field = "󰜢",
            Variable = "󰀫",
            Class = "󰠱",
            Interface = "",
            Module = "",
            Property = "󰜢",
            Unit = "󰑭",
            Value = "󰎠",
            Enum = "",
            Keyword = "󰌋",
            Snippet = "",
            Color = "󰏘",
            File = "󰈙",
            Reference = "󰈇",
            Folder = "󰉋",
            EnumMember = "",
            Constant = "󰏿",
            Struct = "󰙅",
            Event = "",
            Operator = "󰆕",
            TypeParameter = "",
          },
          before = function(entry, vim_item)
            vim_item.menu = ({
              nvim_lsp = "[LSP]",
              luasnip = "[LuaSnip]",
              buffer = "[Buffer]",
              path = "[Path]",
              spell = "[Spell]",
            })[entry.source.name]
            return vim_item
          end,
        }),
      },
    })

    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
        { name = "cmdline" },
      }),
    })
  end,
}
