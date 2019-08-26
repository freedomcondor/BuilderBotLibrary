vim coding.sh -c "
   set ts=3
   set shiftwidth=3
   set expandtab

   tabnew README


   tabnew testing/02_BlockTrackingTest.lua
   vsp testing/02_BlockTrackingTest.argos

   tabnew BuilderBotLibrary.lua

   tabnew Tools/BlockTracking.lua

   tabnew Tools/Hungarian.lua

   tabnew Tools/ShowTable.lua
"

<<COMMENT
   tabnew testing/01_FirstExample.lua
   vsp testing/01_FirstExample.argos
COMMENT
