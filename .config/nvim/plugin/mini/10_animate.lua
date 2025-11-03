-- ┌───────────────┐
-- │ Mini.animate  │
-- └───────────────┘
--
-- Animate common Neovim actions. Like cursor movement, scroll, window resize,
-- window open, window close. Animations are done based on Neovim events and
-- don't require custom mappings.
--
-- It is not enabled by default because its effects are a matter of taste.
-- Also scroll and resize have some unwanted side effects (see `:h mini.animate`).
-- Uncomment next line (use `gcc`) to enable.

MiniDeps.later(function()
  local animate = require('mini.animate')
  animate.setup({
    cursor = {
      path = animate.gen_path.line({
        -- Enable animation when moving horizontally within the same line as
        -- long as the jump is more than 30 cols. By default, animation is
        -- disabled when moving horizontally.
        predicate = function(dest)
          local rows, cols = unpack(dest)
          return math.abs(rows) > 1 or math.abs(cols) > 30
        end,
      }),
    },
  })
end)
