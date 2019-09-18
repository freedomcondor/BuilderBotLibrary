package.path = package.path .. ';Tools/?.lua'
package.path = package.path .. ';luabt/?.lua'
package.path = package.path .. ';AppNode/?.lua'
require('ShowTable')
local pprint = require('pprint')

--require("Debugger")

api = require('BuilderBotAPI')
app = require('ApplicationNode') -- these need to be global
local bt = require('luabt')

-- ARGoS Loop ------------------------
function init()
   -- bt init ---
   BTDATA = {}
   BTDATA.search_block = {}
   function1 = function()
      local flag = false
      for i, block in pairs(api.blocks) do
         if block.tags[1].led == 4 then -- blue
            BTDATA.target = {}
            BTDATA.target.reference_id = i
            BTDATA.target.offset = vector3(0,0,0)
            flag = true
            break
         end
      end
      if flag == true then return false, true
                      else return false, false end
   end

   function2 = function()
      local flag = false
      for i, block in pairs(api.blocks) do
         if block.tags[1].led ~= 4 then -- not blue
            BTDATA.target = {}
            BTDATA.target.reference_id = i
            BTDATA.target.offset = vector3(0,0,1)
            flag = true
            break
         end
      end
      if flag == true then return false, true
                      else return false, false end
   end
 
   behaviour = bt.create {
      type = 'sequence*',
      children = {
       -- pickup
         function() BTDATA.search_block.choose = function1 return false, true end,
         -- search block
         app.search_block,
         -- approach_block
         app.approach_block,
         -- pickup block
         app.pickup_block,
       -- place
         function() BTDATA.search_block.choose = function2 return false, true end,
         -- search block
         app.search_block,
         -- approach_block
         app.approach_block,
         -- drop
         function()
            robot.electromagnet_system.set_discharge_mode("destructive")
         end,
         -- stay forever
         function()
            api.move(0,0) return true
         end,
      },
   }
   -- robot init ---
   robot.camera_system.enable()
end

local STATE = 'prepare'

function step()
   print('-------- step begins ---------')
   api.update_time()
   api.process_blocks()
   behaviour()
end

function reset()
end

function destroy()
end
