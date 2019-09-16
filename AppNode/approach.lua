local api = require("BuilderBotAPI")

function get_target_block()
   target_block = nil
   for i, block in pairs(api.blocks)do 
      pprint(i, block)
   end

   -- pprint(api.blocks)


   return target_block
end
local approach = {
   type = "sequence",
   children = {
      function()
         block = get_target_block()
         return false,false
      end,
   }
}

return approach
