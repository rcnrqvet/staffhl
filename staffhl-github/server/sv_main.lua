local function hasPermission(source)
    if Config.ACE_PERMISSION == "" then
        return true
    end
    
    local identifiers = GetPlayerIdentifiers(source)
    for _, identifier in ipairs(identifiers) do
        if IsPrincipalAceAllowed(identifier, Config.ACE_PERMISSION) then
            return true
        end
    end
    return false
end

local function getPlayerIdentifiers(source)
    local identifiers = {
        steam = "N/A",
        license = "N/A",
        discord = "N/A",
        fivem = "N/A"
    }
    
    for _, id in ipairs(GetPlayerIdentifiers(source)) do
        if string.match(id, "steam:") then
            identifiers.steam = id
        elseif string.match(id, "license:") then
            identifiers.license = id
        elseif string.match(id, "discord:") then
            identifiers.discord = id
        elseif string.match(id, "fivem:") then
            identifiers.fivem = id
        end
    end
    
    return identifiers
end

local function sendWebhook(executor, executorIds, target, targetIds, coords, action)
    if Config.WEBHOOK_URL == "" or Config.WEBHOOK_URL == "YOUR_DISCORD_WEBHOOK_URL_HERE" then
        return
    end
    
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    local location = string.format("X: %.2f, Y: %.2f, Z: %.2f", coords.x, coords.y, coords.z)
    
    local embed = {
        {
            ["title"] = "Staff Highlight Usage",
            ["description"] = string.format("**%s** has ran staff highlight on **%s**", executor, target),
            ["color"] = 15158332,
            ["fields"] = {
                {
                    ["name"] = "Action",
                    ["value"] = action,
                    ["inline"] = true
                },
                {
                    ["name"] = "Time & Date",
                    ["value"] = timestamp,
                    ["inline"] = true
                },
                {
                    ["name"] = "Location",
                    ["value"] = location,
                    ["inline"] = false
                },
                {
                    ["name"] = "Executor Identifiers",
                    ["value"] = string.format(
                        "**Steam:** %s\n**License:** %s\n**Discord:** %s\n**FiveM:** %s",
                        executorIds.steam,
                        executorIds.license,
                        executorIds.discord,
                        executorIds.fivem
                    ),
                    ["inline"] = true
                },
                {
                    ["name"] = "Target Identifiers",
                    ["value"] = string.format(
                        "**Steam:** %s\n**License:** %s\n**Discord:** %s\n**FiveM:** %s",
                        targetIds.steam,
                        targetIds.license,
                        targetIds.discord,
                        targetIds.fivem
                    ),
                    ["inline"] = true
                }
            },
            ["footer"] = {
                ["text"] = "Staff Highlight System"
            },
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }
    }
    
    PerformHttpRequest(Config.WEBHOOK_URL, function(err, text, headers) end, 'POST', json.encode({
        username = "Staff Logs",
        embeds = embed
    }), {['Content-Type'] = 'application/json'})
end

local function sendAbuseWebhook(executor, executorIds, target, targetIds, coords, weaponName)
    if Config.ABUSE_WEBHOOK_URL == "" or Config.ABUSE_WEBHOOK_URL == "YOUR_ABUSE_WEBHOOK_URL_HERE" then
        return
    end
    
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    local location = string.format("X: %.2f, Y: %.2f, Z: %.2f", coords.x, coords.y, coords.z)
    
    local content = ""
    if Config.PING_ROLE_ID ~= "" and Config.PING_ROLE_ID ~= "YOUR_ROLE_ID_HERE" then
        content = string.format("<@&%s>", Config.PING_ROLE_ID)
    end
    
    local embed = {
        {
            ["title"] = "⚠️ COMMAND ABUSE DETECTED! ⚠️",
            ["description"] = string.format("**%s** attempted to abuse staff highlight while in combat/armed!", executor),
            ["color"] = 16711680,
            ["fields"] = {
                {
                    ["name"] = "Violation Type",
                    ["value"] = "Used staff highlight while in combat or holding weapon",
                    ["inline"] = false
                },
                {
                    ["name"] = "Weapon Used",
                    ["value"] = weaponName or "Unknown",
                    ["inline"] = true
                },
                {
                    ["name"] = "Cooldown Applied",
                    ["value"] = "5 minutes",
                    ["inline"] = true
                },
                {
                    ["name"] = "Time & Date",
                    ["value"] = timestamp,
                    ["inline"] = false
                },
                {
                    ["name"] = "Location",
                    ["value"] = location,
                    ["inline"] = false
                },
                {
                    ["name"] = "Executor Identifiers",
                    ["value"] = string.format(
                        "**Steam:** %s\n**License:** %s\n**Discord:** %s\n**FiveM:** %s",
                        executorIds.steam,
                        executorIds.license,
                        executorIds.discord,
                        executorIds.fivem
                    ),
                    ["inline"] = false
                }
            },
            ["footer"] = {
                ["text"] = "Staff Abuse Detection System"
            },
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }
    }
    
    PerformHttpRequest(Config.ABUSE_WEBHOOK_URL, function(err, text, headers) end, 'POST', json.encode({
        username = "Staff Abuse Alert",
        content = content,
        embeds = embed
    }), {['Content-Type'] = 'application/json'})
