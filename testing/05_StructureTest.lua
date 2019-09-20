package.path = package.path .. ';Tools/?.lua'
package.path = package.path .. ';luabt/?.lua'
package.path = package.path .. ';AppNode/?.lua'
require('ShowTable')
--local pprint = require('pprint')

--require("Debugger")

api = require('BuilderBotAPI')
app = require('ApplicationNode') -- these need to be global
local bt = require('luabt')

-- pyramid rules ------------------------------------
-----------------------------------------------------
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
         -- find nearest and then highest block not blue
         function()
            local flag = false
            local x_distance = 999999
            local z_distance = -999999

            target.reference_id = nil
            target.offset = nil
            for i, block in pairs(api.blocks) do
               if block.tags[1].led ~= 4 then -- 4 means blue
                  print("found a non-blue block")
                  if block.position_robot.x + 0.02 < x_distance then
                     x_distance = block.position_robot.x
                     z_distance = block.position_robot.z
                     target.reference_id = i
                     flag = true
                  elseif block.position_robot.x < x_distance + 0.02 and
                         block.position_robot.z > z_distance then
                     z_distance = block.position_robot.z
                     target.reference_id = i
                     flag = true
                  end
               end
            end
            if flag == true then return false, true
                            else return false, false end
         end,
         -- approach it until 25cm
         app.create_approach_block(target, 0.25),
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
                     -- see if column is full based on color, if full, return false
                     function()
                        -- nearest, highest, not blue
                        local flag = false
                        local x_distance = 999999
                        local z_distance = -999999
                        target.reference_id = nil
                        target.offset = nil
                        for i, block in pairs(api.blocks) do
                           if block.tags[1].led ~= 4 then -- 4 means blue
                              if block.position_robot.x + 0.02 < x_distance then
                                 x_distance = block.position_robot.x
                                 z_distance = block.position_robot.z
                                 target.reference_id = i
                                 flag = true
                              elseif block.position_robot.x < x_distance + 0.02 and
                                 block.position_robot.z > z_distance then
                                 z_distance = block.position_robot.z
                                 target.reference_id = i
                                 flag = true
                              end
                           end
                        end
                        local block = api.blocks[target.reference_id]


                        if block.position_robot.z < 0.055 * (block.tags[1].led - 1) then

                           print("test1")
                           if block.tags[1].led == 1 then robot.nfc.write('1')
                           elseif block.tags[1].led == 2 then robot.nfc.write('2')
                           elseif block.tags[1].led == 3 then robot.nfc.write('3')
                           end

                           return false, true
                        else

                           print("test2")
                           if block.tags[1].led == 1 then robot.nfc.write('1')
                           elseif block.tags[1].led == 2 then robot.nfc.write('1')
                           elseif block.tags[1].led == 3 then robot.nfc.write('2')
                           end

                           return false, false
                        end

                        --[[
                        if block.position_robot.z < 0.055 * 2 then
                           return false, true
                        else
                           return false, false
                        end
                        --]]
                     end,
                     -- check what's on top of it
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
                  local block = api.blocks[target.reference_id]
                  print("AAA")
                  if block.tags[1].led == 3 then
                     target.offset = vector3(1,0,-2)
                  elseif block.tags[1].led == 2 then
                     target.offset = vector3(1,0,-1)
                  elseif block.tags[1].led == 1 then
                     target.offset = vector3(1,0,0)
                  end
                  print("BBB")
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
-- end of pyramid rules -----------------------------
-----------------------------------------------------

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
         -- approach_block
         app.create_approach_block(BTDATA.target, 0.17),
         -- pickup block
         app.create_pickup_block(BTDATA.target, 0.025),

       -- place
         -- search block
         app.create_search_block(create_place_rule_node(BTDATA.target)),
         -- approach_block
         app.create_approach_block(BTDATA.target, 0.17),
         -- drop
         app.create_place_block(BTDATA.target, 0.025),

         -- backup 6 cm
         app.create_count_node({start = 0, finish = 0.06, speed = 0.005, 
                                func = function() api.move(-0.005, -0.005) end,}),
         -- stop
         --function() api.move(0,0) return true end,
      },
   }
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
