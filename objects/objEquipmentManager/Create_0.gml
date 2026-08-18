objPlayer.equipmentOpen = false

padding = 12

nuhUh = false
shakeOffset = 0

upArrowFrame = 0
downArrowFrame = 0
leftArrowFrame = 0
rightArrowFrame = 0

upArrowAnimate = false
downArrowAnimate = false
leftArrowAnimate = false
rightArrowAnimate = false



function getEquipmentStatLine(_category, _stats)
{
	switch (_category)
	{
		case "melee":
		case "ranged":
		case "magic":
			return "x" + string(_stats.damageMultiplier) + " dmg";
		case "tools":
			return "Efficiency " + string(_stats.BreakSpeed);
		default:
			return ""; // trinkets etc — nothing to show
	}
}


// weapon categories
//
categories      = ["melee", "ranged", "magic", "tools"];
categoryLabels  = ["Melee", "Ranged", "Magic", "Tools"];
categoryIndex   = 0; // 0 = melee, the default

// per-category item list + per-category remembered selection
var _catCount = array_length(categories);
items = array_create(_catCount);
selectedIndex = array_create(_catCount, 0);

for (var _i = 0; _i < _catCount; _i++)
{
	items[_i] = [];
}

menu_x = camera_get_view_x(view_camera) + (camera_get_view_width(view_camera)/2);
menu_y = camera_get_view_y(view_camera) - (camera_get_view_height(view_camera));
