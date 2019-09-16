package.path = package.path .. ";Tools/?.lua"
--package.path = package.path .. ";luabt/?.lua"
package.path = package.path .. ";AppNode/?.lua"
require("ShowTable")
--require("Debugger")

local api = require("BuilderBotAPI")
local app = require("ApplicationNode")
local bt = require("luabt")

-- ARGoS Loop ------------------------
function init()
   -- robot test ---
   api.move(0.01, 0.01)
   robot.camera_system.enable()

   behaviour = bt.create(app.grap_block)
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

   for i, tag_for_camera in pairs(robot.camera_system.tags) do
      local tagpose = vector3(tag_for_camera.position):rotate(api.camera_orientation) + 
                      api.get_camera_position()
      api.debug_arrow("red", api.get_camera_position(), tagpose) 
   end

   for i, block in pairs(api.blocks) do
      api.debug_arrow("blue", api.get_camera_position(), block.position) 
   end

   behaviour()
end

function reset()
end

function destroy()
end
