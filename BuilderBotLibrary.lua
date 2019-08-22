----------------------------------------------------
-- Intermediate Level of BuilderBot
--
-- Author
--    Weixu Zhu,  Tutti mi chiamano Harry
--       zhuweixu_harry@126.com
-- 
----------------------------------------------------
require("BlockTracking")

local BuilderBot = {}

-- system --------------------------------------------
BuilderBot.GetTime = function()
   return robot.system.time
end

BuilderBot.lastTime = nil

BuilderBot.GetTimePeriod = function()
   if BuilderBot.lastTime == nil then
      BuilderBot.lastTime = BuilderBot.GetTime()
      return 0
   end

   local temp = BuilderBot.lastTime 
   BuilderBot.lastTime = BuilderBot.GetTime()
   return BuilderBot.lastTime - temp
end

-- move --------------------------------------------
BuilderBot.SetVelocity = function(x, y)
   -- x, y for left and right, in m/s
   robot.differential_drive.set_target_velocity(x, -y)
end

-- camera --------------------------------------------
BuilderBot.EnableCamera= function()
   robot.camera_system.enable()
end

BuilderBot.GetTags = function()
   return robot.camera_system.tags
      -- tags = an array of tags
      -- a tag has
      --          
      --             /z
      --            /
      --            ------- x
      --            |
      --            |y     in the camera's eye
      --
      --    position    = a vector3
      --    orientation = a quternion
      --    center and corners  
      --       2D information, not important for now
end

BuilderBot.GetBlocks = function()
   return BuilderBot.blocks
      -- blocks = an array of blocks
      -- a block has
      --    position    = a vector3
      --    orientation = a quternion
      --    tags = an array of tags pointers, each pointing to the tags array
end

BuilderBot.ProcessBlocks = function()
   if BuilderBot.blocks == nil then BuilderBot.blocks = {} end
   BlockTracking(BuilderBot.blocks, BuilderBot.GetTags())
end

return BuilderBot
