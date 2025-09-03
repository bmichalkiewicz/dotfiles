local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
local now_if_args = vim.fn.argc(-1) > 0 and now or later

now_if_args(function() -- treesitter
  add({
    source = "nvim-treesitter/nvim-treesitter",
    checkout = "main",
    hooks = {
      post_checkout = function()
        vim.cmd("TSUpdate")
      end,
    },
  })
  add({ source = "nvim-treesitter/nvim-treesitter-textobjects", checkout = "main" })
  add({ source = "nvim-treesitter/nvim-treesitter-context" })

  local ensure_installed = {
    "bash",
    "css",
    "go",
    "helm",
    "html",
    "json",
    "lua",
    "markdown",
    "markdown_inline",
    "python",
    "regex",
    "toml",
    "yaml",
  }
  require("nvim-treesitter").install(ensure_installed)
  local filetypes = vim.iter(ensure_installed):map(vim.treesitter.language.get_filetypes):flatten():totable()
  vim.list_extend(filetypes, { "markdown", "pandoc" })
  vim.api.nvim_create_autocmd("FileType", {
    pattern = filetypes,
    callback = function(ev)
      vim.treesitter.start(ev.buf)
    end,
  })

  require("treesitter-context").setup()
end)

later(function() -- blink
  add({
    source = "saghen/blink.cmp",
    depends = { "rafamadriz/friendly-snippets" },
    hooks = {
      post_install = Config.build_blink,
      post_checkout = Config.build_blink,
    },
  })

  require("blink.cmp").setup({
    keymap = {
      preset = "enter",
      -- defer these to mini.keymap binding
      ["<Tab>"] = { "fallback" },
      ["<S-Tab>"] = { "fallback" },
    },
    completion = {
      list = { selection = { preselect = false } },
      documentation = { auto_show = true },
      menu = {
        draw = {
          components = {
            kind_icon = {
              text = function(ctx)
                local kind_icon, _, _ = MiniIcons.get("lsp", ctx.kind)
                return kind_icon
              end,
              highlight = function(ctx)
                local _, hl, _ = MiniIcons.get("lsp", ctx.kind)
                return hl
              end,
            },
          },
        },
      },
    },
    appearance = { nerd_font_variant = "normal" },
    snippets = { preset = "mini_snippets" },
    signature = { enabled = true },
  })
end)

later(function() -- mason
  add("mason-org/mason.nvim")
  add("mason-org/mason-lspconfig.nvim")

  require("mason").setup()

  require("mason-lspconfig").setup({
    ensure_installed = {
      "gopls",
      "lua_ls",
      "basedpyright",
      "marksman",
      "helm_ls",
      "jsonls",
      "yamlls",
    },
    automatic_installation = true,
  })
end)

later(function() -- conform
  add("stevearc/conform.nvim")

  require("conform").setup({
    notify_on_error = true,
    format_on_save = function(bufnr)
      if vim.g.disable_autoformat then
        return
      end
      return { timeout_ms = 2000, lsp_format = "fallback" }
    end,
    formatters_by_ft = {
      css        = { "prettierd" },
      html       = { "prettierd" },
      json       = { "prettier" },
      lua        = { "stylua" },
      markdown   = { "prettierd" },
      go         = { "gofmt" },
    },
  })

  vim.api.nvim_create_user_command("FormatToggle", function(_)
    vim.g.disable_autoformat = not vim.g.disable_autoformat
    local state = vim.g.disable_autoformat and "disabled" or "enabled"
    vim.notify("Auto-save " .. state)
  end, {
    desc = "Toggle autoformat-on-save",
  })
end)

later(function() -- lazydev
  add("folke/lazydev.nvim")
  require("lazydev").setup()
end)

later(function() -- leap
  add("ggandor/leap.nvim")
  require("leap.user").set_repeat_keys("<CR>", "<BS>")
  require("leap").opts.equivalence_classes = { " \t\r\n", "([{", ")]}", "'\"`" }
end)

later(function() -- lsp
  add("neovim/nvim-lspconfig")

  vim.diagnostic.config({
    underline = false,
    update_in_insert = false,
    severity_sort = true,
  })

  vim.lsp.enable({
    "gopls",
    "bashls",
    "ansiblels",
    "lua_ls",
    "basedpyright",
    "marksman",
    "helm_ls",
    "jsonls",
    "yamlls",
  })

  vim.lsp.config["*"] = {
    capabilities = {
      workspace = {
        fileOperations = {
          didRename = true,
          willRename = true,
        },
      },
    },
  }
end)

