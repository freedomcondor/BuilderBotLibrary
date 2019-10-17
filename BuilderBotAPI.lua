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

-- consts --------------------------------------------
------------------------------------------------------
builderbot_api.consts = {}
builderbot_api.consts.end_effector_position_offset = vector3(0.09800875, 0, 0.055)

-- parameters ----------------------------------------
------------------------------------------------------
builderbot_api.parameters = {}

builderbot_api.parameters.lift_system_upper_limit = 0.135
builderbot_api.parameters.lift_system_lower_limit = 0

builderbot_api.parameters.lift_system_position_tolerance = 
   tonumber(robot.params.lift_system_tolerance or 0.001)

builderbot_api.parameters.default_speed = 
   tonumber(robot.params.default_speed or 0.005)

builderbot_api.parameters.aim_block_angle_tolerance = 
   tonumber(robot.params.aim_block_angle_tolerance or 5)

builderbot_api.parameters.block_position_tolerance = 
   tonumber(robot.params.block_position_tolerance or 0.001)

builderbot_api.parameters.proximity_touch_tolerance = 
   tonumber(robot.params.proximity_touch_tolerance or 0.005)


-- system --------------------------------------------
------------------------------------------------------
builderbot_api.lastTime = 0
builderbot_api.time_period = 0
builderbot_api.process_time = function()
   builderbot_api.time_period = robot.system.time - builderbot_api.lastTime
   builderbot_api.lastTime = robot.system.time
end

-- move --------------------------------------------
------------------------------------------------------
builderbot_api.move = function(x, y)
   -- TODO
   -- x, y for left and right, in m/s
   robot.differential_drive.set_target_velocity(x, -y)
end

builderbot_api.move_with_bearing = function(v, th)
   -- move v m/s forward, with th degree/s to the left
   -- this is the distance of two wheelsA
   -- TODO: needs to be tested on real robots
   local d = 0.1225
   local diff = math.pi * d * (th/360)
   local x = v - diff
   local y = v + diff
   robot.differential_drive.set_target_velocity(x, -y)
end

-- camera --------------------------------------------
------------------------------------------------------

builderbot_api.camera_orientation = robot.camera_system.transform.orientation

builderbot_api.get_camera_position = function()
   return builderbot_api.consts.end_effector_position_offset + 
          robot.camera_system.transform.position +
          vector3(0, 0, robot.lift_system.position)
end

-- camera's frame reference
      --
      --             /z
      --            /
      --            ------- x
      --            |
      --            |y     in the camera's eye
      --
-- robot's frame reference
      -- 
      --            z up of the robot
      --       |     |
      --       |---  |  / y left of the robot
      --     __|_    | /
      --    |____|   |/
      --     +  +    ------- x  in front of the robot


--robot.camera_system.tags
      -- tags = an array of tags
      -- a tag has
      --    position    = a vector3     -- in camera's frame reference
      --    orientation = a quternion   -- in camera's frame reference
      --    center and corners  
      --       2D information, not important for now

--builderbot_api.blocks
      -- blocks = an array of blocks
      -- a block has
      --    position    = a vector3
      --    orientation = a quternion   -- in camera's frame reference
      --    X, Y, Z:  three vector3 (in camera's eye) 
      --       showing the axis of a block :    
      --
      --           |Z           Z| /Y       the one pointing up is Z
      --           |__ Y         |/         the nearest one pointing towards the camera is X
      --           /              \         and then Y follows right hand coordinate system
      --         X/                \X
      --
      --    position_robot    = a vector3
      --    orientation_robot = a quternion  in robot's frame reference
      --    tags = an array of tags pointers, each pointing to the tags array

builderbot_api.process_leds = function()
   -- takes tags in camera_frame_reference 
   local led_dis = 0.02 -- distance between leds to the center
   local led_loc_for_tag = {
      vector3( led_dis,  0, 0),
      vector3( 0,  led_dis, 0),
      vector3(-led_dis,  0, 0),
      vector3( 0, -led_dis, 0),
   }     -- from x+, counter-closewise

   for i, tag in ipairs(robot.camera_system.tags) do
      tag.led = 0
      for j, led_loc in ipairs(led_loc_for_tag) do
         local led_loc_for_camera = vector3(led_loc):rotate(tag.orientation) + tag.position
         local color = robot.camera_system.detect_led(led_loc_for_camera)
         if color ~= tag.led and color ~= 0 then tag.led = color end
      end
   end
end

builderbot_api.process_blocks = function()
   -- figure out led color for tags
   builderbot_api.process_leds() 
   -- track block
   if builderbot_api.blocks == nil then builderbot_api.blocks = {} end
   BlockTracking(builderbot_api.blocks, robot.camera_system.tags)
   -- transfer block to robot frame
   for i, block in pairs(builderbot_api.blocks) do
      block.position_robot = vector3(block.position):rotate(builderbot_api.camera_orientation) + builderbot_api.get_camera_position()
      block.orientation_robot = builderbot_api.camera_orientation * block.orientation
   end
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
