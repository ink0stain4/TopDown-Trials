// objTrash step

UpdateBreakableTile()

if trash_open
{
	if !trash_item_dropped
	{
		// open can
		if image_index < 6
		{
			image_speed = 1;
		}
		else
		{
			image_index = 6;
			image_speed = 0;
		}
	}
	else
	{
		// item dropped in dabin
		image_speed = 1;
	}
}