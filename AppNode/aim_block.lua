if api == nil then api = require('BuilderBotAPI') end

local create_aim_block_node = function(target)
   -- aim block, put the block into the center of the image
   return -- return the following table
{
   type = "sequence*",
   children = {
      -- correct camera height
      function()
         DebugMSG("approach: correcting camera")
         local target_block = api.blocks[target.reference_id]
         local tolerance = 0.001
         local target_height = robot.lift_system.position - target_block.position.y
         local upper_limit = 0.13 -- TODO: maybe provide this in BuilderBotAPI
         local lower_limit = 0.005 + target_block.position_robot.z - 0.025
         if target_height < lower_limit then target_height = lower_limit end
         if target_height > upper_limit then target_height = upper_limit end
         if robot.lift_system.position > target_height - tolerance and 
            robot.lift_system.position < target_height + tolerance then
            DebugMSG("camera in position")
            return false, true
         else
            DebugMSG("camera not in position")
            api.move(0.000, 0.000)
            robot.lift_system.set_position(target_height)
            return true
         end
      end,
      -- correct robot orientation
      function()
         DebugMSG("approach: correcting orientation")
         local target_block = api.blocks[target.reference_id]
         local tolerence = math.tan(3 * math.pi/180) -- 1 degree
         local angle = target_block.position_robot.y / target_block.position_robot.z
         if angle < -tolerence then
            api.move(0.004, -0.004)
            return true
         elseif angle > tolerence then
            api.move(-0.004, 0.004)
            return true
         else
            DebugMSG("robot in right orientation")
            return false, true
         end
      end,
   },
}

end
return create_aim_block_node
