local create_count_node = function(startv, endv, speed, func)
   local current
   return {
      type = "sequence*",
      children = {
         function()
            current = startv
            return false, true
         end,
         function()
            print("current = ", current)
            print("endv = ", endv)
            print("time_period = ", api.time_period)
            current = current + speed * api.time_period
            if current > endv then
               return false, true
            else
               if type(func) == "function" then func() end
               return true
            end
         end,
      },
   }
end

return create_count_node
