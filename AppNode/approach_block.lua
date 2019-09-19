local create_count_node = require("count_node")
local create_approach_block = function(target)
   local final_reach = {distance = 0,}
   return {
      type = "sequence*",
      children = {
         -- go to the pre-position
         {
            type = "sequence",
            children = {
               -- check the target block is still there 
               function()
                  if target == nil or 
                     target.reference_id == nil or 
                     api.blocks[target.reference_id] == nil then
                     print("approach: block is nil")
                     return false, false
                  else
                     print("approach: block is not nil")
                     return false, true
                  end
               end,
               -- I have the target block, approach it
               {
                  type = "sequence",
                  children = {
                     -- correct camera height
                     function()
                        print("approach: correcting camera")
                        local target_block = api.blocks[target.reference_id]
                        local tolerance = 0.001
                        local target_height = robot.lift_system.position - target_block.position.y
                        local upper_limit = 0.13 -- TODO: maybe provide this in BuilderBotAPI
                        local lower_limit = 0.005 + target_block.position_robot.z - 0.0275
                        if target_height < lower_limit then target_height = lower_limit end
                        if target_height > upper_limit then target_height = upper_limit end
                        if robot.lift_system.position > target_height - tolerance and 
                           robot.lift_system.position < target_height + tolerance then
                           print("camera in position")
                           return false, true
                        else
                           print("camera not in position")
                           robot.lift_system.set_position(target_height)
                           return false, true
                        end
                     end,
                     -- correct robot orientation
                     function()
                        print("approach: correcting orientation")
                        local target_block = api.blocks[target.reference_id]
                        local tolerence = math.tan(1 * math.pi/180)
                        local angle = target_block.position_robot.y / target_block.position_robot.z
                        if angle < -tolerence then
                           api.move(0.002, -0.002)
                           return true
                        elseif angle > tolerence then
                           api.move(-0.002, 0.002)
                           return true
                        else
                           print("robot in right orientation")
                           return false, true
                        end
                     end,
                     -- go to the pre-position
                     function()
                        print("approach: approaching pre-position")
                        local target_block = api.blocks[target.reference_id]
                        local target_distance = 0.17
                        local tolerence = 0.001
                        if target_block.position_robot.x > target_distance - tolerence and 
                           target_block.position_robot.x < target_distance + tolerence then
                           print('in final position before losing block')
                           return false, true
                        elseif target_block.position_robot.x < target_distance - tolerence then
                           api.move(-0.005, -0.005)
                           return true
                        elseif target_block.position_robot.x > target_distance + tolerence then
                           api.move(0.005, 0.005)
                           return true
                        else
                           print('wow this case should not exist')
                        end
                     end,
                  },
               },
            }, -- end of the children of go to pre-position
         }, -- end of go to pre-position
         -- I arrive the pre-position, reach it
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
                  return false, true
               end,
               -- forward
               {
                  type = "sequence*",
                  children = {
                     {
                        type = "selector*",
                        children = {
                           function()
                              if target.offset == vector3(1,0,0) then
                                 return false, true
                              else
                                 return false, false
                              end
                           end,
                           -- if false
                           create_count_node(0, 0.02, 0.005, function() api.move(0.005, 0.005) end)
                        }
                     },
                     -- if true
                     create_count_node(0, 0.06, 0.005, function() api.move(0.005, 0.005) end)
                  },
               },
               -- stop
               function()
                  api.move(0, 0)
                  return false,true
               end,
            },
         },
      }, -- end of the children of the return table
   } -- end of the return table
end
return create_approach_block
