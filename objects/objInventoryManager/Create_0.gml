depth = -9999999


sep = 16;

// item constructor
function createItem(_name, _desc, _spr, _effect = -1) constructor
{
	ItemName = _name;
	ItemDesc = _desc;
	ItemSprite = _spr;
	ItemEffect = _effect;
}

global.itemDictionary = 
{

	burger : new createItem(
		"Burger",
		"It's a buger, YIPPEE!!!",
		sprBurger,
		
		function()
		{
			healPlayer(objPlayer, 10);
			array_delete(inventory, selected_item, 1);
		}
	),
		
		
	apple : new createItem(
		"Apple",
		"Doctor-Immunity",
		sprApple,
		function()
		{
			healPlayer(objPlayer, 5)
			array_delete(inventory, selected_item, 1)
		}
	)
				
};


inventory = array_create(0);

selected_item = -1