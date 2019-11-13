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

### Debug
There is a DebugMessage tool, please use DebugMessage instead of print:
```lua
DebugMSG = require('DebugMessage')
DebugMSG("i = ", i)
```
DebugMessage can be enable and disable modularily. "modularily" means you can register a file as a module, and enable or disable this module

```lua
-- In main.lua
DebugMSG = require('DebugMessage')
includeFile1 = require('IncludeFile1')
includeFile2 = require('IncludeFile2')

-- the switch are here
-- DebugMSG.enable() to enable all debug messages
-- DebugMSG.disable() to disable all debug messages
-- DebugMSG.disable("module1") to disable messages from File IncludeFile1.lua
-- DebugMSG.enable("module1") to enable messages from File IncludeFile1.lua
-- In the following case, only "I am main" and "I am F2" will be printed
DebugMSG.enable()
DebugMSG.disable("module1")

DebugMSG("I am main")
-- In IncludeFile1.lua
DebugMSG.register("module1")
function F1()
   DebugMSG("I am F1")
end

-- In IncludeFile2.lua
DebugMSG.register("module2")
function F1()
   DebugMSG("I am F2")
end
```

DebugMessage also provides function to show table content, if the first parameter is a table, it will parse the table recursively and show it (ignores the rest parameters)
```lua
DebugMSG = require('DebugMessage')
local a = {a = 1, b = "lalala", c = function() print("test") end}
DebugMSG(a)
```
result will be
```
DebugMSG:	c	function: 0x559b50944d70
DebugMSG:	b	lalala
DebugMSG:	a	1
```

### Parameters
There are some parameters can be defined in .argos file, for example, the default speed of the robot. Specify the parameters when declaring the lua controller node:

```
      <params script="testing/05_StructureTest.lua"
              default_speed="0.01" 
              block_position_tolerance="0.01"
              aim_block_angle_tolerance="4"
              />
```

provided parameters can be seen in builderbot\_api.parameters = {}, which is in BuilderBotAPI.lua file


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

## Documents
In ApplicationNode.lua, you can find a list of nodes that are provided, each node is implemented in a seperate file located in the folder AppNode

### search
xxxx

### approach
There are two basic approach method is provided, Z shape approach and curved approach.

app.create\_Z\_shape\_approach\_node(target, distance) will create a bt node, which makes the robot first analyzes the location of the target block, and close the camera and perform a rotation-forward-rotation action to a location which is just in front of the target block with a distance which is given as a parameter.

app.create\_curved\_approach\_node(target, distance) will create a bt node, which makes the robot approach the block while keep the block in the range of its camera. The robot will move forward and backward in turns until it gets the location right in front of the block with the distance given as the second parameter.

app.create\_approach\_node(search\_node, target, distance) is a combination of these two approach method. It takes search\_node as a parameter because during Z\_shape approach the robot will lost the target block, it has to search again after Z\_shape\_approach

### pickup and place block
app.create\_pickup\_block\_node and app.create\_place\_block\_node will create nodes that...

### timer
xxxx

### Process rules
This node is located in AppNode\_process\_rules.lua
#### Description
This node is passive (does not move the robot) unlike the rest of the nodes in the system.

It procesess `api.blocks` into groups of connected blocks, give the blocks unified indexes (those indexes describe the structure/substructure), matches the percieved structure with the rules (the rules are stored in a separate file, more of that later) and assigns a target\_block and offset if available.
#### Inputs/Outputs
- ##### rules list (input)
	This list is passed to the main controller as a parameter from .argos file. It contains all the rules necessary to do the required construction (full description of the file and how to right the rules later)
- ##### type (input)
	Takes `pickup/place`. It tells process rules which type of rules to look for. 
- ##### target (output)
	This table is passed to process_rules to be modified with the correct target.
    The target block is the reference block that the robot uses to reach target+offset.
    Target is not the final destination of the robot.
	- ###### target.reference_id:
		contains the id of the target block. The id is compatible with the ids in `api.blocks`.
	- ###### target.offset:
		The offset from the target. target+offset determine the position of the block to be placed or picked up.
        The offset is represented based on the target block frame of reference, more of that in the rules description.
    - ###### target.type:
    	This represent the color which we need to set the block to before place or after pickup.
    - ###### target.safe:
    	If `true` then the rules has been matched safely and it is safe to continue with the action. But, if `false` then `process rules` is not sure of what it sees (some blocks might not be fully visible) and therefore, it is not safe/wise to continue with the action.
