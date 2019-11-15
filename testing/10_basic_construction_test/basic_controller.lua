package.path = package.path .. ';Tools/?.lua'
package.path = package.path .. ';luabt/?.lua'
package.path = package.path .. ';AppNode/?.lua'
DebugMSG = require('DebugMessage')
-- require('Debugger')

if api == nil then
   api = require('BuilderBotAPI')
end
if app == nil then
   app = require('ApplicationNode')
end
if rules == nil then
   rules = require(robot.params.rules) 
end

local bt = require('luabt')

DebugMSG.enable()

-- ARGoS Loop ------------------------
function init()
   local BTDATA = {target = {}}
   -- bt init ---
   local bt_node = {
      type = 'sequence*',
      children = {
         -- search
         app.create_search_block_node(
            app.create_process_rules_node(rules, 'pickup', BTDATA.target)
         ),
         -- approach
         app.create_curved_approach_block_node(BTDATA.target, 0.18),
         -- pickup 
         app.create_pickup_block_node(BTDATA.target, 0.18),

         -- search
         app.create_search_block_node(
            app.create_process_rules_node(rules, 'place', BTDATA.target)
         ),
         -- approach
         app.create_curved_approach_block_node(BTDATA.target, 0.18),
         -- place
         app.create_place_block_node(BTDATA.target, 0.18),
      }
   }
   behaviour = bt.create(bt_node)
   -- robot init ---
   robot.camera_system.enable()
end

local STATE = 'prepare'

function step()
   DebugMSG('-------- step begins ---------')
   api.process()
   behaviour()
end

function reset()
end

function destroy()
end
