local api = require("BuilderBotAPI")

local grap_block = {
   type = "sequence",
   children = {
      function()
         print("I am sequence 1")
         if #api.blocks == 2 then
            return false, true -- not running, finish true
         else
            return true, false -- running, false
         end
      end,
      function()
         print("I am sequence 2")
         robot.lift_system.set_position(0.07)
         return true, true
      end,
      function()
         print("I am sequence 3")
         return true, true
      end,
   }
}

return grap_block
