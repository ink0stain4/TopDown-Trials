//CustomFunctions.gml

function checkFullscreenShortcut()
{
	if keyboard_check_pressed(vk_f11)
		{
			window_set_fullscreen(!window_get_fullscreen())
			if (window_get_fullscreen() == false)
			{
				window_center()
			}
		}
}

function playerDie(){
	
	game_restart();
};


function drawInteractPrompt()
{
	var detected = objPlayer.interactableInRange;
	if (detected == id)
	{
		with objCameraManager
		{
			draw_sprite(sprPrompt_Space,
			floor(other.anim_index),
			final_x + (camera_get_view_width(view_camera)/2),
			final_y + (camera_get_view_height(view_camera)*0.8));
		}
	}
}

/// @function draw_hologram(_color, _rimStrength, _scanSpeed, _scanDensity, _scanStrength, _flicker, _baseAlpha, _glitch)
/// @description Draws the calling instance's own sprite with the hologram shader.
///              Call this INSIDE any object's Draw Event instead of draw_self().
/// @param {Array<Real>} _color        [r,g,b] 0..1, e.g. [0.15, 0.9, 1.0]
/// @param {Real} _rimStrength         e.g. 1.6
/// @param {Real} _scanSpeed           e.g. 2.0
/// @param {Real} _scanDensity         e.g. 60.0
/// @param {Real} _scanStrength        e.g. 0.5
/// @param {Real} _flicker             e.g. 0.08
/// @param {Real} _baseAlpha           e.g. 0.55
/// @param {Real} _glitch              e.g. 2.0

function draw_hologram(_color, _rimStrength, _scanSpeed, _scanDensity, _scanStrength, _flicker, _baseAlpha, _glitch)
{
    // Nothing to draw if this instance has no sprite assigned
    if (sprite_index == -1) exit;

    shader_set(shdHologram);

    shader_set_uniform_f(shader_get_uniform(shdHologram, "u_time"), current_time / 1000.0);
    shader_set_uniform_f(shader_get_uniform(shdHologram, "u_hologramColor"), _color[0], _color[1], _color[2]);
    shader_set_uniform_f(shader_get_uniform(shdHologram, "u_rimStrength"), _rimStrength);
    shader_set_uniform_f(shader_get_uniform(shdHologram, "u_texelSize"),
        1.0 / sprite_get_width(sprite_index),
        1.0 / sprite_get_height(sprite_index));
    shader_set_uniform_f(shader_get_uniform(shdHologram, "u_scanlineSpeed"), _scanSpeed);
    shader_set_uniform_f(shader_get_uniform(shdHologram, "u_scanlineDensity"), _scanDensity);
    shader_set_uniform_f(shader_get_uniform(shdHologram, "u_scanlineStrength"), _scanStrength);
    shader_set_uniform_f(shader_get_uniform(shdHologram, "u_flickerAmount"), _flicker);
    shader_set_uniform_f(shader_get_uniform(shdHologram, "u_baseAlpha"), _baseAlpha);
    shader_set_uniform_f(shader_get_uniform(shdHologram, "u_glitchAmount"), _glitch);

	gpu_set_blendmode(bm_subtract)
	
	gpu_set_blendmode(bm_normal)
	shader_reset();
}

function draw_hologram_default() {
	draw_hologram([0.15, 0.9, 1.0], 1.6, 2.0, 60.0, 0.5, 0.08, 0.55, 2.0);
}


function InitBreakableBlocks(_breaktime = 60)
{
	hovered = false
	BreakDuration = _breaktime //frames
	BreakProgress = 0
}


// Returns true the single frame BreakProgress crosses BreakDuration - false every other frame.
function updateBreakProgress()
{
	if BreakDuration <= 0 return false;
	
	hovered = (point_distance(x, y, objPlayerSpecialHitbox.x, objPlayerSpecialHitbox.y) <= (objPlayer.playerRange)) && position_meeting(mouse_x, mouse_y, self)
	
	if (hovered) && (mouse_check_button(mb_left))
		BreakProgress += objPlayer.BreakSpeed;
	else if (BreakProgress > 0)
		BreakProgress--;
	
	BreakProgress = clamp(BreakProgress, 0, BreakDuration)
	
	return (BreakProgress >= BreakDuration);
}

function updateConveyorBreakProgress()
{
	if BreakDuration <= 0 return false;
	
	hovered = false;
	
	for (var i = 0; i < array_length(BeltTiles); i++)
	{
		var _t = BeltTiles[i];
		var _pos = objGridSystem.tileToWorld(_t.row, _t.col);
		var _cx = _pos.x + objGridSystem.TileSize / 2;
		var _cy = _pos.y + objGridSystem.TileSize / 2;
		
		var _mouseOver = (mouse_x >= _pos.x && mouse_x < _pos.x + objGridSystem.TileSize
			&& mouse_y >= _pos.y && mouse_y < _pos.y + objGridSystem.TileSize);
		
		if (_mouseOver && point_distance(_cx, _cy, objPlayerSpecialHitbox.x, objPlayerSpecialHitbox.y) <= objPlayer.playerRange)
		{
			hovered = true;
			break;
		}
	}
	
	if (hovered) && (mouse_check_button(mb_left))
		BreakProgress += objPlayer.BreakSpeed;
	else if (BreakProgress > 0)
		BreakProgress--;
	
	BreakProgress = clamp(BreakProgress, 0, BreakDuration)
	
	return (BreakProgress >= BreakDuration);
}

function drawConveyorOutlineInfo()
{
	if (hovered) && (objPlayer.BreakSpeed > 0)
	{
		draw_set_colour(c_black)
		for (var i = 0; i < array_length(BeltTiles); i++)
		{
			var _t = BeltTiles[i];
			var _pos = objGridSystem.tileToWorld(_t.row, _t.col);
			draw_rectangle(_pos.x, _pos.y, _pos.x + objGridSystem.TileSize, _pos.y + objGridSystem.TileSize, true)
		}
	}
	
	if (BreakProgress > 0)
	{
		var _mid = BeltTiles[floor(array_length(BeltTiles) / 2)];
		var _midPos = objGridSystem.tileToWorld(_mid.row, _mid.col);
		var _breakLevel = (BreakProgress / BreakDuration) * sprite_get_number(sprBreakAnim) - 1;
		draw_sprite(sprBreakAnim, _breakLevel, _midPos.x + objGridSystem.TileSize / 2, _midPos.y + objGridSystem.TileSize / 2)
	}
	
	if global.debug
	{
		draw_set_halign(fa_center)
		draw_set_colour(c_white)
		draw_text(x, y - 10, BreakProgress)
	}
}

