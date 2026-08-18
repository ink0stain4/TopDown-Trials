sW = sprite_get_width(sprite_index)/2
sH = sprite_get_height(sprite_index)/2

textPadding_x = 4
textPadding_y = -4

Musicvolume = global.Music_vol

hovered = false
dragging = false

range = (sW - 1) * 2 // functional drag length, border excluded, derived from sprite width

audio_group_set_gain(SFX, Musicvolume)