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
builderbot.move = function(xxx)
   robot.differential_drive_system.set_speed(xxx)
end

builderbot.get_blocks = function(xxx)
   for tag in robot.camera_system.get_tags() do
      process_tag(tag)
   end
end
```

