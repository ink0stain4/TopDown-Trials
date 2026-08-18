chestColumns = 5;
chestRows = 3;

containerInventory = array_create(chestRows);
for (var i = 0; i < chestRows; i++)
{
	containerInventory[i] = array_create(chestColumns, noone);
}


chestID = "";
isOpen = false;

sprite_x = (x)
sprite_y = (y)

anim_index = 0;
anim_speed = 0.05; 

function interaction()
{
	objInventoryManager.activeChest = id;
	objPlayer.showInventory = true;
	isOpen = true;
	image_index = 0; // open chest sprite
}

hovered = false

BreakDuration = 60 //frames

BreakProgress = 0