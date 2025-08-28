--          ╔═════════════════════════════════════════════════════════╗
--          ║                          MVIM                           ║
--          ╚═════════════════════════════════════════════════════════╝

-- mini setup
local path_package = vim.fn.stdpath("data") .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.nvim"
if not vim.uv.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/nvim-mini/mini.nvim",
    mini_path,
  }
  vim.fn.system(clone_cmd)
  vim.cmd("packadd mini.nvim | helptags ALL")
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- mini.deps base setup
require("mini.deps").setup({ path = { package = path_package } })

local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- Neovim Options
now(function()
  vim.g.mapleader = ","
  vim.o.number = true
  vim.o.relativenumber = false
  vim.o.laststatus = 2
  vim.o.list = true
  vim.o.listchars = table.concat({ "extends:…", "nbsp:␣", "precedes:…", "tab:> " }, ",")
  vim.o.autoindent = true
  vim.o.shiftwidth = 2
  vim.o.tabstop = 2
  vim.o.expandtab = true
  vim.o.scrolloff = 10
  vim.o.clipboard = "unnamed,unnamedplus"
  vim.o.updatetime = 1000
  vim.opt.iskeyword:append("-")
  vim.o.spelllang = "pl,en"
  vim.o.spelloptions = "camel"
  vim.opt.complete:append("kspell")
  vim.o.path = vim.o.path .. ",**"
  vim.o.tags = vim.o.tags .. ",/home/michab/.config/nvim/tags"
  -- don't save blank buffers to sessions (like neo-tree, trouble etc.)
  vim.opt.sessionoptions:remove('blank')
end)

-- Neovide Configuration
now(function()
  if vim.g.neovide then
    vim.g.neovide_scroll_animation_length = 0.1
    vim.opt.mousescroll = "ver:10,hor:6"
    vim.g.neovide_theme = "dark"

    vim.g.neovide_floating_shadow = true
    vim.g.neovide_floating_z_height = 2
    vim.g.neovide_light_angle_degrees = 45
    vim.g.neovide_light_radius = 15

    vim.g.neovide_floating_blur_amount_x = 10.0
    vim.g.neovide_floating_blur_amount_y = 10.0

    vim.o.guicursor =
    "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait100-blinkoff700-blinkon700-Cursor/lCursor,sm:block-blinkwait0-blinkoff300-blinkon300"
    vim.g.neovide_cursor_animation_length = 0.03
    vim.g.neovide_cursor_smooth_blink = true
    vim.g.neovide_cursor_vfx_mode = "pixiedust"
  end
end)

later(function() require("mini.align").setup() end)
later(function()
  local animate = require("mini.animate")
  animate.setup({
    scroll = {
      -- Disable Scroll Animations, as the can interfer with mouse Scrolling
      enable = false,
    },
    cursor = {
      timing = animate.gen_timing.cubic({ duration = 50, unit = "total" }),
    },
  })
end)

