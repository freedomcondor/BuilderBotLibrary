local DebugMessage = {}
DebugMessage.mt = {}
setmetatable(DebugMessage, DebugMessage.mt)

-- call DebugMessage(...)
function DebugMessage.mt:__call(...)
	local info = debug.getinfo(2)
   local src = info.short_src
   local moduleName = DebugMessage.modules[src]
   if moduleName == nil then moduleName = "nil" end
   if DebugMessage.switches[moduleName] == true then
      --print("DebugMSG:\t" .. moduleName .. ":" .. info.currentline .. "\t", ...)
      print("DebugMSG:\t", ...)
   end
end

DebugMessage.modules = {}
DebugMessage.switches = {}
DebugMessage.switches["nil"] = false

function DebugMessage.register(moduleName)
	local info = debug.getinfo(2)
   local src = info.short_src
   DebugMessage.modules[src] = moduleName
   DebugMessage.switches[moduleName] = false
end

function DebugMessage.disable(moduleName)
   if moduleName == nil then
      for i, v in pairs(DebugMessage.switches) do
         DebugMessage.switches[i] = false
      end
   else
      DebugMessage.switches[moduleName] = false
   end
end

function DebugMessage.enable(moduleName)
   if moduleName == nil then
      for i, v in pairs(DebugMessage.switches) do
         DebugMessage.switches[i] = true
      end
   else
      DebugMessage.switches[moduleName] = true
   end
end

return DebugMessage
