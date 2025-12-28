--[[
    https://github.com/kxiox/ks_bossmenu

    This file is licensed under GPL-3.0 or higher <https://www.gnu.org/licenses/gpl-3.0.en.html>

    Copyright © 2025 Kxiox <https://github.com/kxiox>
]]

ESX = exports['es_extended']:getSharedObject()


local targetZones = {}

AddEventHandler('esx:playerLoaded', function(playerData)
    ESX.PlayerData = playerData
end)

Citizen.CreateThread(function()
    while not ESX.PlayerLoaded do
        Citizen.Wait(100)
    end

    Wait(3000)

    setLocale()
    setTimestampFormat()

    if Config.UseTarget and GetResourceState('ox_target') == 'started' then
        for jobName, jobConfig in pairs(Config.Jobs) do
            -- Check if coords is a table with multiple locations or single location
            local markerCoords = jobConfig.marker.coords
            
            if type(markerCoords) == 'table' and markerCoords[1] then
                -- Multiple locations
                for index, coords in pairs(markerCoords) do
                    targetZones[jobName .. '_' .. index] = exports.ox_target:addBoxZone({
                        coords = vec3(coords.x, coords.y, coords.z),
                        size = vec3(2, 2, 2),
                        rotation = 0,
                        debug = false,
                        options = {
                            {
                                name = 'bossmenu:' .. jobName .. '_' .. index,
                                event = 'ks_bossmenu:openMenu',
                                icon = 'fa-solid fa-briefcase', 
                                label = TranslateCap('ox_target'),
                                canInteract = function()
                                    return ESX.PlayerData.job.name == jobName and TableContains(jobConfig.grades, ESX.PlayerData.job.grade)
                                end,
                                distance = 2
                            }
                        }
                    })
                end
            else
                -- Single location
                targetZones[jobName] = exports.ox_target:addBoxZone({
                    coords = vec3(markerCoords.x, markerCoords.y, markerCoords.z),
                    size = vec3(2, 2, 2),
                    rotation = 0,
                    debug = false,
                    options = {
                        {
                            name = 'bossmenu:' .. jobName,
                            event = 'ks_bossmenu:openMenu',
                            icon = 'fa-solid fa-briefcase', 
                            label = TranslateCap('ox_target'),
                            canInteract = function()
                                return ESX.PlayerData.job.name == jobName and TableContains(jobConfig.grades, ESX.PlayerData.job.grade)
                            end,
                            distance = 2
                        }
                    }
                })
            end
        end
    else
        while true do
            local sleep = 3000
            
            for k, v in pairs(Config.Jobs) do
                if ESX.PlayerData.job and ESX.PlayerData.job.name then
                    if ESX.PlayerData.job.name == k and TableContains(v.grades, ESX.PlayerData.job.grade) then
                        local coords = GetEntityCoords(PlayerPedId())
                        local markerCoords = v.marker.coords
                        
                        -- Check if coords is a table with multiple locations or single location
                        local coordsTable = {}
                        if type(markerCoords) == 'table' and markerCoords[1] then
                            coordsTable = markerCoords
                        else
                            coordsTable = {markerCoords}
                        end
                        
                        -- Loop through all coordinates
                        for index, markerPos in pairs(coordsTable) do
                            local distance = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, markerPos.x, markerPos.y, markerPos.z, true)

                            if distance < 20.0 then
                                sleep = 1
                                local zOffset = v.marker.type == 21 and 0.0 or -1.0
                                local marker = lib.marker.new({
                                    type = v.marker.type,
                                    coords = markerPos,
                                    height = v.marker.scale.z + zOffset,
                                    width = v.marker.scale.x,
                                    color = { r = v.marker.color.r, g = v.marker.color.g, b = v.marker.color.b, a = v.marker.color.a },
                                })

                                marker:draw()
                                if distance < (v.marker.distance or 1.5) then
                                    ESX.ShowHelpNotification(TranslateCap('help_notification'))
                                    if IsControlJustReleased(0, 38) then
                                        TriggerEvent('ks_bossmenu:openMenu')
                                    end
                                end
                            end
                        end
                    end
                else
                    break
                end
            end

            Wait(sleep)
        end
    end
end)

RegisterNetEvent('ks_bossmenu:openMenu', function()
    local jobName = ESX.PlayerData.job.name
    local jobConfig = Config.Jobs[jobName]
    
    if jobConfig and TableContains(jobConfig.grades, ESX.PlayerData.job.grade) then
        openNUI({
            color = jobConfig.color,
            logo = jobConfig.logo
        })
    end
end)

-- This section checks the player's grade.
function TableContains(tbl, val)
    for _, v in ipairs(tbl) do
        if v == val then
            return true
        end
    end
    return false
end

if Config.EnableCommand then
    RegisterCommand(Config.CommandName, function()
        local jobName = ESX.PlayerData.job.name
        local jobConfig = Config.Jobs[jobName]

        if jobConfig and TableContains(jobConfig.grades, ESX.PlayerData.job.grade) then
            TriggerEvent('ks_bossmenu:openMenu')
        end
    end, false)
end