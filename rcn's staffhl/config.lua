Config = {}

-- Command Configuration
Config.COMMAND_NAME = "staffhl"
Config.ACE_PERMISSION = "" -- this is the acegroup that will check for staff, so ensure you have this to whatever role you want it to have.

-- Discord Webhook
Config.WEBHOOK_URL = "URLHERE" -- webhook for the main alerts
Config.ABUSE_WEBHOOK_URL = "URLHERE" -- separate webhook for abuse alerts
Config.PING_ROLE_ID = "IDHERE" -- separate disc role ID to ping for abuse (leave inside quotes empty if no ping)

-- Anti Abuse Settings
Config.BLOCK_IN_COMBAT = true
Config.COMBAT_TIMEOUT = 30000 -- ms (30 seconds)
Config.ABUSE_COOLDOWN = 300000 -- milliseconds (5 minutes)
Config.BLOCK_WITH_WEAPON = true -- block if any weapon is held (would leave this on)

-- Highlight Settings (size, colors, etc)
Config.HIGHLIGHT_COLOR = {
    r = 50,
    g = 255,
    b = 50
}

Config.OUTLINE_OPACITY = 255
Config.RENDER_DISTANCE = 5000.0
Config.UPDATE_INTERVAL = 0

-- Box Settings
Config.BOX_BORDER_THICKNESS = 0.002
Config.BOX_ROUNDED_EDGES = false -- leave this as well
Config.BOX_CORNER_RADIUS = 0.1
Config.BOX_FIXED_SIZE = true -- leave this as its set for minimal error
Config.BOX_WIDTH = 0.1
Config.BOX_HEIGHT = 0.22

-- Marker for certain bone joints I set in the client script
Config.BONE_MARKER_SIZE_WIDTH = 0.0025
Config.BONE_MARKER_SIZE_HEIGHT = 0.0025
Config.SHOW_BONE_MARKERS = true -- pure preference

-- Messages in chat
Config.MESSAGES = {
    noPermission = "^1[ERROR]^7 You don't have permission to use this command.",
    invalidUsage = "^3[USAGE]^7 /staffhl [player id] or /staffhl off",
    playerNotFound = "^1[ERROR]^7 Player not found.",
    highlightEnabled = "^2[SUCCESS]^7 Now highlighting player ID: %s",
    highlightDisabled = "^2[SUCCESS]^7 Highlight disabled.",
    executorInCombat = "^1[ERROR]^7 You cannot use this command while in combat.",
    onCooldown = "^1[ERROR]^7 You are on cooldown for abusing this command. Time remaining: %s",
    abuseDetected = "^1[ABUSE DETECTED]^7 Your actions have been logged. You are now locked out for 5 minutes.",
    noclipRequired = "^1[ERROR]^7 You must be in noclip to use staff highlight.",
    noclipExited = "^3[NOCLIP]^7 Staff highlight disabled - you exited noclip."
}