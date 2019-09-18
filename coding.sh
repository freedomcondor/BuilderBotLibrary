vim coding.sh -c "
   set ts=3
   set shiftwidth=3
   set expandtab

   tabnew README.md

   tabnew testing/02_BlockTrackingTest.lua
   vsp testing/02_BlockTrackingTest.argos

   tabnew testing/04_SearchApproachPick.lua
   vsp testing/04_SearchApproachPick.argos

   tabnew testing/001_PickupBlockTest.lua
   vsp testing/001_PickupBlockTest.argos

   tabnew BuilderBotAPI.lua

   tabnew ApplicationNode.lua

   tabnew AppNode/search_block.lua
   tabnew AppNode/approach_block.lua
   tabnew AppNode/pickup_block.lua
"

<<COMMENT
   tabnew testing/01_FirstExample.lua
   vsp testing/01_FirstExample.argos
   
   tabnew Tools/BlockTracking.lua
   tabnew Tools/Hungarian.lua
   tabnew Tools/ShowTable.lua
COMMENT
