//objPathGridManager Create

PathCellSize = 8; // twice as precise as the regular tilesize so tiny objects can be avoided too.
pathGrid = noone;

// Rebuilds pathGrid from scratch based on every current objBlockerParent
// instance. Call this at Room Start, AND any time a blocker is placed or
// removed at runtime (block placement/breaking) - mp_grid has no concept of
// "which blocker owns this cell," so a full rebuild is the only safe way to
// keep it in sync once the world changes after the room has loaded.
function rebuild_path_grid()
{
	if (pathGrid != noone) mp_grid_destroy(pathGrid);
	
	var _cols = ceil(room_width / PathCellSize);
	var _rows = ceil(room_height / PathCellSize);
	pathGrid = mp_grid_create(0, 0, _cols, _rows, PathCellSize, PathCellSize);
	
	var _agentPad = 6; // tune to your widest tracking enemy's bbox half-width
	
	with (objBlockerParent)
	{
		var _l = bbox_left   - _agentPad;
		var _t = bbox_top    - _agentPad;
		var _r = bbox_right  + _agentPad;
		var _b = bbox_bottom + _agentPad;
		
		var _c0 = floor(_l / other.PathCellSize);
		var _c1 = floor(_r / other.PathCellSize);
		var _r0 = floor(_t / other.PathCellSize);
		var _r1 = floor(_b / other.PathCellSize);
		
		for (var _cx = _c0; _cx <= _c1; _cx++)
		{
			for (var _cy = _r0; _cy <= _r1; _cy++)
			{
				mp_grid_add_cell(other.pathGrid, _cx, _cy);
			}
		}
	}
}