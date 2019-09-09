package.path = package.path .. ';Tools/?.lua'
DEBUG = true

pprint = require('pprint')
luabt = require('luabt.luabt')
require('ShowTable')
local api = require('BuilderBotAPI')
local frame_tools = require('FramesTools')

---------------------------------------------------------------------------------------
-- Control Loop
---------------------------------------------------------------------------------------
local timeHolding
local stepCount
function init()
   reset()
end

function step()


   frame_tools.update_frames()
   camera_robot = frame_tools.get_frame('camera')
   pprint(camera_robot)

end

function reset()
   robot.lift_system.set_position(0.5)
end

function destroy()
   -- Bot.SetVelocity(0, 0)
   print("do not forget destroy")
end
