vim coding.sh -c "
   set ts=3
   set shiftwidth=3
   set expandtab

   tabnew README.md

   tabnew block.lua

   tabnew testing/05_StructureTest.lua
   vsp testing/05_StructureTest.argos

   tabnew BuilderBotAPI.lua
   vsp ApplicationNode.lua

   tabnew AppNode/search_block.lua
   tabnew AppNode/approach_block.lua
   tabnew AppNode/reach_block.lua
   tabnew AppNode/aim_block.lua
   tabnew AppNode/pickup_block.lua
   tabnew AppNode/place_block.lua
   tabnew AppNode/count_node.lua
"

<<COMMENT
   tabnew testing/01_FirstExample.lua
   vsp testing/01_FirstExample.argos

   tabnew testing/02_BlockTrackingTest.lua
   vsp testing/02_BlockTrackingTest.argos
   
   tabnew testing/04_SearchApproachPick.lua
   vsp testing/04_SearchApproachPick.argos

   tabnew Tools/BlockTracking.lua
   tabnew Tools/Hungarian.lua
   tabnew Tools/ShowTable.lua
COMMENT
