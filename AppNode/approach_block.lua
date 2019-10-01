if api == nil then api = require('BuilderBotAPI') end

local create_aim_block_node = require("aim_block")

local create_approach_block_node = function(target, _distance)
   -- approach the target reference block until _distance away 
   return 
-- return the following table
{
   type = "sequence",
   children = {
      -- check the target block is still there 
      function()
         if target == nil or 
            target.reference_id == nil or 
            api.blocks[target.reference_id] == nil then
            DebugMSG("approach: block is nil")
            api.move(0,0)
            return false, false
         else
            DebugMSG("approach: block is not nil")
            return false, true
         end
      end,
      -- I have the target block, approach it
      {
         type = "sequence",
         children = {
            -- aim block, put the block into the center of the image
            create_aim_block_node(target),
            -- go to the pre-position
            function()
               DebugMSG("approach: approaching pre-position")
               local target_block = api.blocks[target.reference_id]
               local target_distance = _distance
               local tolerence = api.parameters.block_position_tolerance
               local default_speed = api.parameters.default_speed
               if target_block.position_robot.x > target_distance - tolerence and 
                  target_block.position_robot.x < target_distance + tolerence then
                  DebugMSG('in final position before losing block')
                  api.move(0, 0)
                  return false, true
               elseif target_block.position_robot.x < target_distance - tolerence then
                  api.move(-default_speed, -default_speed)
                  return true
               elseif target_block.position_robot.x > target_distance + tolerence then
                  api.move(default_speed, default_speed)
                  return true
               else
                  DebugMSG('wow this case should not exist')
               end
            end,
         },
      },
   }, -- end of the children of go to pre-position
} -- end of go to pre-position

end
return create_approach_block_node
