package.path = package.path .. ";Tools/?.lua"
package.path = package.path .. ";luabt/?.lua"
package.path = package.path .. ";AppNode/?.lua"
require("ShowTable")
--require("Debugger")

--robot.xxx is provided by argos
api = require("BuilderBotAPI")
app = require("ApplicationNode")

-- ARGoS Loop ------------------------
function init()
   -- robot test ---
   api.move(0.01, 0.01)
   robot.camera_system.enable()
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


   -- test tag location
   for i, tag_for_camera in pairs(robot.camera_system.tags) do
      api.debug_arrow("red", api.get_camera_position(), tag_for_camera.position) 
   end

   -- test block location and orientation
   local x = vector3(1,0,0)
   local y = vector3(0,1,0)
   local z = vector3(0,0,1)
   for i, block in pairs(api.blocks) do
      api.debug_arrow("red", block.position, block.position + 0.1*vector3(x):rotate(block.orientation)) 
      api.debug_arrow("blue", block.position, block.position + 0.1*vector3(y):rotate(block.orientation)) 
      api.debug_arrow("green", block.position, block.position + 0.1*vector3(z):rotate(block.orientation)) 
   end
end

function reset()
end

function destroy()
end
