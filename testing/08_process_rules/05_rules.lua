local rules = {}
rules.list = {
   {
      rule_type = 'place',
      structure = {
         {
            index = vector3(0, 0, 0),
            color = "pink"
         },
         {
            index = vector3(1, 0, 0),
            color = "pink"
         },
         {
            index = vector3(1, 1, 0),
            color = "pink"
         }
      },
      target = {
         reference_index = vector3(1, 1, 0),
         offset_from_reference = vector3(1, 0, 0),
         color = "green"
      },
      generate_orientations = false
   }
}
rules.selection_method = 'nearest_win'
return rules
