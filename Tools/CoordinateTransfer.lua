local CoordinateTransfer = {}

-- Location/Orientation Transfer means 
--    to transfer a location(vector)/orientation(quaternion) in your coordinate system to my coordinate system
--    based on your location and orientation to me

function CoordinateTransfer.LocationTransferV3(theLocInYourEyeV3, yourLocInMyEyeV3, yourOrieInMyEyeQ)
   local vecV3 = vector3(theLocInYourEyeV3) -- remember to copy !!
   return yourLocInMyEyeV3 + vecV3:rotate(yourOrieInMyEyeQ)
end

function CoordinateTransfer.OrientationTransferQ(theOriInYourEyeQ, yourOrieInMyEyeQ)
   return yourOrieInMyEyeQ * theOriInYourEyeQ 
end

return CoordinateTransfer
