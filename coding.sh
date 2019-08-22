vim coding.sh -c "
   set ts=3
   set shiftwidth=3
   set expandtab

   tabnew README

   tabnew testing/01_FirstExample.lua
   vsp testing/01_FirstExample.argos

   tabnew BuilderBotLibrary.lua

   tabnew Tools/ShowTable.lua
"
