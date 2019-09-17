package.path = package.path .. ';Tools/?.lua'
local pprint = require('pprint')
target_block = nil
target_block_id = nil
local approach = {
   type = 'sequence*',
   children = {
      {
         type = 'sequence',
         children = {
            -- get_target_block()
            function()
               if target_block_id == nil then
                  for i, block in pairs(api.blocks) do
                     if block.type == 'target' then
                        target_block = block
                        target_block_id = block.id
                        print('we have target block first time')
                        return false, true
                     end
                  end
                  if target_block == nil then
                     return false, false
                  end
               else
                  for i, block in pairs(api.blocks) do
                     if block.id == target_block_id then
                        target_block = block
                        print('we have target block from id')
                        return false, true
                     end
                  end
               end
            end,
            -- correct camera height
            -- Here I would need to use the block in camera coordination system
            function()
               -- this equation should be replaced with something related to the camera frame
               target_camera_height = 0
               tolerance = 0.001
               maximum_camera_height = 0.13
               if target_camera_height < 0 then
                  target_camera_height = 0
               elseif target_camera_height > maximum_camera_height then
                  target_camera_height = maximum_camera_height
               end
               -- print(target_camera_height)
               -- print(robot.lift_system.position)
               if
                  ((robot.lift_system.position > target_camera_height - tolerance) and
                     (robot.lift_system.position < target_camera_height + tolerance))
                then
                  print('camera in position')
                  return false, true
               elseif (robot.lift_system.position < target_camera_height) then
                  robot.lift_system.set_position(robot.lift_system.position + 0.001)
                  print('lifting camera height')
                  return true
               elseif (robot.lift_system.position > target_camera_height) then
                  robot.lift_system.set_position(robot.lift_system.position - 0.001)
                  print('lowering camera height')
                  return true
               else
                  print('wow this case should not exist, camera height correction says hi')
               end
            end,
            -- correct orientation based on position only
            function()
               target_y = 0.0005
               tolerence = 0.01
               if
                  ((target_block.position_robot.y > target_y - tolerence) and (target_block.position_robot.y < target_y + tolerence))
                then
                  print('orientation corrected')
                  return false, true
               elseif (target_block.position_robot.y < target_y - tolerence) then
                  print('correcting orientation')
                  api.move(0.001, -0.001)
                  return true
               elseif (target_block.position_robot.y > target_y + tolerence) then
                  print('correcting orientation')
                  api.move(-0.001, 0.001)
                  return true
               else
                  print('wow this case should not exist, orientation correction says hi')
               end
            end,
            -- moving forward until minimum visible distance
            function()
               -- pprint(target_block)
               -- print(target_block.position.x)
               target_x = 0.17
               tolerence = 0.001
               if
                  ((target_block.position_robot.x > target_x - tolerence) and (target_block.position_robot.x < target_x + tolerence))
                then
                  print('in final position before losing block')
                  return false, true
               elseif (target_block.position_robot.x < target_x - tolerence) then
                  api.move(-0.005, -0.005)
                  return true
               elseif (target_block.position_robot.x > target_x + tolerence) then
                  api.move(0.005, 0.005)
                  return true
               else
                  print('wow this case should not exist')
               end
            end
         }
      },
      {
         type = 'sequence',
         children = {
            -- move forward until picking position
            function()
               if
                  (robot.rangefinders['left'].proximity ~= 0 and robot.rangefinders['left'].proximity < 0.005) or
                     (robot.rangefinders['right'].proximity ~= 0 and robot.rangefinders['right'].proximity < 0.005)
                then
                  print("haaa, found the block")
                  return false, true
               else
                  print("moving forward")
                  api.move(0.005, 0.005)
                  return true
               end
            end,
            -- stop
            function()
               print("stop")
               api.move(0, 0)
               return false,true
            end
         }
      }
   }
}

return approach
