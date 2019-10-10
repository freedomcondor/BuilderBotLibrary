if api == nil then api = require('BuilderBotAPI') end

local create_aim_block_node = function(target, aim_point)
   -- aim block, put the block into the center of the image
   return 
-- return the following table
{
   --type = "sequence*",
   type = "sequence*",
   children = {
      function()
         local target_block = api.blocks[target.reference_id]
         local target_tag = target_block.tags.up or
                            target_block.tags.front or
                            target_block.tags.left or
                            target_block.tags.right
         target_tag.corners.up = robot.camera_system.resolution.y
         target_tag.corners.down = 0
         target_tag.corners.left = robot.camera_system.resolution.x
         target_tag.corners.right = 0
         for i, v in ipairs(target_tag.corners) do
            if v.x < target_tag.corners.left then target_tag.corners.left = v.x end
            if v.x > target_tag.corners.right then target_tag.corners.right = v.x end
            if v.y < target_tag.corners.up then target_tag.corners.up = v.y end
            if v.y > target_tag.corners.down then target_tag.corners.down = v.y end
         end

         local tolerance = api.parameters.lift_system_position_tolerance
         local target_height = robot.lift_system.position - target_tag.position.y -- TODO: refine this calculation
         local upper_limit = api.parameters.lift_system_upper_limit
         local lower_limit = api.parameters.lift_system_lower_limit + target_block.position_robot.z - 0.02
         if target_height < lower_limit then target_height = lower_limit end
         if target_height > upper_limit then target_height = upper_limit end
         if robot.lift_system.position > target_height - tolerance and 
            robot.lift_system.position < target_height + tolerance then
            DebugMSG("camera in position")
            flag_camera = true
         else
            DebugMSG("camera not in position")
            robot.lift_system.set_position(target_height)
            flag_camera = false
         end

         local turn
         if aim_point ~= nil and aim_point.case == "left" then
            if target_tag.corners.left < robot.camera_system.resolution.x / 16 then
               turn = "left"
               flag_orientation = false
            elseif target_tag.corners.left > robot.camera_system.resolution.x / 8 then
               turn = "right"
               flag_orientation = false
            else
               turn = "no"
               flag_orientation = true
            end
         elseif aim_point ~= nil and aim_point.case == "right" then
            if target_tag.corners.right < robot.camera_system.resolution.x * 14 / 16 then
               turn = "left"
               flag_orientation = false
            elseif target_tag.corners.right > robot.camera_system.resolution.x * 15 / 16 then
               turn = "right"
               flag_orientation = false
            else
               turn = "no"
               flag_orientation = true
            end
         else
            local tolerence = api.parameters.aim_block_angle_tolerance 
            local angle = math.atan(target_block.position_robot.y / target_block.position_robot.x) * 180 / math.pi  -- x should always be positive
            if angle < -tolerence then
               turn = "right"
               flag_orientation = false
            elseif angle > tolerence then
               turn = "left"
               flag_orientation = false
            else
               turn = "no"
               DebugMSG("robot in right orientation")
               flag_orientation = true
            end
         end
         if turn == "left" then
            api.move(-api.parameters.default_speed, api.parameters.default_speed)
            flag_orientation = false
         elseif turn == "right" then
            api.move(api.parameters.default_speed, -api.parameters.default_speed)
            flag_orientation = false
         elseif turn == "no" then
            api.move(0, 0)
            flag_orientation = true
         end

         if flag_orientation == true and flag_camera == true then
            return false, true
         else
            return true
         end

         --[[
         -- correct robot orientation
         DebugMSG("approach: correcting orientation")
         local target_block = api.blocks[target.reference_id]
         --local tolerence = math.tan(api.parameters.aim_block_angle_tolerance * math.pi/180)
         local tolerence = api.parameters.aim_block_angle_tolerance 
         local aim_angle = 0
         if aim_point ~= nil then aim_angle = aim_point.angle end
         local angle = math.atan(target_block.position_robot.y / target_block.position_robot.x) * 180 / math.pi  -- x should always be positive
         if angle < aim_angle - tolerence then
            api.move(api.parameters.default_speed, -api.parameters.default_speed)
            flag_orientation = false
         elseif angle > aim_angle + tolerence then
            api.move(-api.parameters.default_speed, api.parameters.default_speed)
            flag_orientation = false
         else
            api.move(0, 0)
            DebugMSG("robot in right orientation")
            flag_orientation = true
         end

         if flag_orientation == true and flag_camera == true then
            return false, true
         else
            return true
         end
         --]]
      end,
   },
}

end
return create_aim_block_node
