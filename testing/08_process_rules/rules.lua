local rules = {}
rules.list = {
   {
      rule_type = 'place',
      structure = {
         {
            index = vector3(0, 0, 0),
            type = 3
         }
      },
      target = {
         reference_index = vector3(0, 0, 0),
         offset_from_reference = vector3(0, 0, 1),
         type = 3
      },
      generate_orientations = false
   },
   {
      rule_type = 'place',
      structure = {
         {
            index = vector3(0, 0, 0),
            type = 3
         },
         {
            index = vector3(0, 0, 1),
            type = 3
         }
      },
      target = {
         reference_index = vector3(0, 0, 1),
         offset_from_reference = vector3(0, 0, 1),
         type = 3
      },
      generate_orientations = false
   },
   {
      rule_type = 'place',
      structure = {
         {
            index = vector3(0, 0, 0),
            type = 3
         },
         {
            index = vector3(0, 0, 1),
            type = 3
         },
         {
            index = vector3(0, 0, 2),
            type = 3
         }
      },
      target = {
         reference_index = vector3(0, 0, 1),
         offset_from_reference = vector3(1, 0, -1),
         type = 3
      },
      generate_orientations = false
   },
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