now(function()
  require("mini.basics").setup({
    options = {
      basic = true,
      extra_ui = true,
      win_borders = "bold",
    },
    mappings = {
      basic = true,
      windows = true,
    },
    autocommands = {
      basic = true,
      relnum_in_visual_mode = true,
    },
  })
end)
later(function() require("mini.bracketed").setup() end)
later(function()
  require("mini.ai").setup({
    n_lines = 500
  })
end)
later(function() require("mini.bufremove").setup() end)
later(function()
  require("mini.clue").setup({
    triggers = {
      -- Leader triggers
      { mode = "n", keys = "<Leader>" },
      { mode = "x", keys = "<Leader>" },

      { mode = "n", keys = "\\" },

      -- Basics
      { mode = "n", keys = [[\]] },

      -- Built-in completion
      { mode = "i", keys = "<C-x>" },

      -- `g` key
      { mode = "n", keys = "g" },
      { mode = "x", keys = "g" },

      -- Surround
      { mode = "n", keys = "s" },

      -- Bracketed
      { mode = 'n', keys = '[' },
      { mode = 'n', keys = ']' },
      { mode = 'x', keys = '[' },
      { mode = 'x', keys = ']' },
      -- Marks
      { mode = "n", keys = "'" },
      { mode = "n", keys = "`" },
      { mode = "x", keys = "'" },
      { mode = "x", keys = "`" },

      -- Registers
      { mode = "n", keys = '"' },
      { mode = "x", keys = '"' },
      { mode = "i", keys = "<C-r>" },
      { mode = "c", keys = "<C-r>" },

      -- Window commands
      { mode = "n", keys = "<C-w>" },

      -- `z` key
      { mode = "n", keys = "z" },
      { mode = "x", keys = "z" },
    },

    clues = {
      { mode = "n", keys = "<Leader>b", desc = " Buffer" },
      { mode = "n", keys = "<Leader>f", desc = " Find" },
      { mode = "n", keys = "<Leader>g", desc = "󰊢 Git" },
      { mode = "n", keys = "<Leader>i", desc = "󰏪 Insert" },
      { mode = "n", keys = "<Leader>l", desc = "󰘦 LSP" },
      { mode = "n", keys = "<Leader>m", desc = " Mini" },
      { mode = "n", keys = "<Leader>q", desc = " NVim" },
      { mode = "n", keys = "<Leader>s", desc = "󰆓 Session" },
      { mode = "n", keys = "<Leader>s", desc = " Terminal" },
      { mode = "n", keys = "<Leader>u", desc = "󰔃 UI" },
      { mode = "n", keys = "<Leader>w", desc = " Window" },
      { mode = "n", keys = "<Leader>v", desc = "󰌕 Visits" },
      require("mini.clue").gen_clues.g(),
      require("mini.clue").gen_clues.builtin_completion(),
      require("mini.clue").gen_clues.marks(),
      require("mini.clue").gen_clues.registers(),
      require("mini.clue").gen_clues.windows(),
      require("mini.clue").gen_clues.z(),
    },
    window = {
      delay = 300,
      config = { width = "auto" }
    },
  })
end)
later(function() require('mini.colors').setup() end)
later(function() require("mini.comment").setup() end)
-- later(function()
--   require("mini.completion").setup({
--     mappings = {
--       go_in = "<RET>",
--     },
--     window = {
--       info = { border = "solid" },
--       signature = { border = "solid" },
--     },
--   })
-- end)
later(function()
  require("mini.cursorword").setup()
  vim.api.nvim_set_hl(0, "MiniCursorword", { underline = true })
  vim.api.nvim_set_hl(0, "MiniCursorwordCurrent", { underline = false, bg = NONE })
end)
later(function()
  require("mini.diff").setup({
    view = {
      style = "sign",
      signs = { add = "█", change = "▒", delete = "" },
    },
  })
end)
later(function() require("mini.doc").setup() end)
later(function() require("mini.extra").setup() end)
later(function()
  require("mini.files").setup({
    mappings = {
      close = 'q',
    },
    windows = {
      preview = true,
      border = "rounded",
      width_preview = 80,
    },
  })
end)
later(function() require("mini.fuzzy").setup() end)
later(function() require("mini.git").setup() end)
later(function()
  local hipatterns = require("mini.hipatterns")

  local censor_extmark_opts = function(_, match, _)
    local mask = string.rep("*", vim.fn.strchars(match))
    return {
      virt_text = { { mask, "Comment" } },
      virt_text_pos = "overlay",
      priority = 200,
      right_gravity = false,
    }
  end

  -- This is a custom "hide my password" solution
  -- Add patterns to match below
  -- toggle with <leader>up
  local password_table = {
    pattern = {
      "password: ()%S+()",
      "password_usr: ()%S+()",
      "_pw: ()%S+()",
      "password_asgard_read: ()%S+()",
      "password_elara_admin: ()%S+()",
      "gpg_pass: ()%S+()",
      "passwd: ()%S+()",
      "secret: ()%S+()",
    },
    group = "",
    extmark_opts = censor_extmark_opts,
  }

  hipatterns.setup({
    highlighters = {
      -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
      fixme       = { pattern = "() FIXME():", group = "MiniHipatternsFixme" },
      hack        = { pattern = "() HACK():", group = "MiniHipatternsHack" },
      todo        = { pattern = "() TODO():", group = "MiniHipatternsTodo" },
      note        = { pattern = "() NOTE():", group = "MiniHipatternsNote" },
      fixme_colon = { pattern = " FIXME():()", group = "MiniHipatternsFixmeColon" },
      hack_colon  = { pattern = " HACK():()", group = "MiniHipatternsHackColon" },
      todo_colon  = { pattern = " TODO():()", group = "MiniHipatternsTodoColon" },
      note_colon  = { pattern = " NOTE():()", group = "MiniHipatternsNoteColon" },
      fixme_body  = { pattern = " FIXME:().*()", group = "MiniHipatternsFixmeBody" },
      hack_body   = { pattern = " HACK:().*()", group = "MiniHipatternsHackBody" },
      todo_body   = { pattern = " TODO:().*()", group = "MiniHipatternsTodoBody" },
      note_body   = { pattern = " NOTE:().*()", group = "MiniHipatternsNoteBody" },
      -- Cloaking Passwords
      pw          = password_table,

      -- Highlight hex color strings (`#rrggbb`) using that color
      hex_color   = hipatterns.gen_highlighter.hex_color(),
    },
  })

  vim.keymap.set("n", "<leader>up", function()
    if next(hipatterns.config.highlighters.pw) == nil then
      hipatterns.config.highlighters.pw = password_table
    else
      hipatterns.config.highlighters.pw = {}
    end
    vim.cmd("edit")
  end, { desc = "Toggle Password Cloaking" })
end)

