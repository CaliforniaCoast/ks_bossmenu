--[[
    [https://github.com/kxiox/ks_bossmenu](https://github.com/kxiox/ks_bossmenu)
    This file is licensed under GPL-3.0 or higher <https://www.gnu.org/licenses/gpl-3.0.en.html>
    Copyright © 2025 Kxiox <https://github.com/kxiox>
]]

Config = {}

Config.Locale = 'de'

Config.Currency = '$'

Config.Timestamp = 'us'

Config.UnemployedJobName = 'unemployed'

Config.UseTarget = false        -- Use ox_target for the boss menu (resource name: ox_target)

Config.UseJobsCreator = true    -- only for jaksam's jobcreator (resource name: jobs_creator)

Config.EnableCommand = true     -- Enable the command to open the boss menu | NEW
Config.CommandName = 'bossmenu' -- The name of the command | NEW

Config.Jobs = {
    ['police'] = {
        society = nil,
        logo = 'police.png',
        color = 'blue',
        grades = { 15, 14, 13, 12, 11 },
        marker = {
            type = 21,
            coords = vector3(-1108.64, -836.68, 34.28),
            scale = vector3(0.3, 0.3, 0.2),
            color = { r = 0, g = 0, b = 255, a = 200 },
        },
    },
}

Config.Menus = { -- (de-/activate menu features)
    employees = {
        enabled = true
    },

    salaries = {
        enabled = true,
        maximum = 5000, -- maximum salary change (nil = no limit; integer value)
    },

    account = {
        enabled = true
    },

    bonus = {
        enabled = true,
        maximum = nil, -- maximum bonus amount (nil = no limit; integer value)
    }
}