- ##### `api.blocks` this is not a parameter.
	process rules also uses the information of the blocks. 
#### How to roll with rules 
The rules file contains:
- ##### list of rules 
	to be matched against in process_rules.
    Each rule of the list contains:
    - ##### rule_type
        `'pickup'/'place'`
    - ##### structure
        contains a list of blocks that form the structure/substructure. Each block of the list contains:
        - ###### index 
            It is a `vector3` that represents the position of the block with respect to the robot.
            When describing the index of the block, the robot is positioned just in front of the structure (the robot is positioned on the floor aligned with the structure). The indexes should follow the directions of the robots reference frame (shown later). The origin (0,0,0) of the indexes is to be defined by the rules writer and should be followed respectively by the user (if it is not clear, perhaps we should include some images from the presentation here)
        - ###### type 
            This represents the color of the block (it is an integer between 0 - 4)
    - ##### target
        - ###### reference_index 
            This represents the index of the target block which will be used by the robot as a reference while approaching target + offset
        - ###### offset_from_reference
            The offset from the target block. This offset + reference_index represents the final position of the block to be place or picked up.
        - ###### type
            type of the target to be set before placing the block or after pickup (still not implemented, probably it is better to put this in a separate field ¨actions¨)
    - ##### generate_orientations
        Binary input. When `true`, process_rules generates 3 more orientations of this rule so that the total would be 4 rules representing the same structure description from all for points of view (if it is not clear, perhaps we should include some images from the presentation here). The generated rules are transparent to the upper layer. 
      
- ##### rules.selection_method
	process rules offers two methods to select the winning rule in case more than one rule matches with the environment.
    Those methods (for the moment) are `'nearest_win'` and `'furthest_win'`.


##### Simple Example

```local rules = {}
rules.list = {
   {
      rule_type = 'pickup',
      structure = {
         {
            index = vector3(0, 0, 0),
            type = 4
         }
      },
      target = {
         reference_index = vector3(0, 0, 0),
         offset_from_reference = vector3(0, 0, 0),
         type = 1
      },
      generate_orientations = false
   }
}
rules.selection_method = 'nearest_win'
return rules
```
#### Visualization
To demonstrate the results of process_rules, we use two arrows. The red arrow points from the target block up. The blue arrow points from target+offset up.
In the case of pick up, there is only one arrow. 
Four green arrows mark the safe zone. All blocks that are found inside this zone are considered safe.  
#### Reference frames robot, block
- ##### Robots reference frame
	- X axis pointing forward
    - Y axis pointing to the left
    - Z axis pointing up
- ##### Camera reference frame
	- X axis pointing left
	- Y axis pointing down 
	- Z axis pointing far from the camera
- ##### Block reference frame
	Having the robot in front of the block, looking from the block to the robot
	- X axis pointing forward
	- Y axis pointing left
	- Z axis pointing up
- ##### Face reference frame
	So far it is not necessary for this module, might be in the future

#### Examples/tests
- ##### [basic test](https://github.com/freedomcondor/BuilderBotLibrary/blob/develop/testing/08_process_rules/01_basic_test.argos)
	This test is the simplest case possible for process_rules. In the environment we have one block only. The robot lifts up the manipulator and calls process_rules.
- ##### [colomn matching](https://github.com/freedomcondor/BuilderBotLibrary/blob/develop/testing/08_process_rules/02_colomn_matching_test.argos)
	In this test we have the robot situated in front of a column of 3 blocks of different colors:
    ```
    structure = {
             {
                index = vector3(0, 0, 0),
                type = 1
             },
             {
                index = vector3(0, 0, 1),
                type = 3
             },
             {
                index = vector3(0, 0, 2),
                type = 4
             }
          }
  	```
  The camera sees all blocks and tries to match the rules for each block. The rules would match for all three cases. Having the middle block in a safe zone reflects in having the final result as safe (shown in the terminal).
      The target block in this example is the middle block expressed as `reference_index = vector3(0, 0, 1)` in the `rules.lua` file and the `offset_from_reference = vector3(1, 0, -1))` which translates in the empty position in front of the first block.
- ##### [nearest target](https://github.com/freedomcondor/BuilderBotLibrary/blob/develop/testing/08_process_rules/03_nearest_target_test.argos)
	
    