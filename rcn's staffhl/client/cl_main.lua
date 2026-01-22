local trackedServerId = nil
local isTracking = false

local weaponNames = {
    [GetHashKey("WEAPON_PISTOL")] = "Pistol",
    [GetHashKey("WEAPON_COMBATPISTOL")] = "Combat Pistol",
    [GetHashKey("WEAPON_PISTOL50")] = "Pistol .50",
    [GetHashKey("WEAPON_SNSPISTOL")] = "SNS Pistol",
    [GetHashKey("WEAPON_HEAVYPISTOL")] = "Heavy Pistol",
    [GetHashKey("WEAPON_VINTAGEPISTOL")] = "Vintage Pistol",
    [GetHashKey("WEAPON_MARKSMANPISTOL")] = "Marksman Pistol",
    [GetHashKey("WEAPON_REVOLVER")] = "Heavy Revolver",
    [GetHashKey("WEAPON_APPISTOL")] = "AP Pistol",
    [GetHashKey("WEAPON_STUNGUN")] = "Stun Gun",
    [GetHashKey("WEAPON_FLAREGUN")] = "Flare Gun",
    [GetHashKey("WEAPON_DOUBLEACTION")] = "Double Action Revolver",
    [GetHashKey("WEAPON_MICROSMG")] = "Micro SMG",
    [GetHashKey("WEAPON_SMG")] = "SMG",
    [GetHashKey("WEAPON_ASSAULTSMG")] = "Assault SMG",
    [GetHashKey("WEAPON_COMBATPDW")] = "Combat PDW",
    [GetHashKey("WEAPON_MACHINEPISTOL")] = "Machine Pistol",
    [GetHashKey("WEAPON_MINISMG")] = "Mini SMG",
    [GetHashKey("WEAPON_PUMPSHOTGUN")] = "Pump Shotgun",
    [GetHashKey("WEAPON_SAWNOFFSHOTGUN")] = "Sawed-Off Shotgun",
    [GetHashKey("WEAPON_ASSAULTSHOTGUN")] = "Assault Shotgun",
    [GetHashKey("WEAPON_BULLPUPSHOTGUN")] = "Bullpup Shotgun",
    [GetHashKey("WEAPON_MUSKET")] = "Musket",
    [GetHashKey("WEAPON_HEAVYSHOTGUN")] = "Heavy Shotgun",
    [GetHashKey("WEAPON_DBSHOTGUN")] = "Double Barrel Shotgun",
    [GetHashKey("WEAPON_AUTOSHOTGUN")] = "Auto Shotgun",
    [GetHashKey("WEAPON_ASSAULTRIFLE")] = "Assault Rifle",
    [GetHashKey("WEAPON_CARBINERIFLE")] = "Carbine Rifle",
    [GetHashKey("WEAPON_ADVANCEDRIFLE")] = "Advanced Rifle",
    [GetHashKey("WEAPON_SPECIALCARBINE")] = "Special Carbine",
    [GetHashKey("WEAPON_BULLPUPRIFLE")] = "Bullpup Rifle",
    [GetHashKey("WEAPON_COMPACTRIFLE")] = "Compact Rifle",
    [GetHashKey("WEAPON_MG")] = "MG",
    [GetHashKey("WEAPON_COMBATMG")] = "Combat MG",
    [GetHashKey("WEAPON_GUSENBERG")] = "Gusenberg Sweeper",
    [GetHashKey("WEAPON_SNIPERRIFLE")] = "Sniper Rifle",
    [GetHashKey("WEAPON_HEAVYSNIPER")] = "Heavy Sniper",
    [GetHashKey("WEAPON_MARKSMANRIFLE")] = "Marksman Rifle",
    [GetHashKey("WEAPON_RPG")] = "RPG",
    [GetHashKey("WEAPON_GRENADELAUNCHER")] = "Grenade Launcher",
    [GetHashKey("WEAPON_MINIGUN")] = "Minigun",
    [GetHashKey("WEAPON_FIREWORK")] = "Firework Launcher",
    [GetHashKey("WEAPON_RAILGUN")] = "Railgun",
    [GetHashKey("WEAPON_HOMINGLAUNCHER")] = "Homing Launcher",
    [GetHashKey("WEAPON_GRENADE")] = "Grenade",
    [GetHashKey("WEAPON_STICKYBOMB")] = "Sticky Bomb",
    [GetHashKey("WEAPON_PROXMINE")] = "Proximity Mine",
    [GetHashKey("WEAPON_BZGAS")] = "BZ Gas",
    [GetHashKey("WEAPON_MOLOTOV")] = "Molotov",
    [GetHashKey("WEAPON_PETROLCAN")] = "Jerry Can",
    [GetHashKey("WEAPON_KNIFE")] = "Knife",
    [GetHashKey("WEAPON_NIGHTSTICK")] = "Nightstick",
    [GetHashKey("WEAPON_HAMMER")] = "Hammer",
    [GetHashKey("WEAPON_BAT")] = "Baseball Bat",
    [GetHashKey("WEAPON_GOLFCLUB")] = "Golf Club",
    [GetHashKey("WEAPON_CROWBAR")] = "Crowbar",
    [GetHashKey("WEAPON_BOTTLE")] = "Bottle",
    [GetHashKey("WEAPON_DAGGER")] = "Antique Cavalry Dagger",
    [GetHashKey("WEAPON_HATCHET")] = "Hatchet",
    [GetHashKey("WEAPON_KNUCKLE")] = "Brass Knuckles",
    [GetHashKey("WEAPON_MACHETE")] = "Machete",
    [GetHashKey("WEAPON_FLASHLIGHT")] = "Flashlight",
    [GetHashKey("WEAPON_SWITCHBLADE")] = "Switchblade",
    [GetHashKey("WEAPON_POOLCUE")] = "Pool Cue",
    [GetHashKey("WEAPON_WRENCH")] = "Wrench",
    [GetHashKey("WEAPON_BATTLEAXE")] = "Battle Axe",
}

