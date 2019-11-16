local rules = {}
rules.list = {
   {
      rule_type = 'pickup',
      structure = {
         {
            index = vector3(0, 0, 0),
            color = "black"
         }
      },
      target = {
         reference_index = vector3(0, 0, 0),
         offset_from_reference = vector3(0, 0, 0),
         color = "pink"
      },
      generate_orientations = false
   },
   {
      rule_type = 'place',
      structure = {
         {
            index = vector3(0, 0, 0),
            color = "orange"
         }
      },
      target = {
         reference_index = vector3(0, 0, 0),
         offset_from_reference = vector3(0, 0, 1),
         color = "orange"
      },
      generate_orientations = false
   },
   {
      rule_type = 'place',
      structure = {
         {
            index = vector3(0, 0, 0),
            color = "orange"
         },
         {
            index = vector3(0, 0, 1),
            color = "orange"
         }
      },
      target = {
         reference_index = vector3(0, 0, 1),
         offset_from_reference = vector3(1, 0, -1),
         color = "orange"
      },
      generate_orientations = false
   }
}
rules.selection_method = 'nearest_win'
return rules
