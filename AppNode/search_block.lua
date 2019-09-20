local create_search_block = function(rule_node)
   -- create a search node based on rule_node
   return {
      type = "sequence*",
      children = {
         -- prepare, lift to 0.07
         {
            type = "selector",
            children = {
               -- if lift reach position(0.07), return true, stop selector
               function()
                  if robot.lift_system.position > 0.065 and
                     robot.lift_system.position < 0.075 then
                     print("search_in position")
                     return false, true
                  else
                     print("search_not in position")
                     return false, false
                  end
               end,
               -- set position(0.07)
               function()
                  robot.lift_system.set_position(0.07)
                  return true -- always running
               end,
            },
         },
         -- search
         {
            type = "selector",
            children = {
               -- choose a block,
               -- if got one, return true, stop selector
               rule_node,
               -- otherwise turn the robot
               function()
                  --api.move(0.01, -0.01)
                  api.move(-0.01, 0.01)
                  return true
               end,
            },
         },
      },
   }
end
   
return create_search_block
