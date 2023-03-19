# More Console Commands by JosephMcKean

More Console Commands is a collection of commonly used console commands via [UI Expansion](https://www.nexusmods.com/morrowind/mods/46071) Lua console for Morrowind.

For basic help, type the command line: help

## Requirements

To get access to Lua console, 
- First you'll need MWSE-Lua, which is bundled in [MGE XE](https://www.nexusmods.com/morrowind/mods/41102). So install that and run the MWSE-Updater.exe. 
- Second, you'll need NullCascade's [UI Expansion](https://www.nexusmods.com/morrowind/mods/46071) installed. 
- Once in game, press ` to bring up the console menu. Press the mwscript button to switch to lua console. Done! (Press the button again to switch back)

## Contact

To report issues or request commands, ping me @Amalie#9522 in the Discord server [Morrowind Modding Community](https://discord.me/mwmods), or open a bug report in the [Nexusmods page Bugs section](https://www.nexusmods.com/morrowind/mods/52500?tab=bugs), or [Github Issues section](https://github.com/JoanyMcKarelyn/more-console-commands/issues).

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
set (v1.2, requested by Vengyre)
    Set the current reference's attribute or skill base value
speedy (v1.2, requested by Vengyre)
    Set the player's Speed and Athletics to 200
mark
    Mark the player's current cell and position for recall.
recall
    Teleport the player to a previous mark.
emptyinventory
    Empty the current reference inventory
follow
    Make the current reference your follower.
kill
    Kill the current reference.
showinventory
    Show the current reference inventory
spawn
    Spawn a reference with specifed id
wander
    Make the current reference wander and stop following
addall (v1.2, requested by VitruvianGuar)
    Add all objects of the objectType type to the current reference's inventory
addone
    Add one objet of the objectType type to the current reference's inventory
qqq (v1.4, requested by Hedy and EarthApocalypto)
    Quit Morrowind
```

### help - Show a list of available commands.

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

Description: If the current reference is given, the amount of gold they carry will be set to given the input value amount. If not, the amount of gold the player has will be set to given the input value amount. Note that parameters don't take variables. 

Example: money 420 -- Set the gold amount to 420

```

### levelup - Increase the player's Skill Module skill by the input value.

```
Usage: levelup <skillname> <amount>

Description: If valid skillname is given, according skill level will increase by the input value amount. 

Example: 

levelup bushcrafting -- Increase the Ashfall Bushcrafting skill by 1
levelup bushcrafting 10 -- Increase the Ashfall Bushcrafting skill by 10

List of available Skill Module skills:

bushcrafting (Ashfall)
climbing (Mantle of Ascension)
cooking (Morrowind Crafting)
corpsepreparation (Necrocraft)
crafting (Morrowind Crafting)
fletching (Go Fletch)
mcfletching (Morrowind Crafting)
inscription (Demon of Knowledge)
masonry (Morrowind Crafting)
metalworking (Morrowind Crafting)
mining (Morrowind Crafting)
packrat (Packrat Skill)
performance (Bardic Inspiration)
sewing (Morrowind Crafting)
smithing (Morrowind Crafting)
staff (MWSE Staff Skill)
survival (Ashfall)
woodworking (Morrowind Crafting)
```

### set - Set the current reference's attribute or skill base value

```
Usage: set <attribute> <value>, set <skill> <value>

Description: <skill> needs to be onesingleword like block, mediumarmor, handtohand. 

Example: 

set strength 200
set axe 200
set handtohand 200
```

### speedy - Set the player's Speed and Athletics to 200

```
Usage: help
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

### emptyinventory - Empty the current reference inventory.

```
Usage: emptyinventory player?

Description: If a npc/creature/container is selected as the current reference, their inventory will be emptied. Used with caution as there is no way to recover the items lost except reloading.

Example:

emptyinventory -- empty current reference's inventory, except player's
emptyinventory player -- empty player's inventory
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

### showinventory - Show the current reference inventory.

```
Usage: showinventory

Description: Take the contents from the inventory via this method does not count as stealing. Note that leveled list items are infinitely respawned. For example, if you take a steel cuirass from an Imperial Guard, they will not get half-naked but instead get another cuirass from the leveled list.
```

### spawn - Spawn a reference with specifed id.

```
Usage: spawn id

Example:

spawn fargoth -- spawn a new fargoth reference
spawn femgoth -- error: invalid object id
```

### wander - Make the current reference wander.

```
Usage: wander

Description: If a npc or a creature is selected as the current reference, they will wander and stop following the player. 
```

### addall - Add all objects of the objectType type to the current reference's inventory

```
Usage: addall <objectType> <count?>

Description: If the count param is given, add all objects that can be carried and have no script attached of the objectType type <count> each to the current reference's inventory. If the count is not given, it is default to 1 each.

Valid objectType includes: alchemy, ammunition, apparatus, armor, book, clothing, ingredient, light, lockpick, miscitem, probe, repairitem, weapon.

Example:

addall ingredient 5 -- Add 5 of all ingredients in the game to the inventory of the current reference 
addall apparatus -- Add 1 of all apparatus in the game to the inventory of the current reference 
```

### addone - Add one object of the objectType type to the current reference's inventory

```
Usage: addone objectType count?

Description: Add one carriable object that (1. can be carried, 2. have no script attached, 3. is not gold) of the objectType type to the current reference's inventory

Valid objectType includes: alchemy, ammunition, apparatus, armor, book, clothing, ingredient, light, lockpick, miscitem, probe, repairitem, weapon.

Example:

addone clothing -- Add a random clothing to the current reference's inventory
addone ammunition 100 -- Add 100 copies of a random ammunition to the current reference's inventory
```

### qqq - Quit Morrowind

```
Usage: qqq
```