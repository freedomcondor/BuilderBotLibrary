package.path = package.path .. ';Tools/?.lua'
local pprint = require('pprint')

target_block = nil -- not sure a global variable here is good or not

local approach = {
   type = 'sequence*',
   children = {
      {
         type = 'sequence',
         children = {
            -- get_target_block()
            function()
               if BTDATA.target.reference_id ~= nil then
                  -- get block
                  target_block = {}
                  local refer_block = api.blocks[BTDATA.target.reference_id]
                  target_block.position = 
                     vector3(refer_block.position)
                  target_block.position_robot = 
                     vector3(refer_block.position_robot)
                  return false, true
               else
                  target_block = nil
                  return false, false
               end
            end,
            -- correct camera height
            -- Here I would need to use the block in camera coordination system
            function()
               -- this equation should be replaced with something related to the camera frame
               api.move(0.0, 0.0)
               target_camera_height = robot.lift_system.position - target_block.position.y
               tolerance = 0.001
               maximum_camera_height = 0.13
               if target_camera_height < target_block.position_robot.z + 0.005 - 0.0275 then
                  target_camera_height = target_block.position_robot.z + 0.005 - 0.0275
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
                  robot.lift_system.set_position(target_camera_height)
                  print('lifting camera height')
                  return true
               elseif (robot.lift_system.position > target_camera_height) then
                  robot.lift_system.set_position(target_camera_height)
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
                  print('correcting orientation, right')
                  api.move(0.01, -0.01)
                  return true
               elseif (target_block.position_robot.y > target_y + tolerence) then
                  print('correcting orientation, left')
                  api.move(-0.01, 0.01)
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
      -- raise manipulator or backup
      function() 
         if BTDATA.target.offset == vector3(0,0,0) or BTDATA.target.offset == vector3(1,0,0) then
            robot.lift_system.set_position(robot.lift_system.position + 0.025) 
         elseif BTDATA.target.offset == vector3(0,0,1) then
            robot.lift_system.set_position(robot.lift_system.position + 0.08) 
         end
         --[[
         if (robot.rangefinders['underneath'].proximity ~= 0 and robot.rangefinders['underneath'].proximity < 0.005) then
            robot.lift_system.set_position(robot.lift_system.position + 0.06) 
         else
            robot.lift_system.set_position(robot.lift_system.position + 0.02) 
         end
         --]]
         return false, true 
      end,
      {
         type = 'sequence*',
         children = {
            function()
               if BTDATA.approach_block == nil then
                  BTDATA.approach_block = {}
               end
               if BTDATA.target.offset == vector3(1,0,0) then
                  BTDATA.approach_block.forward = 0.02
                  print("set 0.02")
               else
                  BTDATA.approach_block.forward = 0.08
                  print("set 0.08")
               end
               BTDATA.approach_block.current = 0
               return false, true
            end,
            -- move forward for some distance
            function()
               print("running,current = ", BTDATA.approach_block.current)
               print("forward = ", BTDATA.approach_block.forward)
               if BTDATA.approach_block.current < BTDATA.approach_block.forward then
                  api.move(0.005, 0.005)
                  BTDATA.approach_block.current = 
                     BTDATA.approach_block.current + 0.005 * api.time_period
                  return true
               else
                  print("running stop")
                  api.move(0.000, 0.000)
                  return false, true
               end
            end,
            -- move forward until picking position
            --[[
            function()
               if
                  --(robot.rangefinders['left'].proximity ~= 0 and robot.rangefinders['left'].proximity < 0.005) or
                  --   (robot.rangefinders['right'].proximity ~= 0 and robot.rangefinders['right'].proximity < 0.005)
                  (robot.rangefinders["1"].proximity ~= 0 and robot.rangefinders["1"].proximity < 0.020) or
                     (robot.rangefinders["12"].proximity ~= 0 and robot.rangefinders["12"].proximity < 0.020)
               then
                  print("haaa, found the block")
                  return false, true
               else
                  print("moving forward")
                  api.move(0.005, 0.005)
                  return true
               end
            end,
            --]]
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
