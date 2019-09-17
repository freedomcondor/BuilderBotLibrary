package.path = package.path .. ';Tools/?.lua'
local pprint = require('pprint')
target_block = nil

local approach = {
   type = 'sequence',
   children = {
      -- get_target_block()
      function()
         for i, block in pairs(api.blocks) do
            if block.type == 'target' then
               target_block = block
               return false, true
            else
               target_block = nil
               return false, false
            end
         end
      end,
      -- correct camera height
      -- Here I would need to use the block in camera coordination system
      function()
         -- this equation should be replaced with something related to the camera frame
         target_camera_height =  0.001 --+target_block.position.x / 5
         tolerance = 0.03
         maximum_camera_height = 0.13
         if target_camera_height < 0 then
            target_camera_height = 0
         elseif target_camera_height > maximum_camera_height then
            target_camera_height = maximum_camera_height
         end
         print(target_camera_height)
         print(robot.lift_system.position)
         if
            ((robot.lift_system.position > target_camera_height - tolerance) and
               (robot.lift_system.position < target_camera_height + tolerance))
          then
            print('camera in position')
            return false, true
         elseif (robot.lift_system.position < target_camera_height) then
            robot.lift_system.set_position(robot.lift_system.position + 0.005)
            print('lifting camera height')
            return true
         elseif (robot.lift_system.position > target_camera_height) then
            robot.lift_system.set_position(robot.lift_system.position - 0.005)
            print('lowering camera height')
            return true
         else
            print('wow this case should not exist, camera height correction says hi')
         end
      end,
      -- correct orientation based on position only
      function()
         target_y = 0
         tolerence = 0.01
         if ((target_block.position.y > target_y - tolerence) and (target_block.position.y < target_y + tolerence)) then
            print('orientation corrected')
            return false, true
         elseif (target_block.position.y < target_y - tolerence) then
            api.move(0.001, -0.001)
            return true
         elseif (target_block.position.y > target_y + tolerence) then
            api.move(-0.001, 0.001)
            return true
         else
            print('wow this case should not exist, orientation correction says hi')
         end
      end,
      -- moving forward
      function()
         -- pprint(target_block)
         print(target_block.position.x)
         target_x = 0.18
         tolerence = 0.01
         if ((target_block.position.x > target_x - tolerence) and (target_block.position.x < target_x + tolerence)) then
            print('in final position before losing block')
            return false, true
         elseif (target_block.position.x < target_x - tolerence) then
            api.move(-0.005, -0.005)
            return true
         elseif (target_block.position.x > target_x + tolerence) then
            api.move(0.005, 0.005)
            return true
         else
            print('wow this case should not exist')
         end
      end
   }
}

return approach
