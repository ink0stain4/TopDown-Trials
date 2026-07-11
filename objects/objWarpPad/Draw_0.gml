draw_self()

var detected = objPlayer.interactableInRange

if (detected != noone)
{
	
	draw_sprite(sprPrompt_Space, 0, detected.x + promptOffsetX, detected.y + promptOffsetY)
}