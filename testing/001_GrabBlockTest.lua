package.path = package.path .. ";Tools/?.lua"
package.path = package.path .. ";luabt/?.lua"
package.path = package.path .. ";AppNode/?.lua"
require("ShowTable")
--require("Debugger")

local api = require("BuilderBotAPI")
local app = require("ApplicationNode")
local bt = require("luabt_new")

-- ARGoS Loop ------------------------
function init()
   -- robot test ---
   api.move(0.01, 0.01)

   robot.lift_system.set_position(0.07)

   behaviour = bt.create{
      type = "sequence*",
      children = {
         -- prepare
         function()
            if robot.lift_system.position < 0.06 then
               robot.lift_system.set_position(0.07)
               return true  -- running
            else
               return false, true -- true
            end
         end,
         -- forward
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
         -- grab_block
         app.grab_block
      },
   }
end

local STATE = "prepare"

function step()
   print("-------- step begins ---------")

   --ShowTable(robot.rangefinders)

   behaviour()
end

function reset()
end

function destroy()
end
