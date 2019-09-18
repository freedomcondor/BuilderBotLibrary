function init()
   if robot.id == "block1" or robot.id == "block2" then
      robot.directional_leds.set_all_colors("blue")
   else
      robot.directional_leds.set_all_colors("green")
   end
end
function step()
end
function reset()
end
function destroy()
end
