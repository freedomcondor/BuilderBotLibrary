package.path = package.path .. ";Tools/?.lua"
require("ShowTable")
--require("Debugger")

local api = require("BuilderBotAPI")

-- ARGoS Loop ------------------------
function init()
   -- robot test ---
   api.move(0.01, 0.01)
   robot.camera_system.enable()
   print("lift_position", robot.lift_system.position)
end

function step()
   print("-------- step begins ---------")
   --- get time test ----
   print("-- get time test --")
   print(api.get_time_period())


   --- camera test ----
   print("-- camera test --")
   api.process_blocks()

   print("blocks")
   ShowTable(api.blocks, 1)

   for i, tag in pairs(robot.camera_system.tags) do
      local tag_to_robot = api.frame_transfer(
         tag.position,
         tag.orientation,
         api.get_camera_position(),
         api.camera_orientation
      )
      api.debug_arrow("blue", api.get_camera_position(), tag_to_robot) 
   end
end

function reset()
end

function destroy()
end
