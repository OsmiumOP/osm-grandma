QBCore = nil

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(10)
        if QBCore == nil then
            TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
            Citizen.Wait(200)
        end
    end
end)

isLoggedIn = true

RegisterNetEvent("QBCore:Client:OnPlayerUnload")
AddEventHandler("QBCore:Client:OnPlayerUnload", function()
    isLoggedIn = false
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    SpawnPed()
end)

grannypos = { x = 1596.92, y = 3596.03, z = 37.8, h = 114.99 }
model = "cs_orleans"


function SpawnPed()
if isLoggedIn then 
       local hash = GetHashKey(model) 
       RequestModel(hash)
        
        while not HasModelLoaded(hash) do Citizen.Wait(0) end

        ped = CreatePed(4, hash, grannypos.x, grannypos.y, grannypos.z, grannypos.h, true, true)

        
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
	end	
end
end

function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(2)
	end
end

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
                    QBCore.Functions.DrawText3D(grannypos.x, grannypos.y, grannypos.z + 0.5, '[E] - ﺮﺣﺎﺴﻟﺍ ﺓﺪﻋﺎﺴﻣ ﺐﻠﻃ $2,000')
                    DisableControlAction(0, 57, true)
                    if IsDisabledControlJustReleased(0, 54) then

                        QBCore.Functions.Progressbar("check-", "طلب مساعدة الساحر", 5000, false, true, {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        }, {}, {}, {}, function()
                            if prob > 1 then
                             loadAnimDict('missheistdockssetup1clipboard@base')
                             TaskPlayAnim( PlayerPedId(), "missheistdockssetup1clipboard@base", "base", 3.0, 1.0, -1, 49, 0, 0, 0, 0 ) 
                             loadAnimDict(healAnimDict)	
                             TaskPlayAnim(ped, healAnimDict, healAnim, 3.0, 3.0, 8000, 49, 0, 0, 0, 0)
                             QBCore.Functions.Progressbar("check-", "جاري الانعاش", 10000, false, true, {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                             }, {}, {}, {}, function()
                                QBCore.Functions.Notify("You're were treated! ..", "succes")
                                TriggerEvent('hospital:client:Revive')
                                TriggerServerEvent('AbD-monkey:server:Charge')
                                ClearPedTasks(PlayerPedId())
                             end, function() 
                                ClearPedTasks(PlayerPedId())
                            end)
                        else 
                            QBCore.Functions.Notify("Monkey Refused to Help", "error")
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
