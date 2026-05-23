local M = {}

local repeatMaxCounter = 30
local durationWindowInMs = 1500

function M.norepeat()
  ---@type table?
  local id
  local ok = true
  for _, key in ipairs({ "j", "k", "h", "l", "+", "-" }) do -- focus more on horizontal in line repeat
    local count = 0
    local timer = assert(vim.loop.new_timer())
    local map = key
    vim.keymap.set("n", key, function()
      if vim.v.count > 0 then
        count = 0
      end
      if count >= repeatMaxCounter then
        ok, id = pcall(vim.notify, "Hold it! Don't Repeat!", vim.log.levels.WARN, {
          icon = "•`_´•",
          replace = id,
          keep = function()
            return count >= repeatMaxCounter
          end,
        })
        if not ok then
          id = nil
          return map
        end
      else
        count = count + 1
        timer:start(durationWindowInMs, 0, function()
          count = 0
        end)
        return map
      end
    end, { expr = true, silent = true })
  end
end

return M
