----------------------------------------------------
-- Intermediate Level of BuilderBot
--
-- Author
--    Weixu Zhu,  Tutti mi chiamano Harry
--       zhuweixu_harry@126.com
-- 
----------------------------------------------------
require("BlockTracking")
local CoorTrans = require("CoordinateTransfer") -- this is usefull

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

---------------------------------------------------------------------------------- think again this part
BuilderBot.cameraOrientation = 
   CoorTrans.OrientationFromEulerAngles(
      -0.50 * math.pi,
       0.75 * math.pi,
       0.00 * math.pi
   )

BuilderBot.cameraPosition = vector3(0.05, 0, 0.05)
----------------------------------------------------------------------------------

--[[
BuilderBot.GetCameraPosition = function()
   return vector3(0.07, 0, 0.10)    -- TODO: calculate it based on effector positions
end
--]]

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
      --    X, Y, Z:  three vector3 (in camera's eye) 
      --       showing the axis of a block :    
      --
      --           |Z           Z| /Y       the one pointing up is Z
      --           |__ Y         |/         the nearest one pointing towards the camera is X
      --           /              \         and then Y follows right hand coordinate system
      --         X/                \X
      --
      --    orientation = a quternion 
      --       - this orientation quaternion is matches XYZ
      --    tags = an array of tags pointers, each pointing to the tags array
end

BuilderBot.ProcessLeds = function()
   local ledDis = 0.02 -- distance between leds to the center
   local ledLocForTag = {
      vector3( ledDis,  0, 0),
      vector3( 0,  ledDis, 0),
      vector3(-ledDis,  0, 0),
      vector3( 0, -ledDis, 0),
   }     -- from x, counter-closewise

   for i, tag in ipairs(BuilderBot.GetTags()) do
      tag.led = 0
      for j, ledLoc in ipairs(ledLocForTag) do
         local ledLocForCamera = CoorTrans.LocationTransferV3(ledLoc, tag.position, tag.orientation)
         local color = robot.camera_system.detect_led(ledLocForCamera)
         if color ~= tag.led and color ~= 0 then tag.led = color end
      end
   end
end

BuilderBot.ProcessBlocks = function()
   BuilderBot.ProcessLeds()
   if BuilderBot.blocks == nil then BuilderBot.blocks = {} end
   BlockTracking(BuilderBot.blocks, BuilderBot.GetTags())
end

return BuilderBot