end

local playerCombatStatus = {}
local playerCooldowns = {}

RegisterNetEvent('staffhl:updateCombatStatus')
AddEventHandler('staffhl:updateCombatStatus', function(inCombat, hasWeapon, weaponName)
    playerCombatStatus[source] = {
        inCombat = inCombat,
        hasWeapon = hasWeapon,
        weaponName = weaponName or "None",
        timestamp = os.time()
    }
end)

RegisterNetEvent('staffhl:combatViolation')
AddEventHandler('staffhl:combatViolation', function(targetId, weaponName)
    local source = source
    
    if playerCooldowns[source] then
        return
    end
    
    playerCooldowns[source] = os.time() + (Config.ABUSE_COOLDOWN / 1000)
    
    TriggerClientEvent('staffhl:forceStopTracking', source)
    
    TriggerClientEvent('chat:addMessage', source, {
        color = {255, 0, 0},
        multiline = false,
        args = {"System", Config.MESSAGES.abuseDetected}
    })
    
    local executorName = GetPlayerName(source)
    local targetName = GetPlayerName(targetId) or "Unknown"
    local executorIds = getPlayerIdentifiers(source)
    local targetIds = getPlayerIdentifiers(targetId)
    local executorCoords = GetEntityCoords(GetPlayerPed(source))
    
    sendAbuseWebhook(executorName, executorIds, targetName, targetIds, executorCoords, weaponName or "Unknown")
end)

local function isPlayerInCombat(source)
    if not Config.BLOCK_IN_COMBAT and not Config.BLOCK_WITH_WEAPON then
        return false
    end
    
    local status = playerCombatStatus[source]
    if status then
        local timeDiff = os.time() - status.timestamp
        if timeDiff < (Config.COMBAT_TIMEOUT / 1000) then
            if Config.BLOCK_IN_COMBAT and status.inCombat then
                return true
            end
            if Config.BLOCK_WITH_WEAPON and status.hasWeapon then
                return true
            end
        end
    end
    
    return false
end

local function isPlayerOnCooldown(source)
    if playerCooldowns[source] then
        local currentTime = os.time()
        if currentTime < playerCooldowns[source] then
            return true, playerCooldowns[source] - currentTime
        else
            playerCooldowns[source] = nil
        end
    end
    return false, 0
end

local function formatTime(seconds)
    local minutes = math.floor(seconds / 60)
    local secs = seconds % 60
    return string.format("%d:%02d", minutes, secs)
end

RegisterCommand(Config.COMMAND_NAME, function(source, args, rawCommand)
    if not hasPermission(source) then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            multiline = false,
            args = {"System", Config.MESSAGES.noPermission}
        })
        return
    end
    
    local onCooldown, timeLeft = isPlayerOnCooldown(source)
    if onCooldown then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            multiline = false,
            args = {"System", string.format(Config.MESSAGES.onCooldown, formatTime(timeLeft))}
        })
        return
    end
    
    if #args < 1 then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 165, 0},
            multiline = false,
            args = {"System", Config.MESSAGES.invalidUsage}
        })
        return
    end
    
    local targetArg = args[1]
    
    if targetArg == "off" then
        TriggerClientEvent('staffhl:toggleTracking', source, nil)
        return
    end
    
    local targetId = tonumber(targetArg)
    
    if not targetId then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 165, 0},
            multiline = false,
            args = {"System", Config.MESSAGES.invalidUsage}
        })
        return
    end
    
    local targetPlayer = GetPlayerName(targetId)
    
    if not targetPlayer then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            multiline = false,
            args = {"System", Config.MESSAGES.playerNotFound}
        })
        return
    end
    
    if isPlayerInCombat(source) then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            multiline = false,
            args = {"System", Config.MESSAGES.executorInCombat}
        })
        return
    end
    
    local executorName = GetPlayerName(source)
    local executorIds = getPlayerIdentifiers(source)
    local targetIds = getPlayerIdentifiers(targetId)
    local executorCoords = GetEntityCoords(GetPlayerPed(source))
    
    sendWebhook(
        executorName,
        executorIds,
        targetPlayer,
        targetIds,
        executorCoords,
        "Enabled"
    )
    
    TriggerClientEvent('staffhl:toggleTracking', source, targetId)
end, false)