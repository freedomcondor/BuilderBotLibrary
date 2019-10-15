if DebugMSG == nil then DebugMSG = require('DebugMessage') end
DebugMSG.register("approach_block")

if api == nil then api = require('BuilderBotAPI') end

local create_approach_block_node = function(target, _distance)
   return -- return the following table
{
   type = "selector",
   children = {

   }, -- end of children of the return table
} -- end of the return table
end
