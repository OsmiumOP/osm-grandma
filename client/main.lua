QBCore = nil

Citizen.CreateThread(function()
    while QBCore == nil do
        TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
        Citizen.Wait(0)
    end
end)

local pedloaded = false

-- CONFIG VARS
grannypos = { x = 3312.95, y = 5178.88, z = 18.63, h = 210.79 }
model = "ig_mrs_thornhill"

local hash = GetHashKey(model)

Citizen.CreateThread(function()
if not pedloaded then 
    RequestModel(GetHashKey(model))
	
    while not HasModelLoaded(GetHashKey(model)) do
        Wait(1)
    end

	local npc = CreatePed(4, hash, grannypos.x, grannypos.y, grannypos.z, grannypos.h, false, true)

	SetEntityHeading(npc, grannypos.h)
	FreezeEntityPosition(npc, true)
	SetEntityInvincible(npc, true)
	SetBlockingOfNonTemporaryEvents(npc, true)

	local pedloaded = true

end)

local prob = math.random(1,10)

healAnimDict = "mini@cpr@char_a@cpr_str"
healAnim = "cpr_pumpchest"

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
    local plyCoords = GetEntityCoords(PlayerPedId(), 0)
    local pos = GetEntityCoords(GetPlayerPed(-1))
        local distance = #(vector3(grannypos.x, grannypos.y, grannypos.z) - plyCoords)
        if distance < 10 then
            if not IsPedInAnyVehicle(PlayerPedId(), true) then
                if distance < 3 then
                    QBCore.Functions.DrawText3D(grannypos.x, grannypos.y, grannypos.z + 0.5, '[E] - Request Grandma for $2,000')
                    DisableControlAction(0, 57, true)
                    if IsDisabledControlJustReleased(0, 54) then

                        QBCore.Functions.Progressbar("check-", "Requesting Grandma for Help", 5000, false, true, {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        }, {}, {}, {}, function()
                            if prob > 5 then
                             loadAnimDict('missheistdockssetup1clipboard@base')
                             TaskPlayAnim( PlayerPedId(), "missheistdockssetup1clipboard@base", "base", 3.0, 1.0, -1, 49, 0, 0, 0, 0 ) 
                             loadAnimDict(healAnimDict)	
                             TaskPlayAnim(ped, healAnimDict, healAnim, 3.0, 3.0, 8000, 49, 0, 0, 0, 0)
                             QBCore.Functions.Progressbar("check-", "Blessing You with a Life", 10000, false, true, {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                             }, {}, {}, {}, function()
                                QBCore.Functions.Notify("You're were treated! ..", "success")
                                TriggerEvent('hospital:client:Revive')
                                TriggerServerEvent('osm-grandma:server:Charge')
                                ClearPedTasks(PlayerPedId())
                             end, function() -- Cancel
                                ClearPedTasks(PlayerPedId())
                            end)
                        else 
                            QBCore.Functions.Notify("Grandma Refused to Help", "error")
                        end 
                        end)
                            
                        
                    end
                end
            end
        else
            Citizen.Wait(1000)
        end
    end
end)
