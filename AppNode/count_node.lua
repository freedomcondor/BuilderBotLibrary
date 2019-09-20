local create_count_node = function(para)
   -- para = {start, finish, speed, func}
   -- count from start to finish with increment of speed * api.time_period
   -- each step do func()
   -- need to do api.process_time everytime
   local current
   return {
      type = "sequence*",
      children = {
         function()
            current = para.start
            return false, true
         end,
         function()
            print("current = ", current)
            print("endv = ", para.finish)
            print("time_period = ", api.time_period)
            current = current + para.speed * api.time_period
            if current > para.finish then
               return false, true
            else
               if type(para.func) == "function" then para.func() end
               return true
            end
         end,
      },
   }
end

return create_count_node