function drawConveyorPlacementPreview()
{
	var _anchor = PendingConveyor;
	var _anchorPos = tileToWorld(_anchor.row, _anchor.col);
	
	draw_set_color(c_yellow);
	draw_rectangle(_anchorPos.x, _anchorPos.y, _anchorPos.x + TileSize, _anchorPos.y + TileSize, true);
	
	var _tile = getReachableTile(mouse_x, mouse_y);
	if (!isTileInBounds(_tile.row, _tile.col) || (_tile.row == _anchor.row && _tile.col == _anchor.col))
	{
		draw_set_color(c_white);
		return;
	}
	
	var _sameRow = (_tile.row == _anchor.row);
	var _sameCol = (_tile.col == _anchor.col);
	
	if (_sameRow == _sameCol) // not a straight line at all
	{
		draw_set_color(c_red);
		var _pos = tileToWorld(_tile.row, _tile.col);
		draw_rectangle(_pos.x, _pos.y, _pos.x + TileSize, _pos.y + TileSize, true);
		draw_set_color(c_white);
		return;
	}
	
	var _length = (_sameRow ? abs(_tile.col - _anchor.col) : abs(_tile.row - _anchor.row)) + 1;
	var _rowStep = sign(_tile.row - _anchor.row);
	var _colStep = sign(_tile.col - _anchor.col);
	
	var _r = _anchor.row, _c = _anchor.col;
	var _valid = (_length <= 12);
	var _drawCount = min(_length, 12);
	
	for (var i = 0; i < min(_length, 12); i++)
	{
		if (!isTileInBounds(_r, _c) || (TileGrid[_r][_c] != noone && i > 0))
		{
			_valid = false;
			_drawCount = i + (isTileInBounds(_r, _c) ? 1 : 0);
			break;
		}
		_r += _rowStep;
		_c += _colStep;
	}
	
	draw_set_color(_valid ? c_lime : c_red);
	
	_r = _anchor.row; _c = _anchor.col;
	for (var i = 0; i < _drawCount; i++)
	{
		var _pos = tileToWorld(_r, _c);
		draw_rectangle(_pos.x, _pos.y, _pos.x + TileSize, _pos.y + TileSize, true);
		_r += _rowStep;
		_c += _colStep;
	}
	
	draw_set_color(c_white);
}

// One function for every breakable placed thing - trees/rocks, crafting tables,
// furnaces, chests. Anything that doesn't apply to a given instance (chest
// contents, save data, grid tracking) just no-ops via the exists-checks below.
function UpdateBreakableTile()
{
	if objPlayer.BreakSpeed <= 0 exit; // skip hover/distance checks entirely while unarmed
	if (!updateBreakProgress()) exit;
	
	// dump stored contents, if this instance has any (chests do, most things don't)
	if (variable_instance_exists(id, "containerInventory"))
	{
		for (var i = 0; i < chestRows; i++)
		{
			for (var j = 0; j < chestColumns; j++)
			{
				var _item = containerInventory[i][j];
				if (_item != noone) dropItemLoot(_item, _item.Count, true, true);
			}
		}
	}
	
	// if this was the currently-open container, kick the player out cleanly
	if (objInventoryManager.activeChest == id)
	{
		objInventoryManager.activeChest = noone;
		objPlayer.showInventory = false;
	}
	
	// forget any position-keyed save data tied to this instance (chests use this)
	if (variable_instance_exists(id, "chestID") && variable_struct_exists(global.chestSaveData, chestID))
	{
		variable_struct_remove(global.chestSaveData, chestID);
	}
	
	// grid bookkeeping - best effort, no-op if untracked or no grid system exists
	if (instance_exists(objGridSystem))
	{
		var _pos = objGridSystem.worldToTile(x, y);
		objGridSystem.removeFromGrid(_pos.row, _pos.col);
	}
	
	dropItemLoot(DropItem, 1, false, true);
	instance_destroy();
}

// Same as UpdateBreakableTile, but for a multi-tile belt: mining it must
// drop every item currently riding it and clear every grid cell it
// occupies, not just the one under the instance's own x/y.
function UpdateBreakableConveyor()
{
	if objPlayer.BreakSpeed <= 0 exit;
	if (!updateConveyorBreakProgress()) exit;   // also fixes issue #2 below
	
	for (var i = 0; i < array_length(Slots); i++)
	{
		var _slot = Slots[i];
		if (_slot == noone) continue;
		
		var _t = BeltTiles[i];
		var _pos = objGridSystem.tileToWorld(_t.row, _t.col);
		instance_create_layer(_pos.x, _pos.y, "Instances", objItemGem, { item: _slot.item });
	}
	
	if (instance_exists(objGridSystem))
	{
		for (var i = 0; i < array_length(BeltTiles); i++)
		{
			objGridSystem.removeFromGrid(BeltTiles[i].row, BeltTiles[i].col);
		}
	}
	
	dropItemLoot(DropItem, 1, false, true);
	instance_destroy();
	return true;
}


function rightClickPlaceBlock()
{
	if (!mouse_check_button_pressed(mb_right) || objPlayer.showInventory) return;
	
	var _item = objInventoryManager.inventory[3][objInventoryManager.hotbarIndex];
	if (_item == noone) return;
	
	if (_item.ItemID == "conveyor")
	{
		handleConveyorPlacementClick(_item);
		return;
	}
	
	var _tile = objGridSystem.getReachableTile(mouse_x, mouse_y);
	var _pos = objGridSystem.tileToWorld(_tile.row, _tile.col);
	
	if (tryPlaceHeldItem(_item, _pos.x, _pos.y))
	{
		if (_item.Count <= 0) objInventoryManager.inventory[3][objInventoryManager.hotbarIndex] = noone;
	}
}

