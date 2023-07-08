# More Console Commands by JosephMcKean

More Console Commands is a collection of commonly used console commands via [UI Expansion](https://www.nexusmods.com/morrowind/mods/46071) Lua console for Morrowind.

For a list of commands in game, check Mod Config Menu.

## Requirements

To get access to Lua console,

- First you'll need MWSE-Lua, which is bundled in [MGE XE](https://www.nexusmods.com/morrowind/mods/41102). So install that and run the MWSE-Updater.exe.
- Second, you'll need NullCascade's [UI Expansion](https://www.nexusmods.com/morrowind/mods/46071) installed.
- Once in game, press ` to bring up the console menu. Press the mwscript button to switch to lua console. Done! (Press the button again to switch back)

## Contact

To report issues or request commands, ping me @Amalie#9522 in the Discord server [Morrowind Modding Community](https://discord.me/mwmods), or open a bug report in the [Nexusmods page Bugs section](https://www.nexusmods.com/morrowind/mods/52500?tab=bugs), or [Github Issues section](https://github.com/JoanyMcKarelyn/more-console-commands/issues).

## Commands

```
kaching
    Give current reference 1,000 gold.
motherlode
    Give current reference 50,000 gold.
money
    Set current reference gold amount to the input value.
cure (v1.8)
    Cure current reference of disease, blight, poison, and restore attributes and skills
join (v1.16)
    Join the faction with the specifed id and raise to specified rank
levelup
    Increase the player's Skill Module skill by the input value.
max (v1.7, requested by iszlev)
    Set the current reference's ALL health/magicka/fatigue/attribute/skill base value to the input value
set (v1.7, requested by Vengyre and iszlev)
    Set the current reference's health/magicka/fatigue/attribute/skill base value to the input value
skills (v1.8)
    Print the current reference's skills
speedy (v1.2, requested by Vengyre)
    Set the player's Speed and Athletics to 200
fly (v1.11)
    Toggle levitation.
coc (v1.17)
    Teleport the player to a cell with specified id
mark
    Mark the player's current cell and position for recall.
position (v1.11)
    Teleport the player to a npc with specified id
recall
    Teleport the player to a previous mark.
emptyinventory
    Empty the current reference inventory
follow
    Make the current reference your follower.
kill
    Kill the current reference.
peace (v1.12)
    Pacify all the enemies. Irreversible.
resurrect
    Resurrect the current reference and keep the inventory.
showinventory
    Show the current reference inventory
spawn
    Spawn a reference with specifed id
wander
    Make the current reference wander and stop following
addall (v1.2, requested by VitruvianGuar)
    Add all objects of the objectType type to the current reference's inventory
additem (v.17.0)
    Add item with specified id
addone
    Add one objet of the objectType type to the current reference's inventory
setownership (v1.9, requested by Markel)
    Set ownership of the current reference to none, or the specified NPC or faction with specified base ID
unlock (v1.17)
    Unlock lock
time (v1.19)
    Set the current time
weather (v1.11)
    Change the current weather immediately.
cls (v1.9)
    Clear console
lookup (v1.15.0)
    Look up objects by id or name
qqq (v1.4, requested by Hedy and EarthApocalypto)
    Quit Morrowind
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

### cure - Cure current reference of disease, blight, poison, and restore attributes and skills

```
Usage: cure
```

### join - Join the faction with the specifed id and raise to specified rank

```
Usage: join faction-id rank?

Example:

join telvanni -- Join the Great House Telvanni
join mages guild 3 -- Join the Mages Guild and raise to Evoker

```

### levelup - Increase the player's Skill Module skill by the input value.

```
Usage: levelup skillname amount

Description: If valid skillname is given, according skill level will increase by the input value amount.

Example:

levelup bushcrafting 10 -- Increase the Ashfall Bushcrafting skill by 10

List of available Skill Module skills:

bushcrafting (Ashfall)
climbing (Mantle of Ascension)
cooking (Morrowind Crafting)
corpsepreparation (Necrocraft)
crafting (Morrowind Crafting)
fishing (Ultimate Fishing)
fletching (Go Fletch)
mcfletching (Morrowind Crafting)
inscription (Demon of Knowledge)
masonry (Morrowind Crafting)
metalworking (Morrowind Crafting)
mining (Morrowind Crafting)
packrat (Packrat Skill)
painting (Joy of Painting)
performance (Bardic Inspiration)
sewing (Morrowind Crafting)
smithing (Morrowind Crafting)
staff (MWSE Staff Skill)
survival (Ashfall)
woodworking (Morrowind Crafting)
```

### max - Set the current reference's ALL attributes and skills base value to the input value

```
Usage: max value?

Example:

max -- set all attributes all skills to 200
max 999 -- set all attributes all skills to 999
```

### set - Set the current reference's health/magicka/fatigue/attribute/skill base value to the input value

```
Usage: set health value, set magicka value, set fatigue value, set attribute value, set skill value

Description: skill needs to be onesingleword like block, mediumarmor, handtohand.

Example:

set health 200
set luck 200
set handtohand 200
```

### skills - Print the current reference's skills' current value

```
Usage: skills
```

### speedy - Set the player's Speed and Athletics to 200

```
Usage: help
```

### fly - Toggle levitation

```
Usage: fly
```

### coc - Teleport the player to a cell with specified id or specifed grid x and grid y

```
Usage:

coc id
coc x y

Description: Better coc! You can specify either grid or id. It teleports you to marker instead of inside a rock like vanilla coc.

Example:
coc dagon fel -- teleport to Dagon Fel
coc 13 -1 -- teleport to Erabenimsun Camp
coc solstheim -- teleport to Fort Frostmoth
coc mournhold -- teleport to Mournhold, Royal Palace: Courtyard
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

### position - Teleport the player to a npc with specified id.

```
Alias: moveto

Usage: position <id>

Example:

position caius cosades -- Teleport the player to NPC Caius Cosades
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

### peace - Pacify all the enemies. Irreversible.

```
Usage: peace
```

### resurrect - Resurrect the current reference and keep the inventory.

```
Usage: resurrect
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

### additem - Add item with specified id

```
Usage: additem item-id count?

Example:

additem iron tanto -- Add an iron tanto to current reference's inventory
additem silver throwing star 100 -- Add 100 silver throwing stars to the current reference's inventory
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

### dupe - Duplicate the item that is the current reference to the player's inventory

```
Usage: dupe count?

Example:

dupe -- Targeting a Common Soul Gem, add a Common Soul Gem to the player's inventory
dupe 69 -- Targeting Moon Sugar, add 69 Moon Sugar to the player's inventory
```

### setownership - Set ownership of the current reference to none, or the specified NPC or faction with specified base ID

```
Usage: setownership id?

Example:

setownership -- Clear current reference ownership
setownership fargoth -- Set current reference ownership to Fargoth
setownership mages guild -- Set current reference ownership to Mages Guild
```

### unlock - Unlock lock

```
Usage: unlock
```

### weather - Set the current time

```
Usage: time gamehour

Example:

time 13:01 -- set the current time to 13:01
time sunset -- set the current time to 18:00
time day -- set the current time to 8:00
```

### weather - Change the current weather immediately to the specified weather

```
Aliases: forceweather/fw

Usage: weather weatherId

Example:

weather clear -- Switch the weather immediately to clear/sunny weather
weather rain -- Switch the weather immediately to rainy weather
weather blight -- Switch the weather immediately to blight weather
```

### cls - Clear console

```
Usage: cls
```

### lookup - Look up objects by id or name

```
Usage: lookup name
```

### qqq - Quit Morrowind

```
Aliases: quitgame

Usage: qqq
```
