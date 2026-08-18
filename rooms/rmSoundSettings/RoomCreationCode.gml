var slider_x = camera_get_view_width(view_camera)*0.75;
var slider_y = 24;
var padding = 12 // for the knob, + general spacing
var offset = sprite_get_height(sprVolumeSlider)

var padoff = padding + offset

instance_create_layer(slider_x, slider_y, "HUD_Elements", objSFXSlider);
instance_create_layer(slider_x, slider_y+padoff, "HUD_Elements", objMusSlider);

soundMenu()