// Two-click belt placement: first right-click sets the anchor, second
// confirms a straight run to it (≤12 tiles, all empty). Any invalid second
// click - wrong tile, too far, blocked, out of range - cancels the pending
// placement instead of placing anything.
function handleConveyorPlacementClick(_item)
{
	var _grid = objGridSystem;
	var _tile = _grid.getReachableTile(mouse_x, mouse_y);
	
	if (!_grid.isTileInBounds(_tile.row, _tile.col))
	{
		_grid.PendingConveyor = noone;
		return;
	}
	
	if (_grid.PendingConveyor == noone)
	{
		if (_grid.TileGrid[_tile.row][_tile.col] != noone) return; // occupied - ignore, no state to cancel
		_grid.PendingConveyor = { row: _tile.row, col: _tile.col, itemId: _item.ItemID };
		return;
	}
	
	var _anchor = _grid.PendingConveyor;
	
	if (_tile.row == _anchor.row && _tile.col == _anchor.col)
	{
		_grid.PendingConveyor = noone; // clicked the anchor again - cancel
		return;
	}
	
	var _sameRow = (_tile.row == _anchor.row);
	var _sameCol = (_tile.col == _anchor.col);
	var _valid = (_sameRow != _sameCol); // must be straight, not diagonal
	
	if (_valid)
	{
		var _length = (_sameRow ? abs(_tile.col - _anchor.col) : abs(_tile.row - _anchor.row)) + 1;
		if (_length > 12) _valid = false;
	}
	
	if (_valid)
	{
		var _rowStep = sign(_tile.row - _anchor.row);
		var _colStep = sign(_tile.col - _anchor.col);
		var _r = _anchor.row, _c = _anchor.col;
		
		while (true)
		{
			if (!_grid.isTileInBounds(_r, _c) || _grid.TileGrid[_r][_c] != noone)
			{
				_valid = false;
				break;
			}
			if (_r == _tile.row && _c == _tile.col) break;
			_r += _rowStep;
			_c += _colStep;
		}
	}
	
	if (_valid && _grid.placeConveyorBelt(_anchor.row, _anchor.col, _tile.row, _tile.col, _anchor.itemId))
	{
		_item.Count--;
		if (_item.Count <= 0) objInventoryManager.inventory[3][objInventoryManager.hotbarIndex] = noone;
	}
	
	_grid.PendingConveyor = noone;
}

function spawnAtRandomTileInRoom(_attempts)
{
	for (var i = 0; i < _attempts; ++i)
	{
		var _tileId = choose("stone", "twig");
		
		var _row = irandom_range(0, TileRows - 1);
		var _col = irandom_range(0, TileColumns - 1);
		
		var _pos = tileToWorld(_row, _col);
		if (collision_rectangle(_pos.x, _pos.y, _pos.x + TileSize, _pos.y + TileSize, objCollision, false, true) != noone) continue;
	
		placeTempTile(_row, _col, _tileId)
	}
}



function drawTileOutlineInfo()
{
	if (hovered) && (objPlayer.BreakSpeed > 0)
	{
		draw_set_colour(c_black)
		draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true)
	}
	
	var BreakLevel = (BreakProgress/BreakDuration) * sprite_get_number(sprBreakAnim) -1;
	if (BreakProgress > 0)
	{
		draw_sprite(sprBreakAnim, BreakLevel, x, y)
	}



	if global.debug
	{
		draw_set_halign(fa_center)
		draw_set_colour(c_white)
		draw_text(x + (sprite_get_width(sprite_index)/2), y, BreakProgress)
	}
}


///   // Create event
///   hp_bar = healthbar_create(hp); // hp = your entity's starting health, 0-100
///
///   // Draw / Draw GUI event
///   healthbar_draw(hp_bar, x1, y1, x2, y2, hp, c_black, c_red, c_lime, c_yellow, 0, true, true);
///
/// Only call healthbar_create() ONCE per bar (it holds the state that needs to
/// persist between frames). Call healthbar_draw() every frame you want it visible.

#macro HEALTHBAR_SHAKE_THRESHOLD     25  // lose this many percentage points in one hit to trigger a shake
#macro HEALTHBAR_SHAKE_DURATION      6  // frames the shake lasts for a hit right at the threshold
#macro HEALTHBAR_SHAKE_DURATION_MAX  40  // cap, so a near-kill hit doesn't shake forever
#macro HEALTHBAR_SHAKE_INTENSITY      1  // px offset for a hit right at the threshold
#macro HEALTHBAR_SHAKE_INTENSITY_MAX 10  // cap, so a near-kill hit doesn't fling the bar off screen


/// @description Creates the persistent state object for one health bar.
/// @param {real} _startamount  Starting value, 0-100 (default 100)
function healthbar_create(_startamount = 100) {
    return {
        amount      : _startamount, // true current value — this is what draws "instantly"
        trail       : _startamount, // the lagging trail colour, eases toward `amount`
        trail_speed : 0.08,         // 0-1 — how fast the trail catches up each frame (ease-out)
        hold_timer  : 0,            // internal — frames left before the trail starts draining
        hold_time   : 15,           // frames the trail "holds" in place right after damage

        shake_timer     : 0,        // internal — frames of shake left
        shake_duration  : 0,        // internal — duration in use for the current shake (for the decay %)
        shake_magnitude : 0         // internal — magnitude in use for the current shake
    };
}

