// objConveyorBelt draw
var _sprEnd, _sprMid, _sprStart;
switch (Direction)
{
	case "left":  _sprEnd = sprConveyorLeft1;  _sprMid = sprConveyorLeft2;  _sprStart = sprConveyorLeft3;  break;
	case "right": _sprEnd = sprConveyorRight1; _sprMid = sprConveyorRight2; _sprStart = sprConveyorRight3; break;
	case "up":    _sprEnd = sprConveyorUp1;    _sprMid = sprConveyorUp2;    _sprStart = sprConveyorUp3;    break;
	case "down":  _sprEnd = sprConveyorDown3;  _sprMid = sprConveyorDown2;  _sprStart = sprConveyorDown1;  break;
}

var _count = array_length(BeltTiles);

for (var i = 0; i < _count; i++)
{
	var _t = BeltTiles[i];
	var _pos = objGridSystem.tileToWorld(_t.row, _t.col);
	
	var _spr = _sprMid;
	if (i == 0)             _spr = _sprStart;
	else if (i == _count-1) _spr = _sprEnd;
	
	draw_sprite_ext(_spr, -1, _pos.x, _pos.y, 1, 1, 0, c_white, 1);
}

var _dx = 0, _dy = 0;
switch (Direction)
{
	case "left":  _dx = -1; break;
	case "right": _dx =  1; break;
	case "up":    _dy = -1; break;
	case "down":  _dy =  1; break;
}

for (var i = 0; i < array_length(Slots); i++)
{
	var _slot = Slots[i];
	if (_slot == noone) continue;
	
	var _t = BeltTiles[i];
	var _pos = objGridSystem.tileToWorld(_t.row, _t.col);
	var _cx = _pos.x + objGridSystem.TileSize / 2 + (_dx * objGridSystem.TileSize * _slot.progress);
	var _cy = _pos.y + objGridSystem.TileSize / 2 + (_dy * objGridSystem.TileSize * _slot.progress);
	
	draw_sprite(_slot.item.SlotSprite, 0, _cx, _cy);
}

drawConveyorOutlineInfo()