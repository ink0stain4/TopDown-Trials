//objEntityManager step

if (alarm[0] > 1) exit;
var CamX = camera_get_view_x(view_camera);
var CamY = camera_get_view_y(view_camera);
var CamWidth = camera_get_view_width(view_camera);
var CamHeight = camera_get_view_height(view_camera);

var offset = 64

var _current_rules = global.room_properties[$ room_get_name(room)];
if (_current_rules.enemies_spawn == false) exit;

var BulkSpawnAmount = (irandom_range(2, 4))

for (var i = 0; i < BulkSpawnAmount; ++i)
{
	if (instance_number(objBasicEnemy) >= BasicEnemyCap) break; // entity cap
	
	var Edge, SpawnX, SpawnY
	var Attempts = 0;
	var Blocked = true; // my solution to stop spawning enemies inside walls
	
	while (Blocked && Attempts < 10)
	{
		Edge = irandom(3)
	
		switch (Edge)
		{
			case 0: //top
				SpawnX = random_range(CamX - offset, CamX + CamWidth + offset);
				SpawnY = CamY - offset;
			break;
		
			case 1: //right
				SpawnX = CamX + CamWidth + offset;
				SpawnY = random_range(CamY - offset, CamY + CamHeight + offset);
			break;
		
			case 2: //bottom
				SpawnX = random_range(CamX - offset, CamX + CamWidth + offset);
				SpawnY = CamY + CamHeight + offset;
			break;
				
			case 3: //left
				SpawnX = CamX - offset;
				SpawnY = random_range(CamY - offset, CamY + CamHeight + offset);
			break;
		}
	
		var OutOfBounds = (SpawnX < 0) || (SpawnX > room_height) || (SpawnY < 0) || (SpawnY > room_width);
		
		Blocked = collision_point(SpawnX, SpawnY, objCollision, true, true) != noone
       || collision_point(SpawnX, SpawnY, objPlayerBlocker, true, true) != noone
       || OutOfBounds;
		Attempts++;
	}
	
	if (Blocked) continue; // give up on this spawn so skip to next in the loop
	
	spawnEnemy("loggo", SpawnX, SpawnY)
}