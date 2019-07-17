#Set a color scoreboard tag for each shulker box
function shulkerboxstacking:setColors

#Add isEmpty tag by first testing if it has items, then adding a tag if it does not
#scoreboard players tag @e[type=Item] add isNotEmpty {Item:{id:"minecraft:purple_shulker_box",tag:{BlockEntityTag:{Items:[{}]}}}}
#scoreboard players tag @e[type=Item,tag=!isNotEmpty] add isEmpty {Item:{id:"minecraft:purple_shulker_box"}}
function shulkerboxstacking:setIsNotEmpty
function shulkerboxstacking:setIsEmpty

#Select a random item to be tested
scoreboard players tag @r[type=Item,tag=isEmpty,score_shulkerBoxCount_min=1] add currentlyExecuting

#Make sure they all have the same color
execute @e[type=Item,tag=!currentlyExecuting,score_shulkerBoxCount_min=1] ~ ~ ~ scoreboard players set @e[type=Item,c=1] colorCompare 0
execute @e[type=Item,tag=!currentlyExecuting,score_shulkerBoxCount_min=1] ~ ~ ~ scoreboard players operation @e[type=Item,c=1] colorCompare = @e[type=Item,c=1] shulkerBoxColor
execute @e[type=Item,tag=!currentlyExecuting,score_shulkerBoxCount_min=1] ~ ~ ~ scoreboard players operation @e[type=Item,c=1] colorCompare -= @e[tag=currentlyExecuting] shulkerBoxColor

#Set all others to not be tested
scoreboard players tag @e[type=Item,tag=!currentlyExecuting,score_shulkerBoxCount_min=1,score_colorCompare_min=0,score_colorCompare=0] add notCurrentlyExecuting {Tags:["isEmpty"]}

#Set shulkerBoxCount for all items
scoreboard players set @e[tag=isEmpty] shulkerBoxCount 0
function shulkerboxstacking:setShulkerBoxCount

#Add to the shulkerBoxCount
execute @e[tag=currentlyExecuting] ~ ~ ~ execute @e[tag=notCurrentlyExecuting,r=1] ~ ~ ~ scoreboard players operation @e[tag=currentlyExecuting] shulkerBoxCount += @e[type=Item,c=1] shulkerBoxCount

#Kill others and replace them with one item (or more if shulkerBoxCount > 64)
execute @e[tag=currentlyExecuting] ~ ~ ~ kill @e[tag=notCurrentlyExecuting,r=1]
function shulkerboxstacking:changeItemCount
execute @e[tag=currentlyExecuting,score_shulkerBoxCount_min=64] ~ ~ ~ function shulkerboxstacking:summonExtraItems

#Clean up tags for next loop
scoreboard players tag @e remove currentlyExecuting
scoreboard players tag @e remove notCurrentlyExecuting

#Not strictly necessary, just cleaner
scoreboard players tag @e remove isEmpty