local function isInNoclip()
    local ped = PlayerPedId()
    local isFrozen = IsEntityPositionFrozen(ped)
    local alpha = GetEntityAlpha(ped)
    
    return isFrozen and alpha < 255
end

local function getPlayerFromServerId(serverId)
    local players = GetActivePlayers()
    for _, player in ipairs(players) do
        if GetPlayerServerId(player) == serverId then
            return player
        end
    end
    return nil
end

local function stopTracking()
    trackedServerId = nil
    isTracking = false
end

local function startTracking(targetId)
    stopTracking()
    trackedServerId = targetId
    isTracking = true
    
    TriggerEvent('chat:addMessage', {
        color = {0, 255, 0},
        multiline = false,
        args = {"System", string.format(Config.MESSAGES.highlightEnabled, targetId)}
    })
end

RegisterNetEvent('staffhl:forceStopTracking')
AddEventHandler('staffhl:forceStopTracking', function()
    stopTracking()
end)

local function drawESP(ped)
    if not isTracking then
        return
    end
    
    if Config.SHOW_BONE_MARKERS then
        local bones = {
            0x2E28,
            0xCA72,
            0xE39F,
            0xB3FE,
            0x3FCF,
            0x60F2,
            0x58B7,
            0xBB0,
            0x8CBD,
            0x188E,
            0x9995,
            0x29D2,
            0xFCD9,
            0xB987
        }
        
        for _, bone in ipairs(bones) do
            local boneCoords = GetPedBoneCoords(ped, bone, 0.0, 0.0, 0.0)
            local onScreen, screenX, screenY = GetScreenCoordFromWorldCoord(boneCoords.x, boneCoords.y, boneCoords.z)
            
            if onScreen then
                DrawRect(screenX, screenY, Config.BONE_MARKER_SIZE_WIDTH, Config.BONE_MARKER_SIZE_HEIGHT, 
                    Config.HIGHLIGHT_COLOR.r, 
                    Config.HIGHLIGHT_COLOR.g, 
                    Config.HIGHLIGHT_COLOR.b, 
                    255)
            end
        end
    end
    
    local pedCoords = GetEntityCoords(ped)
    local headCoords = GetPedBoneCoords(ped, 0x796E, 0.0, 0.0, 0.0)
    local feetCoords = vector3(pedCoords.x, pedCoords.y, pedCoords.z - 1.0)
    
    local onScreenHead, screenXHead, screenYHead = GetScreenCoordFromWorldCoord(headCoords.x, headCoords.y, headCoords.z)
    local onScreenFeet, screenXFeet, screenYFeet = GetScreenCoordFromWorldCoord(feetCoords.x, feetCoords.y, feetCoords.z)
    
    if not onScreenHead or not onScreenFeet then
        return
    end
    
    local screenX = (screenXHead + screenXFeet) / 2
    local screenY = (screenYHead + screenYFeet) / 2
    local width, height
    
    if Config.BOX_FIXED_SIZE then
        height = math.abs(screenYFeet - screenYHead)
        width = height * 0.5
        
        local maxHeight = Config.BOX_HEIGHT
        local maxWidth = Config.BOX_WIDTH
        
        if height > maxHeight then
            height = maxHeight
            width = maxWidth
        end
    else
        height = math.abs(screenYFeet - screenYHead)
        width = height * 0.5
    end
    
    if Config.BOX_ROUNDED_EDGES then
        local cornerLen = math.min(width * 0.3, height * 0.3)
        
        DrawRect(screenX - width/2 + cornerLen/2, screenY - height/2, cornerLen, Config.BOX_BORDER_THICKNESS, 
            Config.HIGHLIGHT_COLOR.r, Config.HIGHLIGHT_COLOR.g, Config.HIGHLIGHT_COLOR.b, 255)
        DrawRect(screenX - width/2, screenY - height/2 + cornerLen/2, Config.BOX_BORDER_THICKNESS, cornerLen, 
            Config.HIGHLIGHT_COLOR.r, Config.HIGHLIGHT_COLOR.g, Config.HIGHLIGHT_COLOR.b, 255)
        
        DrawRect(screenX + width/2 - cornerLen/2, screenY - height/2, cornerLen, Config.BOX_BORDER_THICKNESS, 
            Config.HIGHLIGHT_COLOR.r, Config.HIGHLIGHT_COLOR.g, Config.HIGHLIGHT_COLOR.b, 255)
        DrawRect(screenX + width/2, screenY - height/2 + cornerLen/2, Config.BOX_BORDER_THICKNESS, cornerLen, 
            Config.HIGHLIGHT_COLOR.r, Config.HIGHLIGHT_COLOR.g, Config.HIGHLIGHT_COLOR.b, 255)
        
        DrawRect(screenX - width/2 + cornerLen/2, screenY + height/2, cornerLen, Config.BOX_BORDER_THICKNESS, 
            Config.HIGHLIGHT_COLOR.r, Config.HIGHLIGHT_COLOR.g, Config.HIGHLIGHT_COLOR.b, 255)
        DrawRect(screenX - width/2, screenY + height/2 - cornerLen/2, Config.BOX_BORDER_THICKNESS, cornerLen, 
            Config.HIGHLIGHT_COLOR.r, Config.HIGHLIGHT_COLOR.g, Config.HIGHLIGHT_COLOR.b, 255)
        
        DrawRect(screenX + width/2 - cornerLen/2, screenY + height/2, cornerLen, Config.BOX_BORDER_THICKNESS, 
            Config.HIGHLIGHT_COLOR.r, Config.HIGHLIGHT_COLOR.g, Config.HIGHLIGHT_COLOR.b, 255)
        DrawRect(screenX + width/2, screenY + height/2 - cornerLen/2, Config.BOX_BORDER_THICKNESS, cornerLen, 
            Config.HIGHLIGHT_COLOR.r, Config.HIGHLIGHT_COLOR.g, Config.HIGHLIGHT_COLOR.b, 255)
    else
        DrawRect(screenX, screenY - height/2, width, Config.BOX_BORDER_THICKNESS, 
            Config.HIGHLIGHT_COLOR.r, Config.HIGHLIGHT_COLOR.g, Config.HIGHLIGHT_COLOR.b, 255)
        DrawRect(screenX, screenY + height/2, width, Config.BOX_BORDER_THICKNESS, 
            Config.HIGHLIGHT_COLOR.r, Config.HIGHLIGHT_COLOR.g, Config.HIGHLIGHT_COLOR.b, 255)
        DrawRect(screenX - width/2, screenY, Config.BOX_BORDER_THICKNESS, height, 
            Config.HIGHLIGHT_COLOR.r, Config.HIGHLIGHT_COLOR.g, Config.HIGHLIGHT_COLOR.b, 255)
        DrawRect(screenX + width/2, screenY, Config.BOX_BORDER_THICKNESS, height, 
            Config.HIGHLIGHT_COLOR.r, Config.HIGHLIGHT_COLOR.g, Config.HIGHLIGHT_COLOR.b, 255)
    end
