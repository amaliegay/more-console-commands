# More Console Commands by JosephMcKean

More Console Commands is a collection of commonly used console commands via [UI Expansion](https://www.nexusmods.com/morrowind/mods/46071) Lua console for Morrowind.

For basic help, type the command line: help

## Requirements

To get access to Lua console, 
- First you'll need MWSE-Lua, which is bundled in [MGE XE](https://www.nexusmods.com/morrowind/mods/41102). So install that and run the MWSE-Updater.exe. 
- Second, you'll need NullCascade's [UI Expansion](https://www.nexusmods.com/morrowind/mods/46071) installed. 
- Once in game, press ` to bring up the console menu. Press the mwscript button to switch to lua console. Done! (Press the button again to switch back)

## Contact

To report issues or request commands, ping me @Amalie#9522 in the Discord server [Morrowind Modding Community](https://discord.me/mwmods), or open a bug report in the Nexusmods page Bugs section, or [Github Issues section](https://github.com/JoanyMcKarelyn/more-console-commands/issues).

## Commands

```
help
    Shows up available commands.
kaching
    Give current reference 1,000 gold.
motherlode
    Give current reference 50,000 gold.
money
    Set current reference gold amount to the input value.
levelup
    Increase the player's Skill Module skill by the input value.
mark
    Mark the player's current cell and position for recall.
recall
    Teleport the player to a previous mark.
follow
    Make the current reference your follower.
kill
    Kill the current reference.
```

### help - Shows up available commands.

```
Usage: help
```

### kaching - Give current reference 1,000 gold.

```
Usage: kaching

Description: If the current reference is given, they will be given 1,000 gold. If not, the player will be given 1,000 gold.

```

### motherlode - Give current reference 50,000 gold.

```
Usage: motherlode

Description: If the current reference is given, they will be given 50,000 gold. If not, the player will be given 50,000 gold.

```

### money - Set current reference gold amount to the input value.

```
Usage: money <amount>

Description: If the current reference is given, they will be given the input value amount of gold. If not, the player will be given the input value amount of gold. Note that parameters don't take variables. 

Example: money 420

```

### levelup - Increase the player's Skill Module skill by the input value.

```
Usage: levelup <skillname> <amount>

Description: If no skillname is given, a list of available skills will be printed. If valid skillname is given, according skill level will increase by the input value amount. If no amount is given, the amount is default to 1. Note that parameters don't take variables. 

Example: 

levelup -- Show a list of available skills
levelup bushcrafting -- Increase the Ashfall Bushcrafting skill by 1
levelup bushcrafting 10 -- Increase the Ashfall Bushcrafting skill by 10
```

### mark - Mark the player's current cell and position for recall.

```
Usage: mark <id>

Description: If no id is given, a list of previous marks will be printed. If id is given, the current cell and position of the player will be saved and previous mark using the same id will be overwritten. Marks can be accessed across all saves. Note that parameters don't take variables. 

Example: 

mark -- Show a list of previous marks
mark myhome -- Mark the current cell and position as myhome
mark guild_hall -- Mark the current cell and position as guild_hall
```

### recall - Teleport the player to a previous mark.

```
Usage: recall <id>

Description: If no id is given, a list of previous marks will be printed. If id is given and the mark exists, the player will be teleported to the marked location. Note that parameters don't take variables. 

Example: 

recall -- Show a list of previous marks
recall myhome -- Teleport the player to the previous mark myhome
recall guild_hal -- No mark with id guild_hal found. Do nothing.
```
    
### follow - Make the current reference your follower.

```
Usage: follow

Description: If a npc or a creature is selected as the current reference, they will start following the player. Use wander command to stop them from following.
```

### kill - Kill the current reference.

```
Usage: kill <"player">

Description: If the current reference is given and it is not the player, they will be killed instantly. If "player" is specified, the player will be killed instantly.

Example:

kill -- With a npc other than the player selected, the npc dies
kill -- With player selected, do nothing
kill player -- player dies
```

### wander - Make the current reference wander.

```
Usage: wander

Description: If a npc or a creature is selected as the current reference, they will wander and stop following the player. 
```