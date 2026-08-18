#region arrow sprite animate
if upArrowFrame >= 6
{
	upArrowAnimate = false
	upArrowFrame = 0
}

if downArrowFrame >= 6
{	
	downArrowAnimate = false
	downArrowFrame = 0
}

if leftArrowFrame >= 6
{	
	leftArrowAnimate = false
	leftArrowFrame = 0
}

if rightArrowFrame >= 6
{	
	rightArrowAnimate = false
	rightArrowFrame = 0
}

if upArrowAnimate
upArrowFrame++
if downArrowAnimate
downArrowFrame++
if leftArrowAnimate
leftArrowFrame++
if rightArrowAnimate
rightArrowFrame++

#endregion

if !instance_exists(objInventoryManager) exit;

var _catCount = array_length(categories);

// refresh every category's item list (cheap enough for a handful of categories;
for (var _i = 0; _i < _catCount; _i++)
{
	items[_i] = getItemsByType(categories[_i]);
}

// finds the next category (in _dir direction) that actually has items,
// wrapping around. returns _start unchanged if nothing else has items.
function findNextNonEmptyCategory(_start, _dir, _catCount)
{
	var _i = _start;
	for (var _n = 0; _n < _catCount; _n++)
	{
		_i = (_i + _dir + _catCount) mod _catCount;
		if (array_length(items[_i]) > 0) return _i;
	}
	return _start;
}

// safety net: if the active category just ran dry (last weapon of that
// type dropped/used/etc), hop to the next non-empty one automatically
if (array_length(items[categoryIndex]) == 0)
{
	categoryIndex = findNextNonEmptyCategory(categoryIndex, 1, _catCount);
}

var _current = items[categoryIndex];
var _count = array_length(_current);

if (_count > 0)
{
	selectedIndex[categoryIndex] = clamp(selectedIndex[categoryIndex], 0, _count - 1);
	var _s = _current[selectedIndex[categoryIndex]];

	switch (categories[categoryIndex])
	{
		case "melee":  objPlayer.swordPower		= _s.Stats.damageMultiplier;	break;
		case "ranged": objPlayer.rangedPower	= _s.Stats.damageMultiplier;	break;
		case "magic":  objPlayer.magicPower		= _s.Stats.damageMultiplier;	break;
		case "tools":	objPlayer.BreakSpeed	= _s.Stats.BreakSpeed;			break;
	}
}
else
{
	switch (categories[categoryIndex])
	{
		case "melee":	objPlayer.swordPower  = 0.4;	break; // fallback "fists" damage
		case "ranged":	objPlayer.rangedPower = 0;		break;
		case "magic":	objPlayer.magicPower  = 0;		break;
		case "tools":	objPlayer.BreakSpeed  = 0;		break;
	}
}

objPlayer.equippedCategory = categories[categoryIndex];

if !objPlayer.equipmentOpen exit;

// up/down cycle items
if (_count > 0)
{
	if (keyboard_check_pressed(ord("W"))) || (mouse_wheel_up())
	{
		selectedIndex[categoryIndex] = (selectedIndex[categoryIndex] - 1 + _count) mod _count; // up = previous
		upArrowAnimate = true
	}
	if (keyboard_check_pressed(ord("S"))) || (mouse_wheel_down())
	{
		selectedIndex[categoryIndex] = (selectedIndex[categoryIndex] + 1) mod _count; // down = next
		downArrowAnimate = true
	}
}

// left/right cycle weapon category, skipping any category with no items
if (keyboard_check_pressed(ord("A")))
{
	categoryIndex = findNextNonEmptyCategory(categoryIndex, -1, _catCount); // left previous category
	leftArrowAnimate = true
}
if (keyboard_check_pressed(ord("D")))
{
	categoryIndex = findNextNonEmptyCategory(categoryIndex, 1, _catCount); // right next category
	rightArrowAnimate = true
}

if keyboard_check_pressed(vk_backspace)
nuhUh = true

if (nuhUh) 
{
	alarm[1] = 12; 
	nuhUh = false; 
} 

if (alarm[1] > 0) 
{ 
	var _shake_speed = 3; 
	var _max_amplitude = 2; 
    
	var _decay = alarm[1] / 15; 
	shakeOffset = dsin(alarm[1] * _shake_speed * 45) * _max_amplitude * _decay;
} 
else 
{ 
	shakeOffset = lerp(shakeOffset, 0, 0.8); 
}