-- Disabled as we use randomhue
-- Enable this for a modus Operandi inspired Colorscheme
--
later(function()
  vim.cmd("colorscheme miniautumn")
end)
now(function()
  require("mini.icons").setup({
    use_file_extension = function(ext, _)
      local suf3, suf4 = ext:sub(-3), ext:sub(-4)
      return suf3 ~= "scm" and suf3 ~= "txt" and suf3 ~= "yml" and suf4 ~= "json" and suf4 ~= "yaml"
    end,
  })
  later(MiniIcons.mock_nvim_web_devicons)
  later(MiniIcons.tweak_lsp_kind)
end)
later(function()
  require("mini.indentscope").setup({
    draw = {
      animation = function()
        return 1
      end,
    },
    symbol = "│",
  })
end)
later(function() require("mini.jump").setup() end)
later(function() require("mini.jump2d").setup() end)
later(function()
  require("mini.keymap").setup()
  local map_combo = require('mini.keymap').map_combo

  -- Support most common modes. This can also contain 't', but would
  -- only mean to press `<Esc>` inside terminal.
  local mode = { 'i', 'c', 'x', 's' }
  map_combo(mode, 'jk', '<BS><BS><Esc>')

  -- To not have to worry about the order of keys, also map "kj"
  map_combo(mode, 'kj', '<BS><BS><Esc>')

  local map_multistep = require('mini.keymap').map_multistep

  map_multistep('i', '<Tab>', { 'pmenu_next' })
  map_multistep('i', '<S-Tab>', { 'pmenu_prev' })
  map_multistep('i', '<CR>', { 'pmenu_accept', 'minipairs_cr' })
  map_multistep('i', '<BS>', { 'minipairs_bs' })
end)
later(function() require("mini.map").setup() end)
later(function()
  require("mini.misc").setup({ make_global = { "put", "put_text", "stat_summary", "bench_time" } })
  MiniMisc.setup_auto_root()
  MiniMisc.setup_restore_cursor()
  MiniMisc.setup_termbg_sync()
end)
later(function()
  require("mini.move").setup({
    mappings = {
      -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
      left = '<M-S-h>',
      right = '<M-S-l>',
      down = '<M-S-j>',
      up = '<M-S-k>',

      -- Move current line in Normal mode
      line_left = '<M-S-h>',
      line_right = '<M-S-l>',
      line_down = '<M-S-j>',
      line_up = '<M-S-k>',
    },
  }
  )
end)
later(function()
  local predicate = function(notif)
    if not (notif.data.source == "lsp_progress" and notif.data.client_name == "lua_ls") then
      return true
    end
    -- Filter out some LSP progress notifications from 'lua_ls'
    return notif.msg:find("Diagnosing") == nil and notif.msg:find("semantic tokens") == nil
  end
  local custom_sort = function(notif_arr)
    return MiniNotify.default_sort(vim.tbl_filter(predicate, notif_arr))
  end
  require("mini.notify").setup({
    content = { sort = custom_sort },
    window = { max_width_share = 0.75, config = { border = "solid" } },
  })
  vim.notify = MiniNotify.make_notify()
end)
later(function() require("mini.operators").setup() end)
later(function() require("mini.pairs").setup() end)
later(function()
  local win_config = function()
    local height = math.floor(0.618 * vim.o.lines)
    local width = math.floor(0.4 * vim.o.columns)
    return {
      anchor = "NW",
      height = height,
      width = width,
      border = "solid",
      row = math.floor(0.5 * (vim.o.lines - height)),
      col = math.floor(0.5 * (vim.o.columns - width)),
    }
  end
  require("mini.pick").setup({
    mappings = {
      choose_in_vsplit = "<C-CR>",
    },
    options = {
      use_cache = true,
    },
    window = {
      config = win_config,
    },
  })
  vim.ui.select = MiniPick.ui_select
end)
now(function()
  require("mini.sessions").setup({
    autowrite = true,
  })
end)
later(function() require("mini.splitjoin").setup() end)
later(function()
  local gen_loader = require('mini.snippets').gen_loader
  require('mini.snippets').setup({
    snippets = {
      -- Load custom file with global snippets first (adjust for Windows)
      gen_loader.from_file('~/.config/nvim/snippets/global.json'),

      -- Load snippets based on current language by reading files from
      -- "snippets/" subdirectories from 'runtimepath' directories.
      gen_loader.from_lang(),
    },
  })
end)
now(function()
  Mvim_starter_custom = function()
    return {
      { name = "Recent Files", action = function() require("mini.extra").pickers.oldfiles() end, section = "Search" },
      { name = "Session",      action = function() require("mini.sessions").select() end,        section = "Search" },
      { name = "Mason",        action = "Mason",                                                 section = "Updaters" },
      { name = "Update deps",  action = "DepsUpdate",                                            section = "Updaters" },
    }
  end
  require("mini.starter").setup({
    autoopen = true,
    items = {
      -- require("mini.starter").sections.builtin_actions(),
      Mvim_starter_custom(),
      require("mini.starter").sections.recent_files(5, false, false),
      require("mini.starter").sections.recent_files(5, true, false),
      require("mini.starter").sections.sessions(5, true),
    },
    header = function()
      local v = vim.version()
      local versionstring = string.format("  Neovim Version: %d.%d.%d", v.major, v.minor, v.patch)
      local image = [[
┌─────────────────────────────────────────┐
│                                         │
│    ███╗   ███╗██╗   ██╗██╗███╗   ███╗   │
│    ████╗ ████║██║   ██║██║████╗ ████║   │
│    ██╔████╔██║██║   ██║██║██╔████╔██║   │
│    ██║╚██╔╝██║╚██╗ ██╔╝██║██║╚██╔╝██║   │
│    ██║ ╚═╝ ██║ ╚████╔╝ ██║██║ ╚═╝ ██║   │
│    ╚═╝     ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝   │
└─────────────────────────────────────────┘
]]
      finalimage = image .. versionstring
      return finalimage
    end
  })
end)
now(function()
  require("mini.statusline").setup({
    content = {
      active = function()
        local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
        local git           = MiniStatusline.section_git({ trunc_width = 40 })
        local filename      = MiniStatusline.section_filename({ trunc_width = 140 })
        local fileinfo      = MiniStatusline.section_fileinfo({ trunc_width = 120 })
        local search        = MiniStatusline.section_searchcount({ trunc_width = 75 })

        return MiniStatusline.combine_groups({
          { hl = mode_hl,                 strings = { mode } },
          { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics, lsp } },
          '%<', -- Mark general truncate point
          { hl = 'MiniStatuslineFilename', strings = { filename } },
          '%=', -- End left alignment
          { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
          { hl = mode_hl,                  strings = { search, location } },
        })
      end,
      inactive = nil,
    },
  })
end)
now(function() require("mini.tabline").setup() end)
later(function() require("mini.surround").setup() end)
later(function() require("mini.trailspace").setup() end)
later(function() require("mini.visits").setup() end)

require("filetypes")
require("highlights")
require("keybinds")

-- If you want to add additional personal Plugins
-- add lua/personal.lua as a file and configure what ever you need
local path_modules = vim.fn.stdpath("config") .. "/lua/"
if vim.uv.fs_stat(path_modules .. "personal.lua") then
  require("personal")
end
