if DebugMSG == nil then DebugMSG = require('DebugMessage') end
DebugMSG.register("approach_block")

if api == nil then api = require('BuilderBotAPI') end

local create_Z_shape_approach_block_node = require("Z_shape_approach_block")
local create_curved_approach_block_node = require("curved_approach_block")

local create_approach_block_node = function(search_node, target, _distance)
   return -- return the following table
{
   type = "sequence*",
   children = {
      search_node,
      {
         type = "selector*",
         children = {
            function() DebugMSG("I am before curved approach") return false, false end,
            create_curved_approach_block_node(target, _distance),
            {
               type = "sequence*",
               children = {
                  create_Z_shape_approach_block_node(target, _distance + 0.05),
                  search_node,
                  create_curved_approach_block_node(target, _distance),
               },
            },
         },
      },
   }, -- end of children of the return table
} -- end of the return table
end

return create_approach_block_node
