return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "olimorris/neotest-phpunit",
    "nvim-neotest/neotest-go",
    "nvim-neotest/neotest-python",
    "nvim-neotest/neotest-jest",
    "marilari88/neotest-vitest",
  },
  config = function()
    local neotest = require("neotest")

    neotest.setup({
      adapters = {
        require("neotest-phpunit")({
          phpunit_cmd = function()
            return "vendor/bin/pest"
          end,
          filter_dirs = { ".git", "node_modules", "vendor" },
          env = {
            XDEBUG_CONFIG = "idekey=neotest",
          },
          dap = nil,
        }),

        require("neotest-go")({
          experimental = {
            test_table = true,
          },
          args = { "-v", "-count=1", "-timeout=60s" },
        }),

        require("neotest-python")({
          dap = nil,
          args = { "-v" },
          runner = "pytest",
        }),

        require("neotest-jest")({
          jestCommand = "npm test --",
          jestConfigFile = "jest.config.js",
          env = { CI = true },
          cwd = function()
            return vim.fn.getcwd()
          end,
        }),

        require("neotest-vitest")({
          filter_dir = function(name)
            return name ~= "node_modules"
          end,
        }),
      },

      discovery = {
        enabled = true,
        concurrent = 8,
      },

      running = {
        concurrent = true,
      },

      summary = {
        enabled = true,
        animated = true,
        follow = true,
        expand_errors = true,
        mappings = {
          attach = "a",
          clear_marked = "M",
          clear_target = "T",
          debug = "d",
          debug_marked = "D",
          expand = { "<CR>", "<2-LeftMouse>" },
          expand_all = "e",
          jumpto = "i",
          mark = "m",
          next_failed = "J",
          output = "o",
          prev_failed = "K",
          run = "r",
          run_marked = "R",
          short = "O",
          stop = "u",
          target = "t",
          watch = "w",
        },
      },

      output = {
        enabled = true,
        open_on_run = false,
      },

      output_panel = {
        enabled = true,
        open = "botright vsplit | resize 15",
      },

      quickfix = {
        enabled = true,
        open = false,
      },

      status = {
        enabled = true,
        virtual_text = true,
        signs = true,
      },

      icons = {
        passed = "✓",
        running = "⟳",
        failed = "✗",
        skipped = "⊘",
        unknown = "?",
        running_animated = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
      },

      floating = {
        border = "rounded",
        max_height = 0.8,
        max_width = 0.9,
        options = {},
      },

      strategies = {
        integrated = {
          height = 40,
          width = 120,
        },
      },

      diagnostic = {
        enabled = true,
        severity = vim.diagnostic.severity.ERROR,
      },

      highlights = {
        adapter_name = "NeotestAdapterName",
        border = "NeotestBorder",
        dir = "NeotestDir",
        expand_marker = "NeotestExpandMarker",
        failed = "NeotestFailed",
        file = "NeotestFile",
        focused = "NeotestFocused",
        indent = "NeotestIndent",
        marked = "NeotestMarked",
        namespace = "NeotestNamespace",
        passed = "NeotestPassed",
        running = "NeotestRunning",
        select_win = "NeotestWinSelect",
        skipped = "NeotestSkipped",
        target = "NeotestTarget",
        test = "NeotestTest",
        unknown = "NeotestUnknown",
        watching = "NeotestWatching",
      },
    })
  end,
}
