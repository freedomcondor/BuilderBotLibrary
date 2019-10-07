local app_nodes = {}

app_nodes.create_search_block_node = require('search_block')
app_nodes.create_approach_block_node = require("approach_block")
app_nodes.create_blind_approach_block_node = require("blind_approach_block")
app_nodes.create_pickup_block_node = require('pickup_block')
app_nodes.create_place_block_node = require('place_block')
app_nodes.create_reach_block_node = require("reach_block")
app_nodes.create_aim_block_node = require('aim_block')
app_nodes.create_timer_node = require('timer')
app_nodes.create_move_to_location_node = require("move_to_location")

return app_nodes
