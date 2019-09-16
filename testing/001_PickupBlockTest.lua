package.path = package.path .. ";Tools/?.lua"
package.path = package.path .. ";luabt/?.lua"
package.path = package.path .. ";AppNode/?.lua"
require("ShowTable")
--require("Debugger")

api = require("BuilderBotAPI")
app = require("ApplicationNode")  -- these need to be global
local bt = require("luabt")

-- ARGoS Loop ------------------------
function init()
   -- bt init ---
   BTDATA = {}
   behaviour = bt.create{
      type = "sequence*",
      children = {
         -- search block
         app.search_block,
         -- forward TODO: make it approach_block
         function()
            if robot.rangefinders["1"].proximity < 0.025 and
               robot.rangefinders["1"].proximity ~= 0 then
               api.move(0, 0)
               return false, true -- true
            else
               api.move(0.01, 0.01)
               return true  -- running
            end
         end,
         -- pickup block
         app.pickup_block
      },
   }
   -- robot init ---
   robot.camera_system.enable()
end

local STATE = "prepare"

function step()
   print("-------- step begins ---------")
   api.process_blocks()
   behaviour()
end

function reset()
end

function destroy()
end
