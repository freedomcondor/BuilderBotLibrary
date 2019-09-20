local create_count_node = require("count_node")
local create_approach_block = require("approach_block")

local create_reach_block = function(target)
   local final_reach = {distance = 0,}
   return {
      type = "sequence*",
      children = {
         -- go to the pre-position, 17 cm to the block
         create_approach_block(target, 0.17),
         -- I arrive the pre-position, reach it
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
                     create_count_node({start = 0, finish = 0.085, speed = 0.005, 
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
                     create_count_node({start = 0, finish = 0.08, speed = 0.005, 
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
                     create_count_node({start = 0, finish = 0.02, speed = 0.005, 
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
                     create_count_node({start = 0, finish = 0.02, speed = 0.005, 
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
                     create_count_node({start = 0, finish = 0.02, speed = 0.005, 
                                        func = function() api.move(0.005, 0.005) end,})
                  },
               },
            },
         },
         -- stop
         function()
            api.move(0, 0)
            return false,true
         end,
         --[[
         {
            type = "sequence*",
            children = {
               -- raise manipulator
               function()
                  if target.offset == vector3(0,0,0) or target.offset == vector3(1,0,0) then
                     robot.lift_system.set_position(robot.lift_system.position + 0.025) 
                  elseif target.offset == vector3(0,0,1) then
                     robot.lift_system.set_position(robot.lift_system.position + 0.08) 
                  end
                  api.move(0,0)
                  return false, true
               end,
               -- wait
               create_count_node(0,1,1),
               -- forward
               {
                  type = "selector*",
                  children = {
                     {
                        type = "sequence*",
                        children = {
                           function()
                              if target.offset == vector3(1,0,0) then
                                 return false, true
                              else
                                 return false, false
                              end
                           end,
                           -- mark
                           function() print("I am forward 2") return false, true end,
                           -- if false
                           create_count_node(0, 0.020, 0.005, function() api.move(0.005, 0.005) end)
                        }
                     },
                     -- mark
                     function() print("I am forward 8") return false, false end,
                     -- if true
                     create_count_node(0, 0.08, 0.005, function() api.move(0.005, 0.005) end)
                  },
               },
               -- stop
               function()
                  api.move(0, 0)
                  return false,true
               end,
            },
         },
         --]]
      }, -- end of the children of the return table
   } -- end of the return table
end
return create_reach_block