end

RegisterNetEvent('staffhl:toggleTracking')
AddEventHandler('staffhl:toggleTracking', function(targetId)
    if targetId == nil then
        stopTracking()
        TriggerEvent('chat:addMessage', {
            color = {0, 255, 0},
            multiline = false,
            args = {"System", Config.MESSAGES.highlightDisabled}
        })
    else
        if not isInNoclip() then
            TriggerEvent('chat:addMessage', {
                color = {255, 0, 0},
                multiline = false,
                args = {"System", Config.MESSAGES.noclipRequired}
            })
            return
        end
        startTracking(targetId)
    end
end)

-- Main rendering thread
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        if isTracking and trackedServerId then
            -- Check if still in noclip
            if not isInNoclip() then
                stopTracking()
                TriggerEvent('chat:addMessage', {
                    color = {255, 165, 0},
                    multiline = false,
                    args = {"System", Config.MESSAGES.noclipExited}
                })
            else
                local targetPlayer = getPlayerFromServerId(trackedServerId)
                
                if targetPlayer then
                    local targetPed = GetPlayerPed(targetPlayer)
                    
                    if targetPed and DoesEntityExist(targetPed) then
                        local myPed = PlayerPedId()
                        local myCoords = GetEntityCoords(myPed)
                        local targetCoords = GetEntityCoords(targetPed)
                        local distance = #(myCoords - targetCoords)
                        
                        if distance <= Config.RENDER_DISTANCE then
                            drawESP(targetPed)
                        end
                    else
                        stopTracking()
                    end
                else
                    stopTracking()
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/' .. Config.COMMAND_NAME, 'Toggle player highlighting.', {
        {name = "id/off", help = "Player ID to highlight or 'off' to disable"}
    })
