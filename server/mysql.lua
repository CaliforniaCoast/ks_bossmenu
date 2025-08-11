
CreateThread(function()
    local queries = {
        [[CREATE TABLE IF NOT EXISTS `ks_bossmenu_actions` (
            `id` int(11) NOT NULL AUTO_INCREMENT,
            `action` text DEFAULT NULL,
            `employee` text DEFAULT NULL,
            `time` varchar(10) DEFAULT NULL,
            `data` longtext DEFAULT NULL,
            `job` text DEFAULT NULL,
            PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;]],
        [[CREATE TABLE IF NOT EXISTS `ks_bossmenu_bonus_queue` (
            `id` int(11) NOT NULL AUTO_INCREMENT,
            `identifier` varchar(46) NOT NULL,
            `amount` int(11) NOT NULL DEFAULT 0,
            `job` varchar(50) NOT NULL,
            PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;]],
        [[CREATE TABLE IF NOT EXISTS `ks_bossmenu_transactions` (
            `id` int(11) NOT NULL AUTO_INCREMENT,
            `action` text DEFAULT NULL,
            `employee` text DEFAULT NULL,
            `amount` int(11) DEFAULT NULL,
            `time` varchar(10) DEFAULT NULL,
            `job` text DEFAULT NULL,
            PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;]]
    }
    for _, query in ipairs(queries) do
        MySQL.insert.await(query)
    end

    Wait(1000)

    for k, v in pairs(Config.Jobs) do
        local result = MySQL.query.await('SELECT * FROM addon_account_data WHERE account_name = ?', {v.society or 'society_' .. k})
        
        if #result == 0 then
            MySQL.insert('INSERT INTO addon_account_data (account_name, money) VALUES (?, ?)', {v.society or 'society_' .. k, 0})
            print(('[ks_bossmenu] Society account for %s created.'):format(v.society or 'society_' .. k))
        end
    end
end)