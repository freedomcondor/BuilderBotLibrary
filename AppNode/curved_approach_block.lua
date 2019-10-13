if api == nil then api = require('BuilderBotAPI') end

local create_aim_block_node = require("aim_block")

--[[
local function analyze_block_status(target, case)
   local target_block = api.blocks[target.reference_id]
   local robot_to_block = vector3(-target_block.position_robot):rotate(target_block.orientation_robot:inverse())
   local angle = math.atan(robot_to_block.y / robot_to_block.x) * 180 / math.pi
   DebugMSG("angle = ", angle)
   local tolerance = api.parameters.aim_block_angle_tolerance
   if angle > tolerance then case.left_right_case = -1 -- right
   elseif angle < -tolerance then case.left_right_case = 1 -- left
   else case.left_right_case = 0
   end
end
   --]]

local create_curved_approach_block_node = function(target, target_distance)
   local case = {left_right_case = 0, forward_backup_case = 1,}
   local aim = {}
   return 
-- return the following table
{
   type = "sequence*",
   children = {
      -- check range
      function()
         local target_block = api.blocks[target.reference_id]
         local robot_to_block = vector3(-target_block.position_robot):rotate(target_block.orientation_robot:inverse())
         local angle = math.atan(robot_to_block.y / robot_to_block.x) * 180 / math.pi
         local blind_tolerance = 30
         if angle < blind_tolerance and angle > -blind_tolerance then 
            return false, true
         else
            return false, true
         end
      end,
      -- looply forward and backup to _distance
      {
         type = "sequence",
         children = {
            -- analyze block angle
            function()
               local target_block = api.blocks[target.reference_id]
               local robot_to_block = vector3(-target_block.position_robot):rotate(target_block.orientation_robot:inverse())
               local angle = math.atan(robot_to_block.y / robot_to_block.x) * 180 / math.pi
               local tolerance = api.parameters.aim_block_angle_tolerance
               if case.left_right_case == 0 and angle > tolerance then case.left_right_case = -1 -- right
               elseif case.left_right_case == 0 and angle < -tolerance then case.left_right_case = 1 -- left
               elseif case.left_right_case == 1 and angle > -tolerance/2 then case.left_right_case = 0
               elseif case.left_right_case == -1 and angle < tolerance/2 then case.left_right_case = 0
               end
               print("case left right = ", case.left_right_case)
               print("angle",angle) 
               print("tolerance",tolerance) 
               return false, true
            end,
            -- prepare aim
            function()
               if case.forward_backup_case == 1 and case.left_right_case == 1 or
                  case.forward_backup_case == -1 and case.left_right_case == -1 then
                  aim.case = "left"
               elseif case.forward_backup_case == 1 and case.left_right_case == -1 or
                  case.forward_backup_case == -1 and case.left_right_case == 1 then
                  aim.case = "right"
               elseif case.left_right_case == 0 then
                  aim.case = nil
               end
               return false, true
            end,
            -- aim
            create_aim_block_node(target, aim),
            -- forward or backup
            function()
               local target_block = api.blocks[target.reference_id]
               local tolerence = api.parameters.block_position_tolerance
               local default_speed = api.parameters.default_speed

               if case.forward_backup_case == 1 then
                  -- forward case
                  if target_block.position_robot.x > target_distance - tolerence then
                     -- still too far away, move forward
                     api.move(default_speed, default_speed)
                     return true
                  else
                     -- close enough, check angle
                     if case.left_right_case == 0 then
                        -- success
                        return false, true
                     else
                        -- close enough, but wrong angle, switch to backup
                        case.forward_backup_case = -1
                        return true
                     end
                  end
               elseif case.forward_backup_case == -1 then
                  -- backup case
                  if target_block.position_robot.x < target_distance + 0.03 + tolerence then
                     -- too close, keep move backward
                     api.move(-default_speed, -default_speed)
                     return true
                  else
                     -- far enough, forward again
                     case.forward_backup_case = 1
                     return true
                  end
               end
            end,
         },
      },
   }
}
end
return create_curved_approach_block_node
