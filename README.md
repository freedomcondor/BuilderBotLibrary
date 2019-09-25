# The BuilderBot Library
## Prerequisites 
1. Compile and install the [ARGoS simulator](https://github.com/ilpincy/argos3)
2. Compile and install the [SRoCS plugin for the ARGoS simulator](https://github.com/allsey87/argos3-srocs)

## Usage
### Running an example
`argos3 -c testing/01_FirstExample.argos`

## Hints
1. If there is a problem was loading libraries, try running `sudo ldconfig` on Linux or `sudo update_dyld_shared_cache` on OS X. This issue is also resolved by restarting the computer.
2. The Lua API in ARGoS provides access to the CVector2, CVector3, and CQuaternion classes. For example, you can:
```lua
local a = vector3(1,0,0)
local b = quaternion(math.pi/2, vector3(0,0,1))    -- a rotation by pi/2 around z axis
local a:rotate(b)
print(a)   -- a would be (0,1,0)
```

## Development
### Coding Standard
1. Indentation is always done by 3 spaces, tabs are not allowed.
2. Functions are variable names are lower case and seperated by underscrolls. 

```lua
if condition then
   result_one, result_two = do_something()
   do_something_else(result_two)
end
```

### API Levels
Applications are designed by using the functions provided by the intermediate API. These functions are supposed to encapsulated inside [finite state machine states](https://github.com/allsey87/luafsm) or [behavior tree nodes](https://github.com/allsey87/luabt).
```lua
api = require("builderbot.api")
cv = require("builderbot.cv")
bt = require("utils.bt")
approach_root_node = bt.create(...)
```
The intermediate layer is composed of functions designed to be used in the application layer.
```lua
api.move = function(xxx)
   robot.differential_drive_system.set_speed(xxx)
end

api.get_blocks = function(xxx)
   for tag in robot.camera_system.get_tags() do
      process_tag(tag)
   end
end
```

### APP Levels
Application level provides some behaviour tree nodes for user to use directly.
Example of use:
```lua
   app = require('ApplicationNode') -- these need to be global

   bt.create{
      type = 'sequence*',
      children = {
         app.create_search_block_node(create_pickup_rule_node(BTDATA.target)),
         app.create_approach_block_node(BTDATA.target, 0.17),
         app.create_pickup_block_node(BTDATA.target, 0.025),
      },
   }
```
In ApplicationNode.lua, you can find a list of nodes that are provided, each node is implemented in a seperate file located in the folder AppNode
The following nodes are provided:

```lua
create_search_block_node = require('search_block')
   -- create_search_block_node = function(rule_node)
   -- create a search node based on rule_node

create_approach_block_node = require("approach_block")
   -- create_approach_block_node = function(target, _distance)
   -- approach the target reference block until _distance away 

create_pickup_block_node = require('pickup_block')
   -- create_pickup_block_node = function(target, _forward_distance)
   -- assume i am _forward_distance away from the block
   -- shameful move blindly for that far (use reach_block node)
   -- move down manipulator to pickup

create_place_block_node = require('place_block')
   -- create_place_block_node = function(target, _forward_distance)
   -- assume i am _forward_distance away from the block
   -- shameful move blindly for that far (use reach_block node)
   -- anti release the electomagnet to drop the block

create_reach_block_node = require("reach_block")
   -- create_reach_block_node = function(target, _distance)
   -- assuming i'm just infront of the block, 
   -- shamefully forward blindly for a certain _distance
   -- based on target.offset, adjust the distance and 
   --                         raise or lower the manipulator
   --     offset could be vector3(0,0,0), means the reference block itself
   --                     vector3(1,0,0), means just infront of the reference block
   --                     vector3(0,0,1), top of the reference block
   --                     vector3(1,0,-1)
   --                     vector3(1,0,-2)


create_aim_block_node = require('aim_block')
   -- create_aim_block_node = function(target)
   -- aim block, put the block into the center of the image

create_timer_node = require('timer')
   -- create_timer_node = function(para)
   -- para = {time, func}
   -- count from 0, to para.time, with increment of api.time_period
   -- each step do para.func()
   -- need to do api.process_time everytime
```
