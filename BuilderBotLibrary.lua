----------------------------------------------------
-- Intermediate Level of BuilderBot
--
-- Author
--    Weixu Zhu,  Tutti mi chiamano Harry
--       zhuweixu_harry@126.com
-- 
----------------------------------------------------
local BuilderBot = {}

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
end

return BuilderBot
