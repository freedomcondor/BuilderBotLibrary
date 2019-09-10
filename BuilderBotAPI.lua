----------------------------------------------------
-- Intermediate Level of BuilderBot
--
-- Author
--    Weixu Zhu,  Tutti mi chiamano Harry
--       zhuweixu_harry@126.com
-- 
----------------------------------------------------
require("BlockTracking")

local builderbot_api = {}

-- system --------------------------------------------
------------------------------------------------------

builderbot_api.frame_transfer = function(loc_AinB, ori_AinB, loc_BinC, ori_BinC)
   -- A has location&orientation in B's eye
   -- B has location&orientation in C's eye
   -- calculate A's location&orientation in C's eye
   -- if we only want location or only orientation, leave the other nil
   
   local loc_AinC = nil
   local ori_AinC = nil
   if loc_AinB ~= nil and loc_BinC ~= nil and ori_BinC ~= nil then
      loc_AinC = vector3(loc_AinB):rotate(ori_BinC) + loc_BinC
   end
   if ori_AinB ~= nil and ori_BinC ~= nil then
      ori_AinC = ori_BinC * ori_AinB
   end
   return loc_AinC, ori_AinC
end

-- system --------------------------------------------
------------------------------------------------------
builderbot_api.lastTime = nil
builderbot_api.get_time_period = function()
   if builderbot_api.lastTime == nil then
      builderbot_api.lastTime = robot.system.time
      return 0
   end

   local temp = builderbot_api.lastTime 
   builderbot_api.lastTime = robot.system.time
   return builderbot_api.lastTime - temp
end

-- move --------------------------------------------
------------------------------------------------------
builderbot_api.move = function(x, y)
   -- TODO
   -- x, y for left and right, in m/s
   robot.differential_drive.set_target_velocity(x, -y)
end

-- camera --------------------------------------------
------------------------------------------------------

----------------------------------------------------------------------------------
local function quaternion_from_euler_angles(zRadian, yRadian, xRadian) -- TODO: ask Michael to provide this function
   local a = vector3(0,0,0)                                            --
   local X = quaternion(xRadian, vector3(1,0,0))                       --
   local Y = quaternion(yRadian, vector3(0,1,0))                       --
   local Z = quaternion(zRadian, vector3(0,0,1))                       --
   return X * Y * Z                                                    --
end                                                                    --
----------------------------------------------------------------------------------

builderbot_api.camera_orientation = 
   quaternion_from_euler_angles(
      -0.50 * math.pi,
       0.75 * math.pi,
       0.00 * math.pi
   )

builderbot_api.get_camera_position = function()
   return vector3(0.095, 0, 0.125 + robot.lift_system.position) -- TODO: this number is not accurate
end

--robot.camera_system.tags
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

--builderbot_api.blocks
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

builderbot_api.process_leds = function()
   local led_dis = 0.02 -- distance between leds to the center
   local led_loc_for_tag = {
      vector3( led_dis,  0, 0),
      vector3( 0,  led_dis, 0),
      vector3(-led_dis,  0, 0),
      vector3( 0, -led_dis, 0),
   }     -- from x, counter-closewise

   for i, tag in ipairs(robot.camera_system.tags) do
      tag.led = 0
      for j, led_loc in ipairs(led_loc_for_tag) do
         --local led_loc_for_camera = vector3(led_loc):rotate(tag.orientation) + tag.position
         local led_loc_for_camera, _ = builderbot_api.frame_transfer(led_loc, nil, tag.position, tag.orientation) 
         local color = robot.camera_system.detect_led(led_loc_for_camera)
         if color ~= tag.led and color ~= 0 then tag.led = color end
      end
   end
end

builderbot_api.process_blocks = function()
   builderbot_api.process_leds()
   if builderbot_api.blocks == nil then builderbot_api.blocks = {} end
   BlockTracking(builderbot_api.blocks, robot.camera_system.tags)
end

-- debug arrow ---------------------------------------
------------------------------------------------------
builderbot_api.debug_arrow = function(color, from, to)
   if robot.debug == nil then return end

   robot.debug.draw("arrow(" .. color .. ")(" .. 
      from:__tostring()
      .. ")(" .. 
      to:__tostring()
      ..")"
   )
end

return builderbot_api
