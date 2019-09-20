local create_count_node = require("count_node")
local create_reach_block = require("reach_block")

local create_pickup_block = function(target, _forward_distance)
return -- return the following table
{
   type = "sequence*",
   children = {
      -- recharge
      function()
         robot.electromagnet_system.set_discharge_mode("disable")
      end,
      -- reach the block
      create_reach_block(target, _forward_distance),
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
            -- attrack magnet
            function()
               robot.electromagnet_system.set_discharge_mode("constructive")
            end,
            -- wait for 2 sec
            create_count_node({start = 0, finish = 2, speed = 1,}),
            -- raise 
            function()
               print("raising")
               robot.lift_system.set_position(robot.lift_system.position + 0.05)
               return false, true  -- not running, true
            end,
            -- recharge magnet
            function()
               robot.electromagnet_system.set_discharge_mode("disable")
            end,
         },
      },
   }
}

end
return create_pickup_block
