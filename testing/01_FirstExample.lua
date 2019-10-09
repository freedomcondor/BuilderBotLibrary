package.path = package.path .. ";Tools/?.lua"
require("ShowTable")
--require("Debugger")

local api = require("BuilderBotAPI")

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
   local b = quaternion(-math.pi*3/4, vector3(0,0,1))
   local r1,r2,r3,r4 = b:toangleaxis()
   print("r1,r2,r3,r4 = ", r1,r2,r3,r4)
   a:rotate(b)
   print(a)

   print("-- cross test --")
   a = vector3(1,0,0)
   b = vector3(0,1,0)
   -- stupid argos way of saying c = a * b
   local c = vector3(a):cross(b) 
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

   print("-- robot api test --")
   print("robot")
   ShowTable(robot)
end

function step()
   robot.debug.draw("arrow(" .. "blue" .. ")(" .. 
      vector3(0,0,0):__tostring()
                                       .. ")(" .. 
      vector3(0.1,0,0):__tostring()
                                       .. ")"
   )
end

function reset()
end

function destroy()
end
