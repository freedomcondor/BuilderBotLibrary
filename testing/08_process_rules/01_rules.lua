local rules = {}
rules.list = {
   {
      rule_type = 'pickup',
      structure = {
         {
            index = vector3(0, 0, 0),
            color = "blue"
         }
      },
      target = {
         reference_index = vector3(0, 0, 0),
         offset_from_reference = vector3(0, 0, 0),
         color = "green"
      },
      generate_orientations = false
   }
}
rules.selection_method = 'nearest_win'
return rules