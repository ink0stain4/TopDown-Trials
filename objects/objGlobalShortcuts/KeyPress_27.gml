// Key Press - esc
if (!instance_exists(objPlayer))
{
	exit;
}

if (instance_exists(objMenu)) exit;

if (objPlayer.showInventory) exit;
if (objPlayer.equipmentOpen) exit;

if (objInventoryManager.activeChest) exit;

pauseMenu()