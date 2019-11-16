local rules = {}
rules.list = {
   {
      rule_type = 'place',
      structure = {
         {
            index = vector3(0, 0, 0),
            color = "pink"
         }
      },
      target = {
         reference_index = vector3(0, 0, 0),
         offset_from_reference = vector3(0, 0, 1),
         color = "green"
      },
      generate_orientations = false
   },
}
rules.selection_method = 'furthest_win'
return rules