/// @description Draws a health bar. Same core args as the stock draw_healthbar(),
/// plus damagecol and showsegments.
///
/// @param {struct} bar			Struct from healthbar_create()
/// @param {real} x1			left
/// @param {real} y1			top
/// @param {real} x2			right
/// @param {real} y2			bottom
/// @param {real} amount		current value, 0-100
/// @param {color} backcol		background colour
/// @param {color} mincol		colour at 0 health
/// @param {color} maxcol		colour at 100 health
/// @param {color} damagecol	colour of the trailing "damage taken" chunk
/// @param {real} direction		0 = anchor left, 1 = right, 2 = top, 3 = bottom
/// @param {bool} showback		draw the background?
/// @param {bool} showborder	draw a 1px black border?
/// @param {bool} showsegments	draw the 10% / 50% tick marks? (default true)
function healthbar_draw(bar, x1, y1, x2, y2, amount, backcol, mincol, maxcol, damagecol,
                         direction, showback, showborder, showsegments = true) {

    amount = clamp(amount, 0, 100);

    // ---- detect a heavy hit (compare against the value from last call, before we overwrite it) ----
    var damage_this_call = bar.amount - amount; // percentage points lost this call
    if (damage_this_call >= HEALTHBAR_SHAKE_THRESHOLD) {
        var over = damage_this_call - HEALTHBAR_SHAKE_THRESHOLD;
        bar.shake_magnitude = clamp(HEALTHBAR_SHAKE_INTENSITY + over * 0.4,
                                     HEALTHBAR_SHAKE_INTENSITY, HEALTHBAR_SHAKE_INTENSITY_MAX);
        bar.shake_duration = clamp(HEALTHBAR_SHAKE_DURATION + over * 0.6,
                                    HEALTHBAR_SHAKE_DURATION, HEALTHBAR_SHAKE_DURATION_MAX);
        bar.shake_timer = bar.shake_duration;
    }

    // ---- update the trail ----
    if (amount >= bar.trail) {
        // healing, or no change — snap up instantly, no drag
        bar.trail = amount;
        bar.hold_timer = 0;
    } else {
        if (amount < bar.amount) {
            bar.hold_timer = bar.hold_time; // fresh damage this call — (re)start the hold
        }
        if (bar.hold_timer > 0) {
            bar.hold_timer--;
        } else {
            bar.trail += (amount - bar.trail) * bar.trail_speed; // exponential ease-out
            if (abs(bar.trail - amount) < 0.15) bar.trail = amount;
        }
    }
    bar.amount = amount;

    // ---- shake offset (decays smoothly as shake_timer counts down) ----
    var shake_x = 0;
    var shake_y = 0;
    if (bar.shake_timer > 0) {
        var shake_pct = bar.shake_timer / bar.shake_duration; // 1 -> 0
        var mag = bar.shake_magnitude * shake_pct;
        shake_x = random_range(-mag, mag);
        shake_y = random_range(-mag, mag);
        bar.shake_timer--;
    }

    // shifted drawing coordinates — everything below draws with these instead of the raw args
    var dx1 = x1 + shake_x;
    var dy1 = y1 + shake_y;
    var dx2 = x2 + shake_x;
    var dy2 = y2 + shake_y;

    var w = x2 - x1;
    var h = y2 - y1;
    var vertical = (direction == 2) || (direction == 3);

    // ---- background ----
	if (showback)
	{
		draw_rectangle_color(dx1, dy1, dx2, dy2, backcol, backcol, backcol, backcol, false);
	}

	// ---- damage trail (drawn first so the health fill sits on top of it) ----
	if (bar.trail > amount) {
		var tr = __healthbar_fill_rect(dx1, dy1, dx2, dy2, bar.trail, direction);
		draw_rectangle_color(tr[0], tr[1], tr[2], tr[3], damagecol, damagecol, damagecol, damagecol, false);
	}

	// ---- health fill, colour lerped mincol -> maxcol by amount ----
	var healthcol = merge_color(mincol, maxcol, amount / 100);
	var hr = __healthbar_fill_rect(dx1, dy1, dx2, dy2, amount, direction);
	draw_rectangle_color(hr[0], hr[1], hr[2], hr[3], healthcol, healthcol, healthcol, healthcol, false);

	// ---- segment ticks: major every 50% ----
	if (showsegments) {
		for (var i = 50; i < 100; i += 50) {
			if (!vertical) {
				var tx = dx1 + w * (i / 100);
				draw_line_color(tx, dy1, tx, dy2, c_black, c_black);
			} else {
				var ty = dy1 + h * (i / 100);
				draw_line_color(dx1, ty, dx2, ty, c_black, c_black);
			}
		}
	}

	// ---- border ----
	if (showborder) {
		draw_rectangle_color(dx1, dy1, dx2, dy2, c_black, c_black, c_black, c_black, true);
	}
}

/// @description Internal — returns [fx1, fy1, fx2, fy2] for the filled chunk of the bar.
function __healthbar_fill_rect(x1, y1, x2, y2, pct, direction) {
    var w = x2 - x1;
    var h = y2 - y1;
    var t = pct / 100;
    switch (direction) {
        case 0: return [x1, y1, x1 + w * t, y2];  // anchored left, fills rightward
        case 1: return [x2 - w * t, y1, x2, y2];  // anchored right, fills leftward
        case 2: return [x1, y1, x2, y1 + h * t];  // anchored top, fills downward
        case 3: return [x1, y2 - h * t, x2, y2];  // anchored bottom, fills upward
    }
    return [x1, y1, x2, y2];
}


global.room_properties = {	
	rmTitleScrn: {
		enemies_spawn: false,
		nature_spawn: false
	},
	rmSoundSettings: {
		enemies_spawn: false,
		nature_spawn: false
	},
	rmStartMenu: {
		enemies_spawn: false,
		nature_spawn: false
	},
	rmInit: {
		enemies_spawn: false,
		nature_spawn: false
	},
	rmInnTree: {
		enemies_spawn: false,
		nature_spawn: false
	},
		
	rmGrass: {
		enemies_spawn: true,
		nature_spawn: true
	},
	rmCave_a: {
		enemies_spawn: true,
		nature_spawn: true
	}
};



/// @description Adds camera shake. Stacks with any shake already in progress, capped at 1.
/// @param _amount 0..1 — try ~0.3 for a hit landed, ~0.6-1 for something big (explosion, boss slam)
function cameraShake(_amount)
{
	with (objCameraManager)
	{
		trauma = clamp(trauma + _amount, 0, 1)
	}
}



function takeDamage(_amount, _debuff = -1, _heavy = false, _thorns = false)
{	
	if (!iFrames) && (state != PlayerState.ROLL)
	{

		id.debuff = _debuff;
		id.healthCurrent -= _amount;
		id.iFrames = true;
		id.alarm[1] = game_get_speed(gamespeed_fps);
		audio_play_sound(sndEnemyHurt, 1, false, 1, 0, random_range(0.8, 1.2))
		cameraShake(_amount/10)
		
		if _heavy
			if (other.source_enemy != noone)
			{
				var _knockDirection = point_direction(other.source_enemy.x, other.source_enemy.y, x, y)
				var _minimumBonus = min(_amount, 10)
				var _knockMultiplier = _minimumBonus * 0.4
		
				state = PlayerState.STUNNED
				direction = _knockDirection
				speed = 3 * (_knockMultiplier)
				friction = 0.4
			}
		
		if _thorns
		{
			with other
			{
				applyDamageFromPlayer(_amount/2)
			}
		};
		
		with objHealthBar
		{
			part_particles_create(global.partSystemHUD, random_range(bbox_left + healthbarX, bbox_right + healthbarX), random_range(bbox_top + healthbarY, bbox_bottom + healthbarY), global.particleTypeHealthLoss, 24)
		};
		
	};
	
};

