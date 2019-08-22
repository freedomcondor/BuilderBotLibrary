local CoordinateTransfer = {}
function CoordinateTransfer.LocationTransferV3(theLocInYourEyeV3, yourLocInMyEyeV3, yourOrieInMyEyeQ)
   local vecV3 = vector3(theLocInYourEyeV3) -- remember to copy !!
   return yourLocInMyEyeV3 + vecV3:rotate(yourOrieInMyEyeQ)
end
return CoordinateTransfer
