DebugMSG.register('search_block')
if api == nil then
   api = require('BuilderBotAPI')
end

local create_obstacle_avoidance_node = require('obstacle_avoidance')

local create_search_block_node = function(rule_node, target)
   -- create a search node based on rule_node
   return {
      type = 'sequence*',
      children = {
         -- prepare, lift to 0.07
         {
            type = 'selector',
            children = {
               -- if lift reach position(0.07), return true, stop selector
               function()
                  if
                     robot.lift_system.position > 0.07 - api.parameters.lift_system_position_tolerance and
                        robot.lift_system.position < 0.07 + api.parameters.lift_system_position_tolerance
                   then
                     DebugMSG('search_in position')
                     return false, true
                  else
                     DebugMSG('search_not in position')
                     return false, false
                  end
               end,
               -- set position(0.07)
               function()
                  robot.lift_system.set_position(0.07)
                  return true -- always running
               end
            }
         },
         -- search
         {
            type = 'selector',
            children = {
               {
                  type = 'sequence',
                  children = {
                     -- choose a block,
                     -- if got one, return true, stop selector
                     rule_node,
                     {
                        type = 'selector',
                        children = {
                           function()
                              if target.safe == true then
                                 return false, true
                              else
                                 return false, false
                              end
                           end,
                           {
                              -- move camera up and down once trying to get safe stuff,
                              -- return true if found safe target,
                              --or false if scanning done with no safe result
                              type = 'sequence*',
                              children = {
                                 {
                                    type = 'selector',
                                    children = {
                                       -- if lift reach position(0.12), return true, stop selector
                                       function()
                                          if
                                             robot.lift_system.position >
                                                0.12 - api.parameters.lift_system_position_tolerance and
                                                robot.lift_system.position <
                                                   0.12 + api.parameters.lift_system_position_tolerance
                                           then
                                             return false, true
                                          else
                                             return false, false
                                          end
                                       end,
                                       -- set position(0.12)
                                       function()
                                          print("up")
                                          robot.lift_system.set_position(0.12)
                                          return true -- always running
                                       end
                                    }
                                 },
                                 {
                                    type = 'selector',
                                    children = {
                                       -- if lift reach position(0.07), return true, stop selector
                                       function()
                                          if
                                             robot.lift_system.position >
                                                0.07 - api.parameters.lift_system_position_tolerance and
                                                robot.lift_system.position <
                                                   0.07 + api.parameters.lift_system_position_tolerance
                                           then
                                             return false, true
                                          else
                                             return false, false
                                          end
                                       end,
                                       -- set position(0.07)
                                       function()
                                          robot.lift_system.set_position(0.07)
                                          return true -- always running
                                       end
                                    }
                                 },
                                 function()
                                    return false, false
                                 end
                              }
                           }
                        }
                     }
                  }
               },
               -- otherwise check obstacle and turn the robot
               {
                  type = 'sequence',
                  children = {
                     -- if obstacle and avoid
                     create_obstacle_avoidance_node(),
                     -- obstacle clear, random walk
                     function()
                        print('I am random woal')
                        local random_angle =
                           math.random(-api.parameters.search_random_range, api.parameters.search_random_range)
                        --api.move(-api.parameters.default_speed, api.parameters.default_speed)
                        api.move_with_bearing(api.parameters.default_speed, random_angle)
                        return true
                     end
                  }
               }
            }
         }
      }
   }
end

return create_search_block_node