function healPlayer(_target, _amount){
	
	if (_target.healthCurrent + _amount) > global.healthMax
	{
		_target.healthCurrent = global.healthMax;
	}
	else
	{
		_target.healthCurrent = _target.healthCurrent + _amount;
	}
	
	with objHealthBar
	{
		part_particles_create(global.partSystemHUD, random_range(bbox_left + healthbarX, bbox_right + healthbarX), random_range(bbox_top + healthbarY, bbox_bottom + healthbarY), global.particleTypeHealthGain, 16)
	}
}


function applyDamageFromPlayer(_damage){
	
	var _relativeToPlayer = point_direction(objPlayer.x, objPlayer.y, x, y)
	var _particleSpread = 30
	
	Health -= _damage
	direction = _relativeToPlayer
	speed = max(objPlayer.knockbackPower - Weight, 0)
	state = EnemyState.STUNNED
	instance_create_layer(x, y - (bbox_bottom - bbox_top)/2, "Attacks", objHitEffect)
	part_type_direction(global.particleTypeBasic, _relativeToPlayer, _relativeToPlayer + 30, 0, 0); //knockback
	part_particles_create(global.partSystem, x, y, global.particleTypeBasic, 6);
}

function applyRangedDamageFromPlayer(_damage, _multiplier = 1)
{
	Health -= (_damage * _multiplier)
	part_type_direction(global.particleTypeBasic, 0, 360, 0, 0); //knockback
	part_particles_create(global.partSystem, x, y, global.particleTypeBasic, 6);
}


/// @description Spawns a damage (or healing) number that reads the amount healed/damaged. _damageType format like "DamageType.DAMAGE" for example.
function numberParticle(_x, _y, _number, _damageType)
{
	instance_create_layer(_x, _y, "Particles", objNumberParticle, { type: _damageType, amount: _number});
}
	


function dropSmallEXP(_multiplier)
{
	for (var i = 0; i < _multiplier; ++i) {
		instance_create_layer(x, y, "Instances", objEXPSmall)
	}
}



/// @description	Will use a sine wave to oscillate the object. Higher "_speed" will make oscillations faster, higher "_displacement" will make the object move further.
function oscillate(_speed, _displacement){
	y = ystart + dsin(current_time * _speed) * _displacement
	
}


function init_airborne_properties(_z_gravity = 0.2, _bounce_multiplier = 0.4) {
	z = 0;              // Current height above the ground (0 = on the ground)
	z_speed = 0;        // Vertical velocity on the fake Z axis
	z_gravity = _z_gravity; // How fast gravity pulls the object down
	z_bounce = _bounce_multiplier; // How much energy it keeps when landing (0 = no bounce)
	is_airborne = false; // Flag to easily check if the asset is in the air
}


function update_airborne_physics() {
	// Only run physics if the object is elevated or moving upward
	if (z > 0 || z_speed != 0) {
		is_airborne = true;

		z_speed -= z_gravity;	// Apply downward gravity force
		z += z_speed;			// Adjust current altitude

		// Check if the object has hit or passed below ground level (z <= 0)
		if (z <= 0) {
			z = 0; // Snap to ground floor

			// if it has enough force left, make it bounce
			if (abs(z_speed) > 1.5) {
				z_speed = -z_speed * z_bounce; // Reverse force and reduce it
			} else {
				z_speed = 0; // Come to a complete stop
				is_airborne = false;
			}
		}
	} else {
		is_airborne = false;
	}
}


function launch_airborne(_upward_force) {
	z_speed = _upward_force; // + fake visual height
	is_airborne = true;
}


// Returns an array of {x, y} waypoints from (_startX,_startY) to (_targetX,_targetY),
// or an empty array if no path was found. Caller owns nothing extra to clean up.
function request_path(_startX, _startY, _targetX, _targetY)
{
	if (!instance_exists(objPathGridManager)) return [];
	
	var _tempPath = path_add();
	var _found = mp_grid_path(objPathGridManager.pathGrid, _tempPath, _startX, _startY, _targetX, _targetY, true);
	
	var _points = [];
	if (_found)
	{
		var _n = path_get_number(_tempPath);
		for (var i = 0; i < _n; i++)
		{
			array_push(_points, {
				x: path_get_point_x(_tempPath, i),
				y: path_get_point_y(_tempPath, i)
			});
		}
	}
	
	path_delete(_tempPath); // always free the scratch path resource
	return _points;
}


// Moves toward (_targetX, _targetY) by following a path, requesting/refreshing
// it as needed. _repathInterval = 0 means "static target, path once, don't
// recompute" - use this for roam points. Pass RepathInterval for moving
// targets (like a chasing player) so the route updates as they move.
// Returns true once the FULL path is complete (all waypoints reached).
function follow_path_to(_targetX, _targetY, _speed, _repathInterval)
{
	if (_repathInterval > 0)
	{
		repathTimer--;
		if (!hasPath || repathTimer <= 0)
		{
			currentPath = request_path(x, y, _targetX, _targetY);
			pathNodeIndex = 0;
			hasPath = (array_length(currentPath) > 0);
			repathTimer = _repathInterval;
		}
	}
	else if (!hasPath)
	{
		currentPath = request_path(x, y, _targetX, _targetY);
		pathNodeIndex = 0;
		hasPath = (array_length(currentPath) > 0);
	}

	if (!hasPath) return false; // no route found - caller decides what to do (e.g. pick a new roam point)

	if (pathNodeIndex >= array_length(currentPath))
	{
		hasPath = false;
		return true; // fully arrived
	}

	moveGoalX = currentPath[pathNodeIndex].x;
	moveGoalY = currentPath[pathNodeIndex].y;

	if (move_toward_goal(_speed))
	{
		pathNodeIndex++;
		if (pathNodeIndex >= array_length(currentPath))
		{
			hasPath = false;
			return true;
		}
	}

	return false;
}


