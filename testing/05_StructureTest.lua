package.path = package.path .. ';Tools/?.lua'
package.path = package.path .. ';luabt/?.lua'
package.path = package.path .. ';AppNode/?.lua'
require('ShowTable')
--local pprint = require('pprint')

--require("Debugger")

api = require('BuilderBotAPI')
app = require('ApplicationNode') -- these need to be global
local bt = require('luabt')

-- rules
local function create_pickup_rule_node(target)
   -- returns a function/btnode that 
   --    chooses a block to pick up
   --    from api.blocks
   -- stores in target, if didn't find one, target = nil
   --    target = {
   --       reference_id = index of a block in api.blocks
   --       offset = vector3(0,0,0), not 0 for virtual block
   --    }
   return function()
      -- find nearest blue block
      print("ckecking pick up rule")
      local flag = false
      local distance = 999999
      target.reference_id = nil
      target.offset = vector3(0,0,0)
      for i, block in pairs(api.blocks) do
         if block.tags[1].led == 4 then -- 4 means blue
            print("found a blue block")
            if block.position_robot.x < distance then
               distance = block.position_robot.x
               target.reference_id = i
               flag = true
            end
         end
      end
      if flag == true then return false, true
                      else return false, false end
   end
end

local function create_place_rule_node(target)
   -- returns a function/btnode choose a place virtual block
   -- stores in target, if didn't find one, target = nil
   return {
      type = "sequence*",
      children = {
         -- find nearest and highest block not blue
         function()
            local flag = false
            local distance = 999999
            target.reference_id = nil
            target.offset = nil
            for i, block in pairs(api.blocks) do
               if block.tags[1].led ~= 4 then -- 4 means blue
                  print("found a non-blue block")
                  if block.position.z < distance then
                     target.reference_id = i
                     flag = true
                  end
               end
            end
            if flag == true then return false, true
                            else return false, false end
         end,
         -- mark
         function() print("before approach") return false, true end,
         -- approach it until 25cm
         app.create_approach_block(target, 0.25),
         -- mark
         function() print("after approach") return false, true end,
         -- check what's in that column there
         {
            type = "selector*",
            children = {
               -- move up to see the top
               {
                  type = "sequence",
                  children = {
                     -- find nearest highest not blue block
                     -- see if it is already level 3, return false
                     function()
                        -- nearest, highest, not blue
                        local flag = false
                        local distance = 999999
                        target.reference_id = nil
                        target.offset = nil
                        for i, block in pairs(api.blocks) do
                           if block.tags[1].led ~= 4 then -- 4 means blue
                              if block.position.z < distance then
                                 distance = block.position.z
                                 target.reference_id = i
                                 flag = true
                              end
                           end
                        end
                        local block = api.blocks[target.reference_id]
                        if block.position_robot.z < 0.055 * 2 then
                           return false, true
                        else
                           return false, false
                        end
                     end,
                     -- check what on top of it
                     {
                        type = "selector",
                        children = {
                           -- if I can see the upper tag
                           function()
                              local block = api.blocks[target.reference_id]
                              local flag = false
                              for i, tag in ipairs(block.tags) do
                                 if (vector3(0,0,1):rotate(api.camera_orientation*tag.orientation) - 
                                     vector3(0,0,1) ):length() < 0.02 then
                                    flag = true
                                    target.offset = vector3(0,0,1)
                                    break
                                 end
                              end
                              return false, flag
                           end,
                           -- otherwise, move up
                           function()
                              robot.lift_system.set_position(robot.lift_system.position + 0.05)
                              return true -- running
                           end,
                        },
                     },
                  }, -- end of children of move top
               }, -- end of move to top
               -- target is level 3, set offset (1, 0, -2)
               function()
                  target.offset = vector3(1,0,-2)
                  return false ,true
               end,
               --[[
               -- move down to see bottom
               {
                  type = "selector",
                  children = {
                     -- find the nearest, lowest, not blue block
                     -- check whether it is level 1, true
                     function()
                        -- nearest, lowest, not blue
                        local flag = false
                        local distance = -999999
                        target.reference_id = nil
                        target.offset = nil
                        for i, block in pairs(api.blocks) do
                           if block.tags[1].led ~= 4 then -- 4 means blue
                              if block.position.y > distance then
                                 distance = block.position.y
                                 target.reference_id = i
                                 flag = true
                              end
                           end
                        end
                        local block = api.blocks[target.reference_id]
                        if block.position_robot.z < 0.055 then
                           target.offset = vector3(1,0,-1)
                           return false, true
                        else
                           return false, false
                        end
                     end,
                     -- move down
                     function()
                        robot.lift_system.set_position(robot.lift_system.position - 0.05)
                        return true -- running
                     end,
                  },
               },
               --]]
            }, -- end of children of check column
         }, -- end of check column
      },
   }
end

-- ARGoS Loop ------------------------
function init()
   local BTDATA = {target = {},}
   -- bt init ---
   local bt_node = {
      type = 'sequence*',
      children = {
       -- pickup
         -- search block
         app.create_search_block(create_pickup_rule_node(BTDATA.target)),
         -- recharge
         function()
            robot.electromagnet_system.set_discharge_mode("disable")
         end,
         -- approach_block
         app.create_reach_block(BTDATA.target),
         -- pickup block
         app.pickup_block,
       -- place
         function() 
            robot.nfc.write('3')
            return false, true
         end,
         -- search block
         app.create_search_block(create_place_rule_node(BTDATA.target)),
         -- approach_block
         app.create_reach_block(BTDATA.target),
         -- drop
         function()
            robot.electromagnet_system.set_discharge_mode("destructive")
         end,
         -- backup 2 cm
         app.create_count_node({start = 0, finish = 0.08, speed = 0.005, 
                                func = function() api.move(-0.005, -0.005) end,}),
         -- stop
         --function() api.move(0,0) return true end,
      },
   }

   ShowTable(bt_node)
   behaviour = bt.create(bt_node)
   -- robot init ---
   robot.camera_system.enable()
end

local STATE = 'prepare'

function step()
   print('-------- step begins ---------')
   api.process_time()
   api.process_blocks()
   behaviour()
end

function reset()
end

function destroy()
end
