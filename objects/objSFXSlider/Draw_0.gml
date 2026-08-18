draw_set_colour(c_white)

var _colBlend = c_white;




draw_healthbar(x - sW, y - sH, x + sW, y + sH, SFXvolume * 100, c_dkgrey, _colBlend, _colBlend, 0, true, false);
draw_sprite_ext(sprite_index, 0, x, y, 1, 1, 0, _colBlend, 1);

draw_set_halign(fa_right);
draw_text(bbox_left - 4, y + textPadding_y, string(round(SFXvolume * 100)) + "%");

if (round(SFXvolume * 100)) == 69
draw_text(bbox_left - 23, y + textPadding_y, "SEX -");
else
draw_text(bbox_left - 23, y + textPadding_y, "SFX -");


if (hovered) _colBlend = c_ltgrey;
if (dragging) _colBlend = c_grey;
var _knobX = (x - sW + 1) + SFXvolume * range;
draw_sprite_ext(sprVolumeKnob, 0, _knobX, y, 1, 1, 0, _colBlend, 1);

draw_set_halign(fa_left);