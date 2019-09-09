----------------------------------------------------
-- Tools for BuilderBot
--
-- This file contains the tools neccessary to form, update and transform frames.
-- Author
--    Majd Kassawat
--       majd.kassawat@gmail.com
--
----------------------------------------------------
pprint = require('pprint')

local frame_tools = {}
frame_tools.to_quaternion = function(x, y, z)
   -- do some nice conversions here
   return quaternion(1, 1, 1, 1)
end

-- If the value of one measurement is variable, we put zero. The value would get updated later.
frame_tools.frames = {}
frame_tools.frames['camera'] = {
   id = 'camera',
   position = vector3(10, 10, 0),
   orientation = frame_tools.to_quaternion(11, 12, 13),
   refrence_frame = 'robot'
}

frame_tools.get_frame = function(frame_name)
   -- Just return the frame by its name
   return frame_tools.frames[frame_name]
end

frame_tools.update_frames = function()
   -- In this function we update all the dynamic frames such as the camera frame

   --update camera frame
   frame_tools.frames["camera"].position.z = robot.lift_system.position
  
end

frame_tools.set_reference_frame = function(required_refrence_frame_name, frame)
   -- Here we do all the transformations from one frome to another
end

return frame_tools
