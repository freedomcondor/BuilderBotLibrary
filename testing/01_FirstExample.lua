package.path = package.path .. ";Tools/?.lua"
require("ShowTable")
--require("Debugger")

local Bot = require("BuilderBotLibrary")

-- ARGoS Loop ------------------------
function init()
   -- vector and quaternion test ----
   ---[[
   print("-- vector test --")
   print("vector:")
   ShowTable(getmetatable(vector3()), 1, "__index")
   print("quaternion:")
   ShowTable(getmetatable(quaternion()), 1, "__index")

   local a = vector3(1,0,0)
   local b = quaternion(math.pi/2, vector3(0,0,1))
   a:rotate(b)
   print(a)
   print("vector and quaternion test end")
   --]]

   -- robot test ---
   Bot.SetVelocity(0.01, 0.01)
   Bot.EnableCamera()
end

function step()
   print("-------- step begins ---------")

   --- get time test ----
   print("-- get time test --")
   print(Bot.GetTime())
   print(Bot.GetTimePeriod())


   --- camera test ----
   print("-- camera test --")
   Bot.ProcessBlocks()
   ---[[
   print("tags")
   ShowTable(Bot.GetTags(), 1)
   print("blocks -- note that the orientation is wrong currently")
   ShowTable(Bot.GetBlocks(), 1, "tags")
   --]]

end

function reset()
end

function destroy()
end
