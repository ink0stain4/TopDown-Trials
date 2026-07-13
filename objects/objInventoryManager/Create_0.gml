depth = -9999999


// item constructor
function createItem(_id, _name, _desc, _spr, _effect = -1) constructor
{
	ItemID = _id;
	ItemName = _name;
	ItemDesc = _desc;
	ItemSprite = _spr;
	ItemEffect = _effect;
}

global.itemDictionary = 
	{

		burger : new createItem(
			"burger",
			"Burger",
			"It's a buger, YIPPEE!!!",
			sprBurger,
		
			function()
			{
				healPlayer(objPlayer, 10);
				inventory[selectedRow][selectedColumn] = noone;
			}
		),
		
		
		apple : new createItem(
			"apple",
			"Apple",
			"Doctor-Immunity",
			sprApple,
			function()
			{
				healPlayer(objPlayer, 5)
				inventory[selectedRow][selectedColumn] = noone;
			}
		)
				
	};


init_recipes() // load crafting recipe library


// grid setup
invColumns = 9;
invRows = 4;
padding = 2; // gap between slots

craftColumns = 3;
craftRows = 3;


slotW = sprite_get_width(sprInventorySlot);
slotH = sprite_get_height(sprInventorySlot);
pitchX = slotW + padding;
pitchY = slotH + padding;

xOffsetInv = 0
yOffsetInv = 42

xOffsetCraft = 0;
yOffsetCraft = -yOffsetInv + 6

outputGapX = 24;


selectedRow = -1;
selectedColumn = -1;

heldItem = noone; // attached to cursor

craftOutput = noone

// create inventory
inventory = array_create(invRows);
for (var i = 0; i < invRows; i++)
{
	inventory[i] = array_create(invColumns, noone);
}

// create crafting grid
craftInventory = array_create(craftRows);
for (var i = 0; i < craftRows; i++)
{
	craftInventory[i] = array_create(craftColumns, noone);
}

// Top left pixel pos of a given slot (call after gridX/gridY are set each frame
function getSlotPos(_row, _column)
{
	return [gridX + _column * pitchX, gridY + _row * pitchY];
}

function getCraftSlotPos(_row, _column)
{
	return [craftGridX + _column * pitchX, craftGridY + _row * pitchY];
}