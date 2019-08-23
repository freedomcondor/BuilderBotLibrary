local BLOCKLENGTH = 0.055
local CoorTrans = require("CoordinateTransfer")

local function FindBlockXYZ(orientation)
   --    this function finds axis of a block :    
   --         |Z           Z| /Y       the one pointing up is z
   --         |__ Y         |/         the nearest one pointing towards the camera is x
   --        /               \         and then y follows right hand coordinate system
   --      X/                 \X

   -- All vector in the system of the camera
   --             /z
   --            /
   --            ------- x
   --            |
   --            |y     in the camera's eye

   local X, Y, Z -- vectors of XYZ axis of a block (in camera's coor system) 

   -- all the 6 dirs of a block
   local dirs = {}
   dirs[1] = vector3(1,0,0)
   dirs[2] = vector3(0,1,0)
   dirs[3] = vector3(0,0,1)
   dirs[1]:rotate(orientation)
   dirs[2]:rotate(orientation)
   dirs[3]:rotate(orientation)
   dirs[4] = -dirs[1]
   dirs[5] = -dirs[2]
   dirs[6] = -dirs[3]

   -- clear out 3 pointing far away
   for i, v in pairs(dirs) do
      if v.z > 0 then dirs[i] = nil end
   end

   -- choose the one pointing highest(min y) as Z 
   local highestI 
   local highestY = 0
   for i, v in pairs(dirs) do
      if v.y < highestY then highestY = v.y highestI = i end
   end
   Z = dirs[highestI]
   dirs[highestI] = nil

   -- choose the one pointing nearest(min z) as X
   local nearestI 
   local nearestZ = 0
   for i, v in pairs(dirs) do
      if v.z < nearestZ then nearestZ = v.z nearestI = i end
   end
   X = dirs[nearestI]
   dirs[nearestI] = nil

   Y = vector3(Z):cross(X) -- stupid argos way of saying Y = Z * X

   return X, Y, Z
end

function BlockTracking(_blocks, _tags)
   local blocks = _blocks
   for i, v in ipairs(blocks) do blocks[i] = nil end

   -- cluster tags into blocks
   local p = vector3(0, 0, -BLOCKLENGTH/2)
   for i, tag in ipairs(_tags) do
      local middlePointV3 = CoorTrans.LocationTransferV3(p, tag.position, tag.orientation)

      -- find which block it belongs
      local flag = 0
      for j, block in ipairs(blocks) do
         if (middlePointV3 - block.position):length() < BLOCKLENGTH/3 then
            flag = 1
            block.tags[#block.tags + 1] = tag
            block.positionSum = block.positionSum + middlePointV3
            break
         end
      end
      if flag == 0 then
         blocks[#blocks + 1] = {position = middlePointV3, 
                                positionSum = middlePointV3,
                                orientation = tag.orientation,
                                tags = {tag},
                               }
      end
   end
   -- average block position
   for i, block in ipairs(blocks) do
      block.position = block.positionSum * (1/#block.tags)
      block.positionSum = nil
   end

   -- adjust block orientation
   for i, block in ipairs(blocks) do
      block.X, block.Y, block.Z = FindBlockXYZ(block.orientation)
   end
end