// Picks a random nearby point and immediately tests it via the path grid.
// If unreachable, gives up quickly and retries shortly instead of committing
// to a destination the enemy can never actually get to.
function pick_roam_goal()
{
	var _dir = random(359);
	var _dist = random_range(16, RoamRadius);
	roamTargetX = x + lengthdir_x(_dist, _dir);
	roamTargetY = y + lengthdir_y(_dist, _dir);

	currentPath = request_path(x, y, roamTargetX, roamTargetY);
	pathNodeIndex = 0;
	hasPath = (array_length(currentPath) > 0);

	if (!hasPath)
	{
		alarm[2] = 15; // couldn't route there - try a different point soon rather than waiting out the full pause
	}
}


// Moves the instance toward (moveGoalX, moveGoalY) at _speed. Returns true once
// arrived (caller should then clear hasMoveGoal). Handles stuck-abandon internally.
function move_toward_goal(_speed)
{
	direction = point_direction(x, y, moveGoalX, moveGoalY);
	speed = _speed;
	
	if (point_distance(x, y, moveGoalX, moveGoalY) <= ArriveThreshold)
	{
		speed = 0;
		return true;
	}
	
	moveStuckTimer--;
	if (moveStuckTimer <= 0)
	{
		var _movedDist = point_distance(x, y, moveStuckCheckX, moveStuckCheckY);
		moveStuckTimer = StuckCheckInterval;
		moveStuckCheckX = x;
		moveStuckCheckY = y;
		
		if (_movedDist < StuckMinDistance)
		{
			speed = 0;
			return true;
		}
	}
	
	return false;
}




#region ENEMY LIBRARY

enum Enemy // Enemy name ids
{
	loggo,
	cellyEnemy
}

enum EnemyState // Enemy states pretty self explanatory tbh
{
	ROAMING,
	AGGRO,
	STUNNED,
	DISPLACED
}

enum EnemyAction
{
	NONE,
	ATTACKING,
	JUMPING
}

function createBasicEnemy(_enemyID, _enemyName, _sprite, _damage = 25, _range = 10, _attackInterval = 1, _touchDebuff = debuffType.NONE, _maxHealth = 20, _moveSpeed = 1, _knockbackResistance = 1, _AggroRange = 72, _ExpAmount = 1, _lootTable) constructor
{
	EnemyID = _enemyID;
	EnemyName = _enemyName;
	EnemySprite = _sprite;
	EnemyDamage = _damage;
	AttackRange = _range;
	AttackRate = _attackInterval * game_get_speed(gamespeed_fps);
	DamageDebuff = _touchDebuff;
	MaxHealth = _maxHealth;
	MoveSpeed = _moveSpeed;
	Weight = _knockbackResistance;
	AggroRange = _AggroRange;
	ExpAmount = _ExpAmount;
	Loot = _lootTable; // { itemId, chance, min, max }
}


function EnemyLibrary() // function that gets the information for all of the enemy structs
{
	static _enemyLibrary = undefined;
	if (is_undefined(_enemyLibrary))
	{
		_enemyLibrary = {
			loggo : new createBasicEnemy(
					Enemy.loggo,		// ID
					"Loggo",			// Name
					sprLoggo,			// Sprite
					5,					// Attack Damage
					1,					// Attack Range
					1,					// Attack Rate
					debuffType.NONE,	// Debuff
					20,					// Max Health
					1.2,				// MoveSpeed
					0.5,				// Weight  [0 = Feather] [1 = Heavy]
					72,					// AggroRange
					12,					// Exp Amount
					
				[			// Loot
					{ itemId: "wood",	chance: 0.8, min: 1, max: 1 },
					{ itemId: "stick",	chance: 0.6, min: 1, max: 2 },
				]
			),
			
			cellyEnemy : new createBasicEnemy(
					Enemy.cellyEnemy,		// ID
					"cellyEnemy",			// Name
					sprCellyEnemyIdle,		// Sprite
					5,						// Attack Damage
					16,						// Attack Range
					1,						// Attack Rate
					debuffType.NONE,		// Debuff
					20,						// Max Health
					0.9,						// MoveSpeed
					0.5,					// Weight  [0 = Feather] [1 = Heavy]
					72,						// AggroRange
					12,						// Exp Amount
					
				[			// Loot
					{ itemId: "thorn_ring",	chance: 0.1, min: 1, max: 1 },
				]
			),
			
		};
	};
	return _enemyLibrary;
};


function enemyLoot()
{
	var _table = EnemyDef.Loot;
	if (is_undefined(_table) || array_length(_table) <= 0) return;
	
	for (var k = 0; k < array_length(_table); k++)
	{
		var _entry = _table[k];
		if (random(1) > _entry.chance) continue;
		
		var _itemDef = global.itemDictionary[$ _entry.itemId];
		var _count = irandom_range(_entry.min, _entry.max);
		
		dropItemLoot(_itemDef, _count);
	}
}

///@description _enemyType is enum (eg Enemy.loggo)
function spawnEnemy(_enemyType, _x, _y)
{
	var _def = EnemyLibrary()[$ _enemyType];
	
	if (is_undefined(_def))
	{
		show_debug_message("spawn_enemy: no enemy definition found for " + string(_enemyType));
		return noone;
	}
	
	var _inst = instance_create_layer(_x, _y, "Instances", objBasicEnemy, { EnemyDef: _def});
	
	return _inst;
}

#endregion



#region Inventory save serialization

// Turns a rows x cols grid of item structs (or noone) into a compact array of {row, col, id, count},
function serializeInventoryGrid(_arr, _rows, _cols)
{
	var _data = [];
	
	for (var i = 0; i < _rows; i++)
	{
		for (var j = 0; j < _cols; j++)
		{
			var _item = _arr[i][j];
			if (_item == noone) continue;
			
			array_push(_data, {
				row: i,
				col: j,
				id: _item.ItemID,
				count: _item.Count
			});
		}
	}
	
	return _data;
}

// Rebuilds a rows x cols grid (filled with `noone`) from serialized slot data.
function deserializeInventoryGrid(_data, _rows, _cols)
{
	var _arr = array_create(_rows);
	for (var i = 0; i < _rows; i++)
	{
		_arr[i] = array_create(_cols, noone);
	}
	
	for (var k = 0; k < array_length(_data); k++)
	{
		var _entry = _data[k];
		var _def = global.itemDictionary[$ _entry.id];
		
		if (is_undefined(_def))
		{
			show_debug_message("deserializeInventoryGrid: unknown item id \"" + string(_entry.id) + "\", skipping");
			continue;
		}
		
		_arr[_entry.row][_entry.col] = cloneItem(_def, _entry.count);
	}
	
	return _arr;
}

