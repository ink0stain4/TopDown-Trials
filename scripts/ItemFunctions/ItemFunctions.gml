//ItemFunctions.gml

function addItemToInventory(_item)
{
	for (var i = 0; i < objInventoryManager.invRows; i++)
	{
		for (var j = 0; j < objInventoryManager.invColumns; j++)
		{
			if (objInventoryManager.inventory[i][j] == noone)
			{
				objInventoryManager.inventory[i][j] = _item;
				return true;
			}
		}
	}
	return false; // if inventory full
}


function dropItemSlot(_array, row, column, _amount = 1)
{
	var _item = _array[row][column];
	var _gem = instance_create_layer(objPlayer.x, objPlayer.y, "Instances", objItemGem, { item: _item });
	
	with (_gem)
	{
		direction = point_direction(objPlayer.x, objPlayer.y, mouse_x, mouse_y);
		speed = 4;
		friction = 0.2;

		
		item = objInventoryManager.inventory[row][column]
	}
	
	_array[row][column] = noone;
}

function dropItemHeld(_amount = 1)
{
	var _item = objInventoryManager.heldItem;
	var _gem = instance_create_layer(objPlayer.x, objPlayer.y, "Instances", objItemGem, { item: _item });
	
	with (_gem)
	{
		direction = point_direction(objPlayer.x, objPlayer.y, mouse_x, mouse_y);
		speed = 4;
		friction = 0.2;

		
		item = objInventoryManager.heldItem
	}
	
	objInventoryManager.heldItem = noone;
}


// CRAFTING
function init_recipes()
{
	global.recipeList = [
		{
			shaped: true,
			pattern: [
				[noone, "burger", noone],
				["burger", noone, "burger"],
				[noone, "burger", noone]
			],
			result: "apple",
			resultCount: 1
		},
	
		{
			shaped: false,
			ingredients: ["apple"],
			result: "burger",
			resultCount: 1
		}
	];
}

function matchShaped(_recipe)
{
	for (var i = 0; i < objInventoryManager.craftRows; i++)
	{
		for (var j = 0; j < objInventoryManager.craftColumns; j++)
		{
			var _cell = objInventoryManager.craftInventory[i][j];
			var _cellID = (_cell == noone) ? noone : _cell.ItemID;
			
			if (_cellID != _recipe.pattern[i][j]) return false;
		}
	}
	return true;
}

function matchShapeless(_recipe)
{
	var _gridIDs = [];
	
	for (var i = 0; i < objInventoryManager.craftRows; i++)
	{
		for (var j = 0; j < objInventoryManager.craftColumns; j++)
		{
			var _cell = objInventoryManager.craftInventory[i][j];
			if (_cell != noone) array_push(_gridIDs, _cell.ItemID);
		}
	}
	
	if (array_length(_gridIDs) != array_length(_recipe.ingredients)) return false;
	
	var _recipeIDs = array_create(array_length(_recipe.ingredients));
	array_copy(_recipeIDs, 0, _recipe.ingredients, 0, array_length(_recipe.ingredients));
	
	array_sort(_gridIDs, true);
	array_sort(_recipeIDs, true);
	
	for (var k = 0; k < array_length(_gridIDs); k++)
	{
		if (_gridIDs[k] != _recipeIDs[k]) return false;
	}
	return true;
}

function checkForRecipe()
{
	for (var r = 0; r < array_length(global.recipeList); r++)
	{
		var _recipe = global.recipeList[r];
		var _isMatch = _recipe.shaped ? matchShaped(_recipe) : matchShapeless(_recipe);
		
		if (_isMatch) return global.itemDictionary[$ _recipe.result];
	}
	return noone;
}