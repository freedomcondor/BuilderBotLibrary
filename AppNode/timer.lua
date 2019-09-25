local create_timer_node = function(para)
   -- para = {time, func}
   -- count from 0, to para.time, with increment of api.time_period
   -- each step do para.func()
   -- need to do api.process_time everytime
   local current
   return {
      type = "sequence*",
      children = {
         function()
            current = 0
            return false, true
         end,
         function()
            current = current + api.time_period
            if current > para.time then
               return false, true
            else
               if type(para.func) == "function" then para.func() end
               return true
            end
         end,
      },
   }
end

return create_timer_node
