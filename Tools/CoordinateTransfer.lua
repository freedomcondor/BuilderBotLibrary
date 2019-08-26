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

function CoordinateTransfer.OrientationFromEulerAngles(zRadian, yRadian, xRadian)
   print(zRadian, yRadian, xRadian)
   local a = vector3(0,0,0)
   local X = quaternion(xRadian, vector3(1,0,0))
   local Y = quaternion(yRadian, vector3(0,1,0))
   local Z = quaternion(zRadian, vector3(0,0,1))
   return X * Y * Z
end

return CoordinateTransfer
