//objConveyor create
InitBreakableBlocks()

Direction = "right";   // overwritten by placeConveyorBelt
BeltTiles = [];        // {row, col}, ordered input -> output
Slots = [];             // one per tile: noone, or { item, progress }
Speed = 0.02;           // fraction of a tile per step - tune as needed

function initBeltSlots()
{
	Slots = array_create(array_length(BeltTiles), noone);
}

