local pickup_block = {
   type = "sequence*",
   children = {
      -- touch down
      {
         type = "selector",
         children = {
            -- hand full ?
            function()
               print("check full")
               if robot.rangefinders["underneath"].proximity ~= 0 and
                  robot.rangefinders["underneath"].proximity < 0.005 then
                  return false, true -- not running, true
               else
                  return false, false -- not running, false
               end
            end,
            -- low lift
            function()
               print("set down")
               robot.lift_system.set_position(0)
               return true
            end,
         },
      },
      -- count and raise
      {
         type = "sequence*",
         children = {
            -- wait
            function()
               print("start waiting")
               if BTDATA.pickup_block == nil then 
                  BTDATA.pickup_block = {}
               end
               BTDATA.pickup_block.count = 0
               return false, true
            end,
            function()
               print("add one")
               BTDATA.pickup_block.count = BTDATA.pickup_block.count + 1
               if BTDATA.pickup_block.count == 10 then
                  return false, true
               else
                  return true
               end
            end,
            -- raise 
            function()
               print("raising")
               robot.lift_system.set_position(robot.lift_system.position + 0.05)
               return false, true  -- not running, true
            end,
         },
      },
   }
}

return pickup_block
