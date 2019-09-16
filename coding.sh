vim coding.sh -c "
   set ts=3
   set shiftwidth=3
   set expandtab

   tabnew README.md

   tabnew testing/01_FirstExample.lua
   vsp testing/01_FirstExample.argos
   
   tabnew testing/02_BlockTrackingTest.lua
   vsp testing/02_BlockTrackingTest.argos

   tabnew testing/001_GrabBlockTest.lua
   vsp testing/001_GrabBlockTest.argos

   tabnew BuilderBotAPI.lua
   tabnew ApplicationNode.lua
   tabnew AppNode/grab_block.lua
"

<<COMMENT
   tabnew Tools/BlockTracking.lua
   tabnew Tools/Hungarian.lua
   tabnew Tools/ShowTable.lua
COMMENT
