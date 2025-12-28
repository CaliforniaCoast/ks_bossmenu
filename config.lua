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

Config.UseTarget = false -- Use ox_target for the boss menu (resource name: ox_target)

Config.UseJobsCreator = true -- only for jaksam's jobcreator (resource name: jobs_creator)

Config.EnableCommand = false -- Enable the command to open the boss menu | NEW
Config.CommandName = 'bossmenu' -- The name of the command | NEW

Config.Jobs = {
    ['police'] = {
        society = nil,
        logo = 'police.png',
        color = 'blue',
        grades = { 15, 14, 13, 12, 11 },
        marker = {
          type = 21,
          coords = {
              [1] = vector3(-1112.9050, -832.8082, 34.2746), -- Commissioner
              [2] = vector3(-1108.8309, -836.6359, 34.2746), -- Chief
              [3] = vector3(-1099.8680, -828.0886, 34.2746), -- Assistant Chief
              [4] = vector3(-1110.3569, -837.0478, 27.0646), -- SWAT Commander
              [5] = vector3(-1083.3439, -825.6691, 27.0646), -- King Commander
              [6] = vector3(-1092.6039, -822.8129, 22.7933), -- Patrol Commander
              [7] = vector3(-1079.5250, -830.5902, 27.0646) -- Deputy Chief
          },
          scale = vector3(0.3, 0.3, 0.2),
          color = { r = 0, g = 0, b = 255, a = 200 },
        },
    },
    ['ambulance'] = {
        society = nil,
        logo = 'ambulance.png',
        color = 'light',
        grades = { 9, 8, 7 },
        marker = {
          type = 21,
          coords = {
            [1] = vector3(334.8571, -593.4908, 43.2840),
          },
          scale = vector3(0.3, 0.3, 0.2),
          color = { r = 255, g = 255, b = 255, a = 100 },
        },
    },
    ['mechanic'] = {
        society = nil,
        logo = 'firefly.png',
        color = 'orange',
        grades = { 11, 10, 9 },
        marker = {
          type = 21,
          coords = {
            [1] = vector3(-3063.7825, 457.6273, 11.7987),
          },
          scale = vector3(0.3, 0.3, 0.2),
          color = { r = 255, g = 0, b = 0, a = 200 },
        },
    },
    ['og'] = {
        society = nil,
        logo = 'og.jpg',
        color = 'purple',
        grades = { 12, 11, 10},
        marker = {
          type = 21,
          coords = {
            [1] = vector3(3319.1069, 5199.4150, 23.2871),
          },
          scale = vector3(0.3, 0.3, 0.2),
          color = { r = 102, g = 0, b = 255, a = 200 },
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
