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

   print("-- rotation test --")
   local a = vector3(1,0,0)
   local b = quaternion(math.pi/2, vector3(0,0,1))
   a:rotate(b)
   print(a)

   print("-- cross test --")
   a = vector3(1,0,0)
   b = vector3(0,1,0)
   local c = vector3(a):cross(b) -- stupid argos way of saying Y = Z * X
   print("a = ", a)
   print("b = ", b)
   print("c = ", c)

   print("-- quaternion multiply test --")
   a = vector3(1,0,0)
   local q1 = quaternion(math.pi/2, vector3(0,0,1))
   local q2 = quaternion(math.pi/2, vector3(1,0,0))
   print("rotate q1 = ", vector3(a):rotate(q1))
   print("rotate q2 = ", vector3(a):rotate(q2))
   local q3 = q2 * q1
   print("after cross")
   print("rotate q1 = ", vector3(a):rotate(q1))
   print("rotate q2 = ", vector3(a):rotate(q2))
   print("rotate q3 = ", vector3(a):rotate(q3))

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
   --print("tags")
   --ShowTable(Bot.GetTags(), 1)
   print("blocks")
   ShowTable(Bot.GetBlocks(), 1, "tags")
   --]]

end

function reset()
end

function destroy()
end
