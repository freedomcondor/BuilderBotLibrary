local create_count_node = require("count_node")
local pickup_block = {
   type = "sequence*",
   children = {
      -- touch down
      {
         type = "selector",
         children = {
            -- hand full ?
            function()
               print("check full")
               if robot.rangefinders["underneath"].proximity ~= 0 and
                  robot.rangefinders["underneath"].proximity < 0.005 then
                  return false, true -- not running, true
               else
                  return false, false -- not running, false
               end
            end,
            -- low lift
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
            -- wait for 2 sec
            create_count_node(0, 2, 1),
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

return pickup_block
