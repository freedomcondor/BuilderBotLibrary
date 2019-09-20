--local api = require('BuilderBotAPI') -- these may not be needed
--local bt = require('luabt')
local app_nodes = {}

app_nodes.create_search_block = require('search_block')
   -- create_search_block = function(rule_node)
   -- create a search node based on rule_node

app_nodes.create_approach_block = require("approach_block")
   -- create_approach_block = function(target, _distance)
   -- approach the target reference block until _distance away 

app_nodes.create_pickup_block = require('pickup_block')
   -- create_pickup_block = function(target, _forward_distance)
   -- assume I am _forward_distance away from the block
   -- shameful move blindly for that far (use reach_block node)
   -- move down manipulator to pickup

app_nodes.create_place_block = require('place_block')
   -- create_place_block = function(target, _forward_distance)
   -- assume I am _forward_distance away from the block
   -- shameful move blindly for that far (use reach_block node)
   -- anti release the electomagnet to drop the block

app_nodes.create_reach_block = require("reach_block")
   -- create_reach_block = function(target, _distance)
   -- assuming I'm just infront of the block, 
   -- shamefully forward blindly for a certain _distance
   -- based on target.offset, adjust the distance and 
   --                         raise or lower the manipulator
   --     offset could be vector3(0,0,0), means the reference block itself
   --                     vector3(1,0,0), means just infront of the reference block
   --                     vector3(0,0,1), top of the reference block
   --                     vector3(1,0,-1)
   --                     vector3(1,0,-2)


app_nodes.create_aim_block = require('aim_block')
   -- create_aim_block = function(target)
   -- aim block, put the block into the center of the image

app_nodes.create_count_node = require('count_node')
   -- create_count_node = function(para)
   -- para = {start, finish, speed, func}
   -- count from start to finish with increment of speed * api.time_period
   -- each step do func()
   -- need to do api.process_time everytime

return app_nodes
