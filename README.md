# 🚨 Staff Highlight System - staffhl

Staff Highlight is a moderation tool for FiveM that lets staff visually highlight and track players while in noclip. It is made for investigations and monitoring, with built in anti abuse protection and full Discord logging.

---

## ✨ Features

1. Highlight and track any player while in noclip  
2. 2D box ESP with optional bone markers  
3. Distance based rendering  
4. Automatically disables when noclip is exited  
5. Anti abuse protection system  
6. Combat blocking  
7. Weapon blocking  
8. Cooldown system if abused  
9. Discord webhook logging  
10. Separate abuse alerts with optional role ping  
11. ACE permission support  
12. Fully configurable visuals and limits  

---

## 📦 Installation

1. Download the latest version of **staffhl** by clicking on *releases*, then the latest one.

2. Drag folder into your resource folder in your server.

3. Add this to your server.cfg:

   `ensure staffhl`

4. Open config.lua and configure the script. (See Below)

---

## ⚙️ Configuration

All of the settings are inside of config.lua.

### Commands and permissions

`Config.COMMAND_NAME = "staffhl"`  
`Config.ACE_PERMISSION = "group.admin"`

*If ACE_PERMISSION is empty, everyone can use the command.*

**Example ACE setup**

`add_ace group.admin staffhl allow`

---

### Discord webhooks

`Config.WEBHOOK_URL = "URLHERE"` - *When staffhl is ran, it will show the requester & target of that event*
`Config.ABUSE_WEBHOOK_URL = "URLHERE"` - *If abuse is detected (from pulling a weapon out whilst staffhl is active), it will send a embed with every detail from that event.*
`Config.PING_ROLE_ID = "ROLEID"` - *Role to ping if abuse is detected (LEAVE BLANK FOR NO PING)*

---

### Anti abuse protection

`Config.BLOCK_IN_COMBAT = true` - *Prevents use while in combat*
`Config.BLOCK_WITH_WEAPON = true` - *Prevents use while holding a weapon*
`Config.COMBAT_TIMEOUT = 30000` - *30 sec timeout if combat detected*
`Config.ABUSE_COOLDOWN = 300000` - *5 minute cooldown if abused*

---

### Highlight settings

`Config.HIGHLIGHT_COLOR = { r = 50, g = 255, b = 50 }`  - *Includes box ESP, Fixed or dynamic size boxes, and Optional rounded corners (would leave corners off until fixed is made)*
`Config.RENDER_DISTANCE = 5000.0` - *Render Distance until ESP unloads.*
`Config.SHOW_BONE_MARKERS = true` - *Optional bone markers*

---

## 🎮 Commands

`/staffhl [player_id]`  
`/staffhl [off]`

Examples  

`/staffhl 12`  
`/staffhl off`

**You must be in noclip to enable highlighting!**

*Highlighting will automatically disable if:*

- You exit noclip
- You enter combat
- You pull out a weapon
- The target disconnects

---

## 📡 Discord logging

The script logs:

- Who used staff highlight
- Who was targeted
- Time and date
- World position
- Full identifiers including Steam, license, Discord, and FiveM

*Abuse attempts are sent to a separate webhook and can optionally ping a Discord role.*

---

## 🔐 Permissions

**This script uses FiveM ACE permissions.**

Example  

`add_ace group.admin staffhl allow`  
`add_principal identifier.discord:XXXXXXXX group.admin` - *or any identifer*

---

## 🧠 Intended use

Player investigations  
Noclip moderation  
Cheater observation  
Event staff monitoring  

**This system is not intended for combat or gameplay advantage (you may tweak it for those purposes on your own).**

---

## 📄 License

This resource is released under a custom license.

- Free to use and modify.
- Allowed for private and commercial servers.
- May not be resold.
- May not be reuploaded as your own.
- May not remove credits.

See the [LICENSE](https://github.com/rcnrqvet/staffhl/blob/main/LICENSE) file for full terms.

---

## 👤 Author

[rcnrqvet](https://github.com/rcnrqvet)
-
[Staff Highlight System for FiveM](https://github.com/rcnrqvet/staffhl)

---

###  If you enjoy, feel free to leave a star! ⭐