later(function() -- quicker
  add("stevearc/quicker.nvim")
  require("quicker").setup({
    keys = {
      { ">", "<Cmd>lua require('quicker').expand({ add_to_existing = true })<Cr>", desc = "Expand quickfix context" },
      { "<", "<Cmd>lua require('quicker').collapse()<Cr>",                         desc = "Collapse quickfix context" },
    },
  })
end)

later(function() -- render-markdown
  add("MeanderingProgrammer/render-markdown.nvim")
  require("render-markdown").setup({
    file_types = { "markdown", "md" },
    render_modes = { "n", "no", "c", "t", "i", "ic" },
    checkbox = {
      enable = true,
      position = "inline",
    },
    code = {
      sign = false,
      border = "thin",
      position = "right",
      width = "block",
      above = "▁",
      below = "▔",
      language_left = "█",
      language_right = "█",
      language_border = "▁",
      left_pad = 1,
      right_pad = 1,
    },
    heading = {
      width = "block",
      backgrounds = {
        "MiniStatusLineModeNormal",
        "MiniStatusLineModeInsert",
        "MiniStatusLineModeOther",
        "MiniStatusLineModeReplace",
        "MiniStatusLineModeCommand",
        "MiniStatusLineModeVisual",
      },
      sign = false,
      left_pad = 1,
      right_pad = 0,
      position = "right",
      icons = { "", "", "", "", "", "" },
    },
  })
end)

later(function() -- nvim-autopairs
  add("windwp/nvim-autopairs")
  require("nvim-autopairs").setup()
end)

later(function() -- nvim-lint
  add("mfussenegger/nvim-lint")
  local lint = require("lint")
  lint.linters_by_ft = {
    markdown = { "markdownlint-cli2" },
    sh = { "shellcheck" },
  }

  local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    group = lint_augroup,
    callback = function()
      lint.try_lint()
    end,
  })
end)

later(function() -- toggleterm
  add("akinsho/toggleterm.nvim")

  require("toggleterm").setup({
    highlights = { FloatBorder = { link = "FloatBorder" } },
    open_mapping = [[<c-\>]],
    on_create = function(term)
      local opts = { buffer = term.bufnr }
      vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", opts)
    end,
    shading_factor = -20,
  })

  Config.lazygit_toggle = function()
    local lazygit = require("toggleterm.terminal").Terminal:new({
      cmd = "lazygit",
      hidden = true,
      highlights = { FloatBorder = { link = "FloatBorder" } },
      direction = "float",
      on_open = function(term)
        vim.keymap.del("t", "<Esc><Esc>", { buffer = term.bufnr })
      end,
    })
    lazygit:toggle()
  end
end)

now_if_args(function() -- vim-helm
  add("towolf/vim-helm")
end)

-- Colorschemes  
now(function() -- gruvbox
  add("ellisonleao/gruvbox.nvim")
  
  require("gruvbox").setup({
    terminal_colors = true,
    undercurl = true,
    underline = true,
    bold = true,
    italic = {
      strings = true,
      emphasis = true,
      comments = true,
      operators = false,
      folds = true,
    },
    strikethrough = true,
    invert_selection = false,
    invert_signs = false,
    invert_tabline = false,
    invert_intend_guides = false,
    inverse = true,
    contrast = "", -- can be "hard", "soft" or empty string
    palette_overrides = {},
    overrides = {
      MiniHipatternsFixmeBody = { fg = "#fb4934" },
      MiniHipatternsFixme = { fg = "#1d2021", bg = "#fb4934" },
      MiniHipatternsFixmeColon = { bg = "#fb4934", fg = "#fb4934", bold = true },

      MiniHipatternsHackBody = { fg = "#fe8019" },
      MiniHipatternsHack = { fg = "#1d2021", bg = "#fe8019" },
      MiniHipatternsHackColon = { bg = "#fe8019", fg = "#fe8019", bold = true },

      MiniHipatternsNoteBody = { fg = "#fabd2f" },
      MiniHipatternsNote = { fg = "#1d2021", bg = "#fabd2f" },
      MiniHipatternsNoteColon = { bg = "#fabd2f", fg = "#fabd2f", bold = true },

      MiniHipatternsTodoBody = { fg = "#83a598" },
      MiniHipatternsTodo = { fg = "#1d2021", bg = "#83a598" },
      MiniHipatternsTodoColon = { bg = "#83a598", fg = "#83a598", bold = true },

      MiniJump = { sp = "#fabd2f", undercurl = true },

      MiniStatuslineDirectory = { fg = "#928374" },
      MiniStatuslineFilenameModified = { fg = "#fb4934", bold = true },

      NormalNC = { link = "Normal" },

      RenderMarkdownBullet = { fg = "#8ec07c" },
      RenderMarkdownCodeBorder = { bg = "#1d2021" },
      RenderMarkdownTableHead = { fg = "#928374" },
      RenderMarkdownTableRow = { fg = "#928374" },

      Search = { sp = "#fabd2f", underdouble = true },

      ["@markup.heading"] = { fg = "#8ec07c", bold = true },
      ["@markup.heading.1"] = { italic = false },
      ["@markup.heading.2"] = { italic = false },
      ["@markup.heading.3"] = { italic = false },
      ["@markup.heading.4"] = { italic = false },
      ["@markup.heading.5"] = { italic = false },
      ["@markup.heading.6"] = { italic = false },
      ["@markup.strong"] = { fg = "#8ec07c", bold = true },
      ["@markup.italic"] = { fg = "#8ec07c", italic = true },

      ["@lsp.typemod.type.defaultLibrary"] = { fg = "#fb4934" },
    },
    dim_inactive = false,
    transparent_mode = vim.fn.expand("$NEOVIM_TRANSPARENT") == "1",
  })
  
  vim.cmd.colorscheme("gruvbox")
end)

