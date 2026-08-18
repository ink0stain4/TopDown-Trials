// objSFXSlider Step event

if (dragging)
{
	var _inner_left  = x - sW + 1;
	var _inner_right = x + sW - 1;

	var _mx = clamp(mouse_x, _inner_left, _inner_right);

	SFXvolume = (_mx - _inner_left) / range; // no pixel snapping, so every percent is reachable while dragging

	audio_group_set_gain(SFX, SFXvolume);

	if (mouse_check_button_released(mb_left))
	{
		dragging = false;
		global.SFX_vol = SFXvolume;
		audio_play_sound(sndXPOrb, 1, false, SFXvolume);
	}
}