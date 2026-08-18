if (!variable_global_exists("chestSaveData")) global.chestSaveData = {};

if (chestID == "")
{
	chestID = room_get_name(room) + "_" + string(floor(x)) + "_" + string(floor(y));
}

DropItem = global.itemDictionary[$ "chest"]; // moved here — guaranteed itemDictionary exists by now

var _saved = variable_struct_exists(global.chestSaveData, chestID) ? global.chestSaveData[$ chestID] : noone;
if (_saved != noone)
{
	lootGenerated = true;
	containerInventory = deserializeInventoryGrid(_saved.inventory, chestRows, chestColumns);
}
else if (!lootGenerated)
{
	generateChestLoot(lootTableId, containerInventory, chestRows, chestColumns);
	lootGenerated = true;
	
	// register immediately — re-entering the room this session (even without saving) won't reroll
	global.chestSaveData[$ chestID] = {
		lootGenerated: true,
		inventory: serializeInventoryGrid(containerInventory, chestRows, chestColumns)
	};
}

