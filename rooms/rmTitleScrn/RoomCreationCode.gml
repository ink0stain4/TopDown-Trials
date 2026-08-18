display_set_gui_size(640, 360);

if (!audio_group_is_loaded(SFX))
	audio_group_load(SFX)

if (!audio_group_is_loaded(Music))
	audio_group_load(Music)
	

ConfigLoad()