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
- ##### [furthest target](https://github.com/freedomcondor/BuilderBotLibrary/blob/develop/testing/08_process_rules/04_furthest_target_test.argos)
- ##### [unalligned robot](https://github.com/freedomcondor/BuilderBotLibrary/blob/develop/testing/08_process_rules/05_unalligned_robot_test.argos)
	
    