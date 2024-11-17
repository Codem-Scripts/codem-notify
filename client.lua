local PlayerData = {}
local playerLoaded = false
ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)


local notif = {}
local show3DText = false

exports("addNotif", function(button, text, maxDistance, pressDistance, coord, car, job, duty, boss, grade)
    print(coord)
	table.insert(notif, {button = button, text = text, maxDistance = maxDistance, pressDistance = pressDistance, car = car, coord = coord, job = job, duty = duty, boss = boss, grade = grade})
end)


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = ESX.GetPlayerData()
    playerLoaded = true
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob",function(job)
    PlayerData.job = job
end)


Citizen.CreateThread(function()


    while true do
        local time = 800
      	 if ESX then

            local playerPed = PlayerPedId()
            local coord = GetEntityCoords(playerPed)
            if PlayerData.job == nil then PlayerData = ESX.GetPlayerData() end

            local found = false
            local text = ""
			local button = ""
            for i=1, #notif do
				local distance = #(vector3(notif[i].coord.x, notif[i].coord.y, notif[i].coord.z) - coord)
				
                local distanceCheck = distance < notif[i].maxDistance
                if distanceCheck and distance < 20 then

                    local job = true
                    local grade = true
                    local duty = true
                    local car = true
                    local boss = true
                    if notif[i].job then if notif[i].job ~= PlayerData.job.name then job = false end end
                    if notif[i].grade then if notif[i].grade < PlayerData.job.grade then grade = false end end
                    -- if notif[i].duty then duty = PlayerData.job.onduty end
                    if notif[i].car then car = IsPedInAnyVehicle(playerPed) end
                    if notif[i].boss then boss = PlayerData.job.boss end

                    if job and grade and duty and car and boss then
                        if distanceCheck then
                            text = notif[i].text .." ("..math.floor(distance)..")"
                            found = true
                            if distance < notif[i].pressDistance then
                                text =  notif[i].text 
								button = notif[i].button
                            end
                    
                        end
                    end

                end
            end

            if text ~= lastText then
                if found then
					print('draw')
                    SendNUIMessage({action = "draw", text = text, button = button})
                else
                    SendNUIMessage({action = "stopDraw"})
                end

            end
            lastText = text
      	 end
        Citizen.Wait(time)
    end
end)