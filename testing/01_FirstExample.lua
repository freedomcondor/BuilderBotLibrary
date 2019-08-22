require("Tools/ShowTable")

local Bot = require("BuilderBotLibrary")

-- ARGoS Loop ------------------------
function init()
   -- vector and quaternion test ----
   print("vector:")
   ShowTable(getmetatable(vector3()), 1, "__index")
   print("quaternion:")
   ShowTable(getmetatable(quaternion()), 1, "__index")

   local a = vector3(1,0,0)
   local b = quaternion(math.pi/2, vector3(0,0,1))
   a:rotate(b)
   print(a)

   -- robot test ---
   Bot.SetVelocity(0.01, 0.01)
   Bot.EnableCamera()
end
function step()
   ShowTable(Bot.GetTags())
end
function reset()
end
function destroy()
end
