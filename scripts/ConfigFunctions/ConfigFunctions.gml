function ConfigSave()
{
	var _filename = working_directory + "config.txt";
	
	var _file = file_text_open_write(_filename);
	
	// Write config data
	file_text_write_string(_file, "[[CONFIG]]");
	file_text_writeln(_file);
	file_text_writeln(_file);
	file_text_write_string(_file, "(SFX Volume)");
	file_text_writeln(_file);
	file_text_write_real(_file, global.SFX_vol);
	file_text_writeln(_file);
	file_text_writeln(_file);
	file_text_write_string(_file, "(Music Volume)");
	file_text_writeln(_file);
	file_text_write_real(_file, global.Music_vol);
	file_text_writeln(_file);
	file_text_writeln(_file);

	file_text_close(_file);
	
	audio_group_set_gain(SFX, global.SFX_vol)
	audio_group_set_gain(Music, global.Music_vol)
}


function ConfigLoad()
{
	var _filename = working_directory + "config.txt";
	
	if (file_exists(_filename))
	{
	
		var _file = file_text_open_read(_filename);
	
		file_text_readln(_file);
		file_text_readln(_file);
		file_text_readln(_file);
		
		global.SFX_vol = file_text_read_real(_file);
		
		file_text_readln(_file);
		file_text_readln(_file);
		file_text_readln(_file);
		
		global.Music_vol = file_text_read_real(_file);
		
		audio_group_set_gain(SFX, global.SFX_vol)
		audio_group_set_gain(Music, global.Music_vol)
	}
	else
	{
		global.SFX_vol = 0.5;
		global.Music_vol = 0.5;
		
		audio_group_set_gain(SFX, global.SFX_vol)
		audio_group_set_gain(Music, global.Music_vol)
	}
}



function UpdateSoundSettings()
{
	if !(audio_group_is_loaded(SFX)) audio_group_load(SFX);
	if !(audio_group_is_loaded(Music)) audio_group_load(Music);
	
	room_goto(rmStartMenu) // return to menu
	
	ConfigSave()
}
