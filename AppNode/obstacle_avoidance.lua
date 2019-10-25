if DebugMSG == nil then DebugMSG = require('DebugMessage') end
DebugMSG.register("obstacle_avoidance")

if api == nil then api = require('BuilderBotAPI') end
local create_timer_node = require("timer")

-- if there are obstacles avoid it and return running
-- if there no obstacles, return true
local create_obstacle_avoidance_node = function()
   return 
{
   type = "selector*",
   children = {
      -- no obstacle?
      function()
         print("this this this")
         local flag = false
         DebugMSG("obstacles")
         DebugMSG(api.obstacles)
         for i, v in ipairs(api.obstacles) do
            if v.rangefinder == "1" or
               v.rangefinder == "2" or
               v.rangefinder == "12" or
               v.rangefinder == "11" then
               flag = true
               break
            end
         end
         if flag == true then return false, false
                         else return false, true end
      end,
      -- avoid
      {
         type = "sequence*",
         children = {
            -- backup 8 cm
            app.create_timer_node({time = 0.08 / 0.005, 
                                   func = function() api.move(-0.005, -0.005) end,}),
            -- turn 180
            create_timer_node({time = 180 / 5, 
                               func = function() api.move_with_bearing(0, 5) end,}),
         },
      },
   },
}

end

return create_obstacle_avoidance_node