function saveInventoryToFile()
{
	var _data = {
		inventory: serializeInventoryGrid(objInventoryManager.inventory, objInventoryManager.invRows, objInventoryManager.invColumns),
		chests: global.chestSaveData,
		tiles: global.placedTiles
	};
	
	var _json = json_stringify(_data, true);
	
	var _buffer = buffer_create(string_byte_length(_json) + 1, buffer_fixed, 1);
	buffer_write(_buffer, buffer_text, _json);
	buffer_save(_buffer, "save_inventory.json");
	buffer_delete(_buffer);
}

// Reads save_inventory.json into a staging global. objInventoryManager's Create event applies it
// once it exists — its arrays and global.itemDictionary aren't guaranteed to exist yet at the
// point loadGame() runs (same instance-order issue as the chest system).
function loadInventoryFromFile()
{
	global.pendingInventoryLoad = noone;
	global.chestSaveData = {}; // default: nothing looted yet
	global.placedTiles = {};
	
	if (!file_exists("save_inventory.json")) return;
	
	var _buffer = buffer_load("save_inventory.json");
	var _raw = buffer_read(_buffer, buffer_text);
	buffer_delete(_buffer);
	
	var _data = json_parse(_raw);
	global.pendingInventoryLoad = _data;
	
	if (variable_struct_exists(_data, "chests")) {global.chestSaveData = _data.chests;}
	if (variable_struct_exists(_data, "tiles")) {global.placedTiles = _data.tiles;}
}

#endregion

function saveAlert()
{
	// show_debug_message("save should appear ig");
	instance_create_layer(0, 0, "HUD_Elements", objGameSaved)
}



#region Menu Functions

function menu(_x_offset, _y_offset, _options, _description = -1)
{
	with (instance_create_layer(0, 0, "HUD_Elements", objMenu))
	{
		options = _options;
		description = _description;
		optionsCount = array_length(_options);
		hovermarker = "* ";
		x_offset = _x_offset;
		y_offset = _y_offset;
		
		// Set up size
		margin = 9;
		draw_set_font(fontSmall);
		
		width = 1;
		if (description != -1) width = max(width, string_width(_description));
		for (var i = 0; i < optionsCount; i++)
		{
			width = max(width, string_width(_options[i][0]));
		}
		width += string_width(hovermarker);
		
		heightLine = 17;
		height = heightLine * (optionsCount + !(description == -1));
		
		widthFull = width + margin * 2;
		heightFull = height + margin * 2;
		show_debug_message($"desc: {description} | optionsCount: {optionsCount} | heightFull: {heightFull}");
	}
}





function mainMenu()
{
	if file_exists("save_file.ini")
		menu
		(0, 0,
			[
				["Continue", loadGame],
				["New Game", newGame],
				["Settings", settingsMenu],
				["Quit", function()
							{areYouSure(game_end, mainMenu)}]
			],
			"Main Menu"
		);
	else
		menu
		(0, 0,
			[
				["New Game", loadGame],
				["Settings", settingsMenu],
				["Quit", function()
							{areYouSure(game_end, mainMenu)}]
			],
			"Main Menu"
		);
}


function settingsMenu()
{
	menu (0, 0,
		[
			["Sound Settings", function()
							{room_goto(rmSoundSettings)}],
			["Video Settings" , mainMenu],
			["Back", mainMenu],
		],
		"Settings"
	);
}


function equipmentMenu()
{
	if !instance_exists(objEquipmentManager) exit;
	objEquipmentManager.equipmentOpen = !objEquipmentManager.equipmentOpen;
}


function soundMenu()
{
	menu(0, camera_get_view_height(view_camera)/4,
		[
			["Confirm", UpdateSoundSettings]
		]
	);
}



function areYouSure(_targetFunction = -1, _prevMenu = -1)
{
	menu (0, 0,
	[
		["Yes", _targetFunction],
		["No", _prevMenu]
	],
	"Are you sure?");
}


function pauseMenu()
{
	menu (0, 0,		
		[
			["Resume", -1],
			["Stats", -1],
			["Save Game", saveGame],
			["Quit to Title", function()
								{areYouSure(game_restart, pauseMenu)}]
		],
		"Menu"
	);
}



function fastTravelMenu()
{
	var leftSideScreen = (-camera_get_view_width(view_camera) / 2);
	var xOffset = 40;
	var yOffset = 0;
	
	var menuOptions = [];
	
	for (var i = 1; i <= 10; i++)
	{
		if (global.Location[i] == true)
		{
			//dynamic function that remembers the "i" count to apply to the location ID
			var _travelFunction = method({ loc_id: i }, function()
			{
				travelToLocation(loc_id);
			});
			
			show_debug_message(string(_travelFunction))

			array_push(menuOptions, ["Location " + string(i), _travelFunction]);
		}
	}
	
	array_push(menuOptions, ["Cancel", -1]);

	menu(
		leftSideScreen + xOffset,	// x
		0 + yOffset,				// y
		menuOptions,				// done in array ^^
		
		"Fast Travel"
	);
}

// travelToLocation() itself now lives further down, next to teleportPlayer() —
// fastTravelMenu() just calls it by name, so it doesn't matter that the
// definition is physically elsewhere in the file.

#endregion


#region // save system

function saveGame(){
	ini_open("save_file.ini")
	
	var write_int = function(section, key, value)
	{
		ini_write_string(section, key, string_format(value, 0, 0));
	}

		write_int("Room", "Room", room)

		write_int("Stats", "Health", global.healthMax);
		write_int("Stats", "Stamina", global.staminaMax);
		write_int("Stats", "Money", global.playerMoney);
		write_int("Stats", "Level", global.playerLevel);
		write_int("Stats", "EXP", global.playerXP);
		write_int("Stats", "NextLvlUp", global.expRequiredLvlUP);
		write_int("Stats", "Strength", global.playerStrength);
		write_int("Stats", "Knockback", global.playerKnockback);
		write_int("Stats", "Speed", global.playerSpeed);
			
		write_int("Coordinates", "x", objPlayer.x);
		write_int("Coordinates", "y", objPlayer.y);
		
		
		// Unlocked fast travel locations
		write_int("Locations", "Location 1", global.Location[1]);
		write_int("Locations", "Location 2", global.Location[2]);
		write_int("Locations", "Location 3", global.Location[3]);
		write_int("Locations", "Location 4", global.Location[4]);
		write_int("Locations", "Location 5", global.Location[5]);
		write_int("Locations", "Location 6", global.Location[6]);
		write_int("Locations", "Location 7", global.Location[7]);
		write_int("Locations", "Location 8", global.Location[8]);
		write_int("Locations", "Location 9", global.Location[9]);
		write_int("Locations", "Location 10", global.Location[10]);
		

		ini_close()
		
		saveInventoryToFile()
		
		saveAlert()
		
}


