--[[
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
--]]

local grap_block = {
   type = "selector",
   children = {
      -- touch down
      {
         type = "sequence",
         children = {
            -- hand empty ?
            function()
               print("check empty")
               if robot.rangefinders["underneath"].proximity == 0 or 
                  robot.rangefinders["underneath"].proximity > 0.005 then
                  return false, true -- not running, true
               else
                  return false, false -- not running, false
               end
            end,
            function()
               print("set down")
               robot.lift_system.set_position(0)
               return true
            end,
         },
      },
      -- count and raise
      {
         type = "sequence*",
         children = {
            -- wait
            function()
               print("wait")
               return false, true
            end,
            -- raise 
            function()
               print("raising")
               robot.lift_system.set_position(robot.lift_system.position + 0.05)
               return false, true  -- not running, true
            end,
         },
      },
   }
}

return grap_block
