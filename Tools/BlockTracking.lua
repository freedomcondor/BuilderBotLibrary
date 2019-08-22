local BLOCKLENGTH = 0.055
local CoorTrans = require("CoordinateTransfer")

function BlockTracking(_blocks, _tags)
   local blocks = _blocks
   for i, v in ipairs(blocks) do blocks[i] = nil end

   local p = vector3(0, 0, -BLOCKLENGTH/2)
   for i, tag in ipairs(_tags) do
      local middlePointV3 = CoorTrans.LocationTransferV3(p, tag.position, tag.orientation)

      -- find which block it belongs
      local flag = 0
      for j, block in ipairs(blocks) do
         if (middlePointV3 - block.position):length() < BLOCKLENGTH/3 then
            flag = 1
            block.tags[#block.tags + 1] = tag
            break
         end
      end
      if flag == 0 then
         blocks[#blocks + 1] = {position = middlePointV3, 
                                orientation = tag.orientation,
                                tags = {tag},
                               }
      end
   end
end