function loadGame()
{
	loadInventoryFromFile()
	
	if file_exists("save_file.ini")
	{
		ini_open("save_file.ini")
	
		global.playerBenched = ini_read_real("PlayerState", "playerBenched", false)

		global.healthMax		= ini_read_real("Stats", "Health", 20);
		global.staminaMax		= ini_read_real("Stats", "Stamina", 20);
		global.playerMoney		= ini_read_real("Stats", "Money", 0);
		global.playerLevel		= ini_read_real("Stats", "Level", 0);
		global.playerXP			= ini_read_real("Stats", "EXP", 0);
		global.expRequiredLvlUP = ini_read_real("Stats", "NextLvlUp", 100);
		global.playerStrength	= ini_read_real("Stats", "Strength", 5);
		global.playerSpeed		= ini_read_real("Stats", "Speed", 1);
		global.playerKnockback	= ini_read_real("Stats", "Knockback", 2);	
	
		playerSpawnX = ini_read_real("Coordinates", "x", 0);
		playerSpawnY = ini_read_real("Coordinates", "y", 0);
	
		targetRoom = (ini_read_real("Room", "Room", rmCave_a))
		
		
		global.Location[1]		= ini_read_real("Locations", "Location 1", false);
		global.Location[2]		= ini_read_real("Locations", "Location 2", false);
		global.Location[3]		= ini_read_real("Locations", "Location 3", false);
		global.Location[4]		= ini_read_real("Locations", "Location 4", false);
		global.Location[5]		= ini_read_real("Locations", "Location 5", false);
		global.Location[6]		= ini_read_real("Locations", "Location 6", false);
		global.Location[7]		= ini_read_real("Locations", "Location 7", false);
		global.Location[8]		= ini_read_real("Locations", "Location 8", false);
		global.Location[9]		= ini_read_real("Locations", "Location 9", false);
		global.Location[10]		= ini_read_real("Locations", "Location 10", false);
		
		ini_close()
		
		spawnPlayerAndSetup(playerSpawnX, playerSpawnY, targetRoom)
		
	} else
	{
		global.playerBenched = false
	
		global.healthMax = 20
		global.staminaMax = 20
		global.playerMoney = 0
		global.playerLevel = 0
		global.playerXP = 0
		global.expRequiredLvlUP = 100
		global.playerStrength = 5
		global.playerSpeed = 1
		global.playerKnockback = 2
		
		global.SFX_vol = 1
		global.Music_vol = 1
		
		global.Location[1] = false
		global.Location[2] = false
		global.Location[3] = false
		global.Location[4] = false
		global.Location[5] = false
		global.Location[6] = false
		global.Location[7] = false
		global.Location[8] = false
		global.Location[9] = false
		global.Location[10] = false
		

		
		playerSpawnX = 480 // Default Location for Game Beginning
		playerSpawnY = 336 // ^^^
		
		targetRoom = (rmCave_a)

		
		spawnPlayerAndSetup(playerSpawnX, playerSpawnY, targetRoom)
	}
}


/// @description Single entry point for every room transition. Sets where the
/// player will land, and either fades to black first or cuts straight there.
/// @param _room   target room
/// @param _x      target x in that room
/// @param _y      target y in that room
/// @param _fade   true = fade out/in (normal case). false = instant cut (only used for the very first spawn, where there's nothing to fade from).
function teleportPlayer(_room, _x, _y, _fade = true)
{
	with (objPlayer)
	{
		targetRoom = _room;
		target_x = _x;
		target_y = _y;
		state = PlayerState.TRANSITIONING;
	}

	if (_fade)
		instance_create_depth(0, 0, -999999, objFadeOut);
	else
		room_goto(rmInit);
}


function roomSetup()
{
	if !instance_exists(objHealthBar)
		instance_create_layer(0, 0, "HUD_Elements", objHealthBar);

	if !instance_exists(objStaminaBar)
		instance_create_layer(0, 0, "HUD_Elements", objStaminaBar);

	if !instance_exists(objEXPBar)
		instance_create_layer((camera_get_view_width(view_camera) - 16), 0, "HUD_Elements", objEXPBar);

	objPlayer.state = PlayerState.IDLE;
	global.cutsceneMovelock = false; // guarantees this clears even when
	                                  // Alarm 5 exited early because we were still TRANSITIONING
}


function spawnPlayerAndSetup(_spawnX, _spawnY, _room)
{
	if (!instance_exists(objPlayer))
		instance_create_layer(_spawnX, _spawnY, "Instances", objPlayer);

	instance_create_depth(_spawnX, _spawnY, -999999, objFadeIn); // covers the boot-up reveal
	teleportPlayer(_room, _spawnX, _spawnY, false); // no fadeOut needed, nothing to fade from yet
}


// Data instead of a hand-written switch case per location. Add a new spot by
// adding a row here — no new code needed.
global.fastTravelDestinations = {
	"1" : { room: rmGrass,  x: 376, y: 136 },
	"2" : { room: rmCave_a, x: 432, y: 288 },
	// 3-10 unused so far — add as locations get unlocked
};


function travelToLocation(_id)
{
	var _dest = global.fastTravelDestinations[$ string(_id)];
	if (is_undefined(_dest))
	{
		show_debug_message("travelToLocation: no destination registered for id " + string(_id));
		return;
	}
	teleportPlayer(_dest.room, _dest.x, _dest.y, true);
}

function newGame()
{
	if file_exists("save_file.ini")
	{
		file_delete("save_file.ini")
		
		if file_exists("save_inventory.json")
			file_delete("save_inventory.json")
			
		loadGame()
	} else
	menu(0, 0,
	[
		["Ok", game_restart]
	],
	
	"File not found"
	)
}

#endregion