later(function() -- catppuccin
  add({ source = "catppuccin/nvim", name = "catppuccin" })
  require("catppuccin").setup({
    default_integrations = false,
    integrations = {
      cmp = true,
      markdown = true,
      mason = true,
      mini = { enabled = true },
      native_lsp = {
        enabled = true,
        virtual_text = {
          errors = { "italic" },
          hints = { "italic" },
          warnings = { "italic" },
          information = { "italic" },
          ok = { "italic" },
        },
        underlines = {
          errors = { "underline" },
          hints = { "underline" },
          warnings = { "underline" },
          information = { "underline" },
          ok = { "underline" },
        },
        inlay_hints = {
          background = true,
        },
      },
      semantic_tokens = true,
      treesitter = true,
      treesitter_context = true,
    },
    highlight_overrides = {
      all = function(colors)
        local overrides = {
          Folded = { bg = colors.surface0 },
          Comment = { fg = colors.overlay0, style = { "italic" } },
          RenderMarkdownCodeBorder = { bg = colors.surface0 },
          RenderMarkdownCode = { bg = colors.mantle },
          RenderMarkdownTableHead = { fg = colors.overlay0 },
          RenderMarkdownTableRow = { fg = colors.overlay0 },
          ["@markup.quote"] = { fg = colors.maroon, style = { "italic" } },
        }
        return overrides
      end,
      mocha = function(colors)
        local overrides = {
          Headline = { style = { "bold" } },
          FloatTitle = { fg = colors.green },
          WinSeparator = { fg = colors.surface1, style = { "bold" } },
          CursorLineNr = { fg = colors.lavender, style = { "bold" } },
          LeapBackdrop = { link = "MiniJump2dDim" },
          LeapLabel = { fg = colors.green, style = { "bold" } },
          MsgArea = { fg = colors.overlay2 },
          CmpItemAbbrMatch = { fg = colors.green, style = { "bold" } },
          CmpItemAbbrMatchFuzzy = { fg = colors.green, style = { "bold" } },

          MiniClueDescGroup = { fg = colors.mauve },
          MiniClueDescSingle = { fg = colors.sapphire },
          MiniClueNextKey = { fg = colors.yellow },
          MiniClueNextKeyWithPostkeys = { fg = colors.red, style = { "bold" } },

          MiniFilesCursorLine = { fg = nil, bg = colors.surface0, style = { "bold" } },
          MiniFilesFile = { fg = colors.overlay2 },
          MiniFilesTitleFocused = { fg = colors.sky, style = { "bold" } },

          MiniHipatternsFixmeBody = { fg = colors.red, bg = colors.base },
          MiniHipatternsFixmeColon = { bg = colors.red, fg = colors.red, style = { "bold" } },
          MiniHipatternsHackBody = { fg = colors.yellow, bg = colors.base },
          MiniHipatternsHackColon = { bg = colors.yellow, fg = colors.yellow, style = { "bold" } },
          MiniHipatternsNoteBody = { fg = colors.sky, bg = colors.base },
          MiniHipatternsNoteColon = { bg = colors.sky, fg = colors.sky, style = { "bold" } },
          MiniHipatternsTodoBody = { fg = colors.teal, bg = colors.base },
          MiniHipatternsTodoColon = { bg = colors.teal, fg = colors.teal, style = { "bold" } },

          MiniIndentscopeSymbol = { fg = colors.sapphire },

          MiniJump = { bg = colors.green, fg = colors.base, style = { "bold" } },
          MiniJump2dSpot = { fg = colors.peach },
          MiniJump2dSpotAhead = { fg = colors.mauve },
          MiniJump2dSpotUnique = { fg = colors.peach },

          MiniMapNormal = { fg = colors.overlay2, bg = colors.mantle },

          MiniPickMatchCurrent = { fg = nil, bg = colors.surface0, style = { "bold" } },
          MiniPickMatchRanges = { fg = colors.green, style = { "bold" } },
          MiniPickNormal = { fg = colors.overlay2, bg = colors.mantle },
          MiniPickPrompt = { fg = colors.sky, style = { "bold" } },

          MiniStarterHeader = { fg = colors.sapphire },
          MiniStarterInactive = { fg = colors.surface2, style = {} },
          MiniStarterItem = { fg = colors.overlay2, bg = nil },
          MiniStarterItemBullet = { fg = colors.surface2 },
          MiniStarterItemPrefix = { fg = colors.pink },
          MiniStarterQuery = { fg = colors.red, style = { "bold" } },
          MiniStarterSection = { fg = colors.peach, style = { "bold" } },

          MiniStatuslineDirectory = { fg = colors.overlay1, bg = colors.surface0 },
          MiniStatuslineFilename = { fg = colors.text, bg = colors.surface0, style = { "bold" } },
          MiniStatuslineFilenameModified = { fg = colors.blue, bg = colors.surface0, style = { "bold" } },
          MiniStatuslineInactive = { fg = colors.overlay1, bg = colors.surface0 },

          MiniSurround = { fg = nil, bg = colors.yellow },

          MiniTablineCurrent = { fg = colors.yellow, bg = colors.base, style = { "bold" } },
          MiniTablineFill = { bg = colors.mantle },
          MiniTablineHidden = { fg = colors.overlay1, bg = colors.surface0 },
          MiniTablineModifiedCurrent = { fg = colors.base, bg = colors.yellow, style = { "bold" } },
          MiniTablineModifiedHidden = { fg = colors.base, bg = colors.subtext0 },
          MiniTablineModifiedVisible = { fg = colors.base, bg = colors.subtext0, style = { "bold" } },
          MiniTablineTabpagesection = { fg = colors.base, bg = colors.mauve, style = { "bold" } },
          MiniTablineVisible = { fg = colors.overlay1, bg = colors.surface0, style = { "bold" } },
        }
        for _, hl in ipairs({ "Headline", "rainbow" }) do
          for i, c in ipairs({ "green", "sapphire", "mauve", "peach", "red", "yellow" }) do
            overrides[hl .. i] = { fg = colors[c], style = { "bold" } }
          end
        end
        return overrides
      end,
      macchiato = function(colors)
        local overrides = {
          CurSearch = { bg = colors.peach },
          CursorLineNr = { fg = colors.blue, style = { "bold" } },
          IncSearch = { bg = colors.peach },
          MsgArea = { fg = colors.overlay1 },
          Search = { bg = colors.mauve, fg = colors.base },
          TreesitterContext = { bg = colors.surface0 },
          TreesitterContextBottom = { sp = colors.surface1, style = { "underline" } },
          WinSeparator = { fg = colors.surface1, style = { "bold" } },
          ["@string.special.symbol"] = { link = "Special" },
          ["@constructor.lua"] = { fg = colors.pink },

          KazCodeBlock = { bg = colors.crust },

          LeapBackdrop = { link = "MiniJump2dDim" },
          LeapLabel = { fg = colors.peach, style = { "bold" } },

          MiniClueDescGroup = { fg = colors.pink },
          MiniClueDescSingle = { fg = colors.sapphire },
          MiniClueNextKey = { fg = colors.text, style = { "bold" } },
          MiniClueNextKeyWithPostkeys = { fg = colors.red, style = { "bold" } },

          MiniFilesCursorLine = { fg = nil, bg = colors.surface1, style = { "bold" } },
          MiniFilesFile = { fg = colors.overlay2 },
          MiniFilesTitleFocused = { fg = colors.peach, style = { "bold" } },

          MiniHipatternsFixmeBody = { fg = colors.red, bg = colors.base },
          MiniHipatternsFixmeColon = { bg = colors.red, fg = colors.red, style = { "bold" } },
          MiniHipatternsHackBody = { fg = colors.yellow, bg = colors.base },
          MiniHipatternsHackColon = { bg = colors.yellow, fg = colors.yellow, style = { "bold" } },
          MiniHipatternsNoteBody = { fg = colors.sky, bg = colors.base },
          MiniHipatternsNoteColon = { bg = colors.sky, fg = colors.sky, style = { "bold" } },
          MiniHipatternsTodoBody = { fg = colors.teal, bg = colors.base },
          MiniHipatternsTodoColon = { bg = colors.teal, fg = colors.teal, style = { "bold" } },

          MiniIndentscopeSymbol = { fg = colors.sapphire },

          MiniJump = { fg = colors.mantle, bg = colors.pink },
          MiniJump2dSpot = { fg = colors.peach },
          MiniJump2dSpotAhead = { fg = colors.mauve },
          MiniJump2dSpotUnique = { fg = colors.peach },

          MiniMapNormal = { fg = colors.overlay2, bg = colors.mantle },

          MiniPickBorderText = { fg = colors.blue },
          MiniPickMatchCurrent = { fg = nil, bg = colors.surface1, style = { "bold" } },
          MiniPickMatchRanges = { fg = colors.text, style = { "bold" } },
          MiniPickNormal = { fg = colors.overlay2, bg = colors.mantle },
          MiniPickPrompt = { fg = colors.sky },

          MiniStarterInactive = { fg = colors.overlay0, style = {} },
          MiniStarterItem = { fg = colors.overlay2, bg = nil },
          MiniStarterItemBullet = { fg = colors.surface2 },
          MiniStarterItemPrefix = { fg = colors.text },
          MiniStarterQuery = { fg = colors.text, style = { "bold" } },
          MiniStarterSection = { fg = colors.mauve, style = { "bold" } },

          MiniStatuslineDirectory = { fg = colors.overlay1, bg = colors.surface0 },
          MiniStatuslineFilename = { fg = colors.text, bg = colors.surface0, style = { "bold" } },
          MiniStatuslineFilenameModified = { fg = colors.blue, bg = colors.surface0, style = { "bold" } },
          MiniStatuslineInactive = { fg = colors.overlay1, bg = colors.surface0 },

          MiniSurround = { fg = nil, bg = colors.yellow },

          MiniTablineCurrent = { fg = colors.blue, bg = colors.base, style = { "bold" } },
          MiniTablineFill = { bg = colors.mantle },
          MiniTablineHidden = { fg = colors.overlay1, bg = colors.surface0 },
          MiniTablineModifiedCurrent = { fg = colors.base, bg = colors.blue, style = { "bold" } },
          MiniTablineModifiedHidden = { fg = colors.base, bg = colors.subtext0 },
          MiniTablineModifiedVisible = { fg = colors.base, bg = colors.subtext0, style = { "bold" } },
          MiniTablineTabpagesection = { fg = colors.base, bg = colors.mauve, style = { "bold" } },
          MiniTablineVisible = { fg = colors.overlay1, bg = colors.surface0, style = { "bold" } },
        }
        for _, hl in ipairs({ "Headline", "rainbow" }) do
          for i, c in ipairs({ "blue", "pink", "lavender", "green", "peach", "flamingo" }) do
            overrides[hl .. i] = { fg = colors[c], style = { "bold" } }
          end
        end
        return overrides
      end,
    },
    color_overrides = {
      macchiato = {
        rosewater = "#F5B8AB",
        flamingo = "#F29D9D",
        pink = "#AD6FF7",
        mauve = "#FF8F40",
        red = "#E66767",
        maroon = "#EB788B",
        peach = "#FAB770",
        yellow = "#FACA64",
        green = "#70CF67",
        teal = "#4CD4BD",
        sky = "#61BDFF",
        sapphire = "#4BA8FA",
        blue = "#00BFFF",
        lavender = "#00BBCC",
        text = "#C1C9E6",
        subtext1 = "#A3AAC2",
        subtext0 = "#8E94AB",
        overlay2 = "#7D8296",
        overlay1 = "#676B80",
        overlay0 = "#464957",
        surface2 = "#3A3D4A",
        surface1 = "#2F313D",
        surface0 = "#1D1E29",
        base = "#0b0b12",
        mantle = "#11111a",
        crust = "#191926",
      },
    },
  })
end)
