local search_block = {
   type = "sequence",
   children = {
      -- prepare, lift to 0.07
      {
         type = "selector",
         children = {
            -- if lift reach position(0.07)
            function()
               if robot.lift_system.position > 0.065 then
                  return false, true
               else
                  return false, false
               end
            end,
            -- set position(0.07)
            function()
               robot.lift_system.set_position(0.07)
               return true -- always running
            end,
         },
      },
      --search
      {
         type = "selector",
         children = {
            -- if I choose a block
            {
               type = "sequence",
               children = {
                  -- choose block
                  function()
                     return BTDATA.search_block.choose()
                  end,
                  -- if successfully choose, stop turning
                  function() api.move(0,0) end,
               },
            },
            -- turn the robot
            function()
               api.move(0.01, -0.01)
               return true
            end,
         },
      },
   },
}

return search_block
