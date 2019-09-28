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
         local tolerance = api.parameters.lift_system_position_tolerance
         local target_height = robot.lift_system.position - target_block.position.y -- TODO: refine this calculation
         local upper_limit = api.parameters.lift_system_upper_limit
         local lower_limit = api.parameters.lift_system_lower_limit + target_block.position_robot.z - 0.02
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
         local tolerence = math.tan(api.parameters.aim_block_angle_tolerance * math.pi/180)
         local angle = target_block.position_robot.y / target_block.position_robot.z
         if angle < -tolerence then
            api.move(api.parameters.default_speed, -api.parameters.default_speed)
            return true
         elseif angle > tolerence then
            api.move(-api.parameters.default_speed, api.parameters.default_speed)
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
