// objSFXSlider Step event

if (dragging)
{
	var _inner_left  = x - sW + 1;
	var _inner_right = x + sW - 1;

	var _mx = clamp(mouse_x, _inner_left, _inner_right);

	Musicvolume = (_mx - _inner_left) / range;

	audio_group_set_gain(SFX, Musicvolume);

	if (mouse_check_button_released(mb_left))
	{
		dragging = false;
		global.Music_vol = Musicvolume;
		audio_play_sound(sndXPOrb, 1, false, Musicvolume);
	}
}