end)

if Config.BLOCK_IN_COMBAT or Config.BLOCK_WITH_WEAPON then
    Citizen.CreateThread(function()
        local wasInCombat = false
        local hadWeapon = false
        
        while true do
            Citizen.Wait(1000)
            
            local ped = PlayerPedId()
            local inCombat = false
            local hasWeapon = false
            local weaponName = "None"
            local currentWeapon = GetSelectedPedWeapon(ped)
            
            if Config.BLOCK_IN_COMBAT then
                local unarmedHit = false
                
                if currentWeapon == GetHashKey("WEAPON_UNARMED") then
                    if IsPedInMeleeCombat(ped) then
                        local target = GetMeleeTargetForPed(ped)
                        if target and target ~= 0 then
                            unarmedHit = true
                        end
                    end
                end
                
                local isFireExtinguisher = currentWeapon == 0x060EC506
                local isShooting = IsPedShooting(ped) and not isFireExtinguisher
                
                inCombat = isShooting or unarmedHit
            end
            
            if Config.BLOCK_WITH_WEAPON then
                local isUnarmed = currentWeapon == GetHashKey("WEAPON_UNARMED")
                local isFireExtinguisher = currentWeapon == 0x060EC506
                
                if not isUnarmed and not isFireExtinguisher then
                    hasWeapon = true
                    weaponName = weaponNames[currentWeapon] or string.format("Unknown Weapon (0x%08X)", currentWeapon)
                end
            end
            
            local statusChanged = (inCombat ~= wasInCombat) or (hasWeapon ~= hadWeapon)
            
            if statusChanged then
                wasInCombat = inCombat
                hadWeapon = hasWeapon
                TriggerServerEvent('staffhl:updateCombatStatus', inCombat, hasWeapon, weaponName)
            end
            
            if isTracking and (inCombat or hasWeapon) then
                TriggerServerEvent('staffhl:combatViolation', trackedServerId, weaponName)
            end
        end
    end)
end