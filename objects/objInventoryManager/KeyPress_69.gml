//objInventoryManager Keypress - E
if objPlayer.equipmentOpen exit;

if !instance_exists(objMenu)
{
	objPlayer.showInventory = !(objPlayer.showInventory);

	if (!objPlayer.showInventory)
	{
		if (heldItem != noone) dropItemHeld(heldItem.Count);
		
		if (craftingOpen)
		{
			for (var i = 0; i < craftRows; i++)
			{
				for (var j = 0; j < craftColumns; j++)
				{
					var _item = craftInventory[i][j];
					if (_item != noone) dropItemSlot(craftInventory, i, j, _item.Count);
				}
			}
			craftOutput = noone;
			craftingOpen = false;
		}
		
		dragMode = eDragMode.NONE;
		dragSlots = [];
		dragStartSlot = noone;
		dragMoved = false;
		shiftDragActive = false;
	}

	if (activeChest != noone)
	{
		global.chestSaveData[$ activeChest.chestID] = {
			lootGenerated: true,
			inventory: serializeInventoryGrid(activeChest.containerInventory, activeChest.chestRows, activeChest.chestColumns)
		};

		activeChest.isOpen = false;
		activeChest.image_index = 0;
		activeChest = noone;
	}
}