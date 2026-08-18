x = objPlayer.x
y = objPlayer.y - 14

draw_set_alpha(1)
draw_set_colour(c_lime)
if global.debug
draw_self()
//draw_rectangle((objPlayer.x - sprite_width/2), (objPlayer.y - sprite_height/2), (objPlayer.x + sprite_width/2), (objPlayer.y + sprite_height/2), false)