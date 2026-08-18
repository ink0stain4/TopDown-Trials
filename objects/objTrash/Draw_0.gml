//objTrash draw event

draw_sprite(sprite_index, -1, x, y)

if (trash_open)
{
	image_speed = 1
}
else
{
	image_speed = 0
	image_index = 0
}

drawTileOutlineInfo()

