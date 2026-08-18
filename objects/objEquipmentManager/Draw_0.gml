if !objPlayer.equipmentOpen exit;
if !instance_exists(objInventoryManager) exit;

var _catCount = array_length(categories);

// total weapons across every category - this is the only thing that should
// trigger "No weapons available", not the current category being empty
var _totalCount = 0;
for (var _i = 0; _i < _catCount; _i++)
{
	_totalCount += array_length(items[_i]);
}

var _current = items[categoryIndex];
var _count = array_length(_current);

var _bg_xscale = 6;
var _bg_yscale = 2;
var _box_w = sprite_get_width(sprMenuBox) * _bg_xscale;
var _box_h = sprite_get_height(sprMenuBox) * _bg_yscale;
var _arrow_h = sprite_get_height(sprArrow);
var _arrow_w = sprite_get_width(sprArrow);

var _view_x = camera_get_view_x(view_camera);
var _view_y = camera_get_view_y(view_camera);
var _view_w = camera_get_view_width(view_camera);
var _view_h = camera_get_view_height(view_camera);

var _box_left  = _view_x + (_view_w/2);
var _box_bottom = (_view_y + _view_h) - padding - _arrow_h;
var _box_top   = _box_bottom - _box_h;

menu_x = _box_left + shakeOffset;
menu_y = _box_top + (_box_h / 2);

// category label, sits above the up arrow
draw_set_colour(c_white);
draw_set_halign(fa_middle);
draw_set_valign(fa_bottom);
draw_text(menu_x, _box_top - _arrow_h - 4, categoryLabels[categoryIndex]);

if (alarm[0] > 0)
{
	draw_set_colour(c_white);
	draw_set_valign(fa_middle);
	draw_set_halign(fa_middle);
	draw_text(menu_x, menu_y, "No weapons available");
}

if (_totalCount == 0)
{
	alarm[0] = 30;
}
else
{
	// categoryIndex to a non-empty category whenever _totalCount > 0
	selectedIndex[categoryIndex] = clamp(selectedIndex[categoryIndex], 0, _count - 1);
	var _s = _current[selectedIndex[categoryIndex]];

	draw_set_colour(c_white);
	draw_set_valign(fa_middle);
	draw_set_halign(fa_left);

	// up arrow
	draw_sprite_ext(sprArrow, upArrowFrame, menu_x, _box_top - (_arrow_h / 2) + 2, 1, -1, 0, c_white, 1);

	// box background
	draw_sprite_ext(sprMenuBox, 0, menu_x, menu_y, _bg_xscale, _bg_yscale, 0, c_white, 1);

	// down arrow
	draw_sprite_ext(sprArrow, downArrowFrame, menu_x, _box_bottom + (_arrow_h / 2) - 2, 1, 1, 0, c_white, 1);

	// icon
	draw_sprite(_s.ItemSprite, -1, _box_left - ((_box_w/2) - 10), menu_y);

	// text
	draw_set_colour(_s.Stats.textCol);
	draw_text(_box_left - ((_box_w/2) - 24), _box_top + (_box_h * 0.3), _s.ItemName);
	draw_set_colour(c_white);

	var _statLine = getEquipmentStatLine(categories[categoryIndex], _s.Stats);
	if (_statLine != "")
	{
		draw_text(_box_left - ((_box_w/2) - 24), _box_top + (_box_h * 0.65), _statLine);
	}
}

// left arrow category switch
draw_sprite_ext(sprArrow, leftArrowFrame, _box_left - (_box_w/2) - (_arrow_w/2), menu_y, 1, 1, -90, c_white, 1);

// right arrow category switch
draw_sprite_ext(sprArrow, rightArrowFrame, _box_left + (_box_w/2) + (_arrow_w/2), menu_y, 1, 1, 90, c_white, 1);


draw_set_colour(c_white);
