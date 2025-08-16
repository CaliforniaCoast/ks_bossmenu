--[[
    https://github.com/kxiox/ks_bossmenu

    This file is licensed under GPL-3.0 or higher <https://www.gnu.org/licenses/gpl-3.0.en.html>

    Copyright © 2025 Kxiox <https://github.com/kxiox>
]]

ESX = exports['es_extended']:getSharedObject()

local targetZones = {}

Citizen.CreateThread(function()
    while not ESX.IsPlayerLoaded() do
        Citizen.Wait(100)
    end

    Wait(3000)

    setLocale()
    setTimestampFormat()

    --In this section we create zones for jobs
    for jobName, jobConfig in pairs(Config.Jobs) do
        targetZones[jobName] = exports.ox_target:addBoxZone({
            coords = vec3(jobConfig.marker.coords.x, jobConfig.marker.coords.y, jobConfig.marker.coords.z),
            size = vec3(2, 2, 2),
            rotation = 0,
            debug = false,
            options = {
                {
                    name = 'bossmenu:' .. jobName,
                    event = 'ks_bossmenu:openMenu',
                    icon = 'fa-solid fa-briefcase', 
                    label = 'Upravljanje firmom', --This is in my language, you can translate it to yours.
                    canInteract = function()
                        return ESX.PlayerData.job.name == jobName and tableContains(jobConfig.grades, ESX.PlayerData.job.grade)
                    end,
                    distance = 2
                }
            }
        })
    end
end)

-- This is the function to open the menu.
RegisterNetEvent('ks_bossmenu:openMenu', function()
    local jobName = ESX.PlayerData.job.name
    local jobConfig = Config.Jobs[jobName]
    
    if jobConfig and tableContains(jobConfig.grades, ESX.PlayerData.job.grade) then
        openNUI({
            color = jobConfig.color,
            logo = jobConfig.logo
        })
    end
end)

-- This section checks the player's grade.
function tableContains(tbl, val)
    for _, v in ipairs(tbl) do
        if v == val then
            return true
        end
    end
    return false
end
