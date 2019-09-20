local create_reach_block = require("reach_block")
local create_count_node = require("count_node")

local create_place_block = function(target, _forward_distance)
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
      -- drop electromagnet
      function()
         robot.electromagnet_system.set_discharge_mode("destructive")
         return false, true
      end,
      -- wait for 2 sec
      create_count_node({start = 0, finish = 2, speed = 1,}),
      -- recharge magnet
      function()
         robot.electromagnet_system.set_discharge_mode("disable")
      end,
   },
}
end

return create_place_block
