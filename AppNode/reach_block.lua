local create_count_node = require("count_node")

local create_reach_block = function(target, _distance)
   -- assuming I'm _distance away of the block, 
   -- shamefully forward blindly for a certain _distance
   -- based on target.offset, adjust the distance and 
   --                         raise or lower the manipulator
   --     offset could be vector3(0,0,0), means the reference block itself
   --                     vector3(1,0,0), means just infront of the reference block
   --                     vector3(0,0,1), top of the reference block
   --                     vector3(1,0,-1)
   --                     vector3(1,0,-2)

   return -- return the following table
{
   type = "sequence*",
   children = {
      -- assume I arrive the pre-position, reach it
      {
         type = "selector*",
         children = {
            -- reach the block itself
            {
               type = "sequence*",
               children = {
                  -- condition vector3(0,0,0)
                  function ()
                     if target.offset == vector3(0,0,0) then
                        return false, true
                     else
                        return false, false
                     end
                  end,
                  -- raise lift
                  function()
                     robot.lift_system.set_position(robot.lift_system.position + 0.025) 
                     return false, true
                  end,
                  -- wait for 1s
                  create_count_node({start = 0, finish = 3, speed = 1,}),
                  -- forward 8cm
                  create_count_node({start = 0, finish = _distance + 0.055, speed = 0.005, 
                                     func = function() api.move(0.005, 0.005) end,})
               },
            },
            -- reach the top of the reference block
            {
               type = "sequence*",
               children = {
                  -- condition vector3(0,0,1)
                  function ()
                     if target.offset == vector3(0,0,1) then
                        return false, true
                     else
                        return false, false
                     end
                  end,
                  -- raise lift
                  function()
                     robot.lift_system.set_position(robot.lift_system.position + 0.08) 
                     return false, true
                  end,
                  -- wait for 1s
                  create_count_node({start = 0, finish = 5, speed = 1,}),
                  -- forward 8cm
                  create_count_node({start = 0, finish = _distance + 0.055, speed = 0.005, 
                                     func = function() api.move(0.005, 0.005) end,})
               },
            },
            -- reach the front of the reference block
            {
               type = "sequence*",
               children = {
                  -- condition vector3(1,0,0)
                  function ()
                     if target.offset == vector3(1,0,0) then
                        return false, true
                     else
                        return false, false
                     end
                  end,
                  -- raise lift
                  function()
                     robot.lift_system.set_position(robot.lift_system.position + 0.025) 
                     return false, true
                  end,
                  -- wait for 1s
                  create_count_node({start = 0, finish = 3, speed = 1,}),
                  -- forward 8cm
                  create_count_node({start = 0, finish = _distance, speed = 0.005, 
                                     func = function() api.move(0.005, 0.005) end,})
               },
            },
            -- reach the front down of the reference block
            {
               type = "sequence*",
               children = {
                  -- condition vector3(1,0,-1)
                  function ()
                     if target.offset == vector3(1,0,-1) then
                        return false, true
                     else
                        return false, false
                     end
                  end,
                  -- lower lift
                  function()
                     robot.lift_system.set_position(robot.lift_system.position - 0.025) 
                     return false, true
                  end,
                  -- wait for 1s
                  create_count_node({start = 0, finish = 3, speed = 1,}),
                  -- forward 8cm
                  create_count_node({start = 0, finish = _distance, speed = 0.005, 
                                     func = function() api.move(0.005, 0.005) end,})
               },
            },
            -- reach the front down down of the reference block
            {
               type = "sequence*",
               children = {
                  -- condition vector3(1,0,-2)
                  function ()
                     if target.offset == vector3(1,0,-2) then
                        return false, true
                     else
                        return false, false
                     end
                  end,
                  -- lower lift
                  function()
                     robot.lift_system.set_position(robot.lift_system.position - 0.080) 
                     return false, true
                  end,
                  -- wait for 1s
                  create_count_node({start = 0, finish = 5, speed = 1,}),
                  -- forward 8cm
                  create_count_node({start = 0, finish = _distance, speed = 0.005, 
                                     func = function() api.move(0.005, 0.005) end,})
               },
            },
         }, -- end of children of step forward
      }, -- end of step forward
      -- stop
      function() api.move(0,0) return false, true end,
   }, -- end of the children of the return table
} -- end of the return table
end
return create_reach_block
