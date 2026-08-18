// objGridSystem Step
// Cancel a pending conveyor placement the moment the player is no longer
// holding a conveyor item in the active hotbar slot - covers dropping it,
// scrolling/pressing a number key to switch slots, or running out of stock.
if (PendingConveyor != noone)
{
	var _hotbarItem = objInventoryManager.inventory[3][objInventoryManager.hotbarIndex];
	if (_hotbarItem == noone || _hotbarItem.ItemID != PendingConveyor.itemId)
	{
		PendingConveyor = noone;
	}
}