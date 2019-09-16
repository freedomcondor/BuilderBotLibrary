package.path = package.path .. ';Tools/?.lua'
package.path = package.path .. ';luabt/?.lua'
package.path = package.path .. ';AppNode/?.lua'

DEBUG = true

pprint = require('pprint')
bt = require('luabt')
require('ShowTable')
local api = require('BuilderBotAPI')
local app = require('ApplicationNode')

---------------------------------------------------------------------------------------
-- Control Loop
---------------------------------------------------------------------------------------
local timeHolding
local stepCount
function init()
   reset()
end

function step()
   api.process_blocks()
   -- pprint(api.blocks)

   approach_behaviour()
end

function reset()
   robot.lift_system.set_position(0.5)
   robot.camera_system.enable()
   approach_behaviour = bt.create(app.approach)
end

function destroy()
   -- Bot.SetVelocity(0, 0)
   print('do not forget destroy')
end
