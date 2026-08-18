#region Particle Types

// Blood Effect
var _ptype1 = part_type_create();
part_type_shape(_ptype1, pt_shape_line);
part_type_size(_ptype1, 0.1, 0.15, 0, 0);
part_type_scale(_ptype1, 0.25, 0.3);
part_type_speed(_ptype1, 2, 6, -0.1, 0);
part_type_orientation(_ptype1, 0, 0, 0, 0, true);
part_type_colour1(_ptype1, c_white);
part_type_alpha3(_ptype1, 1, 1, 0);
part_type_blend(_ptype1, false);
part_type_life(_ptype1, 10, 20);

global.particleTypeBasic = _ptype1;


// Trail Particle

var _ptype2 = part_type_create();

part_type_shape(_ptype2, pt_shape_pixel);
part_type_life(_ptype2, 5, 15);
part_type_size(_ptype2, 0.8, 1.2, -0.06, 0.01);
part_type_colour2(_ptype2, c_white, c_aqua);
part_type_alpha3(_ptype2, 1, 1, 0);

global.particleTypeExpTrail = _ptype2;


// Exp Bar Gain TRAIL Particles

var _ptype3_trail = part_type_create();

part_type_shape(_ptype3_trail, pt_shape_pixel)
part_type_life(_ptype3_trail, 2, 3);
part_type_gravity(_ptype3_trail, 0.2, 270);
part_type_orientation(_ptype3_trail, 0, 0, 0, 0, true);
part_type_size(_ptype3_trail, 0.8, 1, -0.005, 0.001);
part_type_colour2(_ptype3_trail, c_white, c_aqua);
part_type_alpha2(_ptype3_trail, 1, 0);

global.particleTypeExpBarTRAIL = _ptype3_trail



// Exp Bar Gain Particles

var _ptype3 = part_type_create();

part_type_shape(_ptype3, pt_shape_pixel);
part_type_life(_ptype3, 5, 15);
part_type_speed(_ptype3, 1, 2, 0, 0);
part_type_direction(_ptype3, 0, 360, 0, 0)
part_type_gravity(_ptype3, 0.2, 270);
part_type_size(_ptype3, 0.5, 0.8, -0.005, 0.001);
part_type_colour2(_ptype3, c_white, c_aqua);
part_type_alpha3(_ptype3, 1, 1, 0);

//// Make it every frame
part_type_step(_ptype3, 1, global.particleTypeExpBarTRAIL)

global.particleTypeExpBar = _ptype3;



// Health Bar Gain Particles

var _ptype4 = part_type_create();

part_type_sprite(_ptype4, sprHeart, false, false, false)
part_type_life(_ptype4, 30, 40);
part_type_speed(_ptype4, 2, 4, 0, 0);
part_type_direction(_ptype4, 0, 180, 0, 0)
part_type_gravity(_ptype4, 0.2, 270);
part_type_size(_ptype4, 0.05, 0.15, -0.005, 0.001);
part_type_colour2(_ptype4, c_white, $00A651);
part_type_alpha3(_ptype4, 1, 1, 0);

global.particleTypeHealthGain = _ptype4;


// Health Orb Trail Particles

var _ptype5 = part_type_create();

part_type_shape(_ptype5, pt_shape_star);
part_type_life(_ptype5, 5, 15);
part_type_speed(_ptype5, 1, 2, 0, 0);
part_type_direction(_ptype5, 0, 180, random_range(-10, 10), 0)
part_type_gravity(_ptype5, 0.05, 270);
part_type_size(_ptype5, 0.02, 0.05, -0.005, 0.001);
part_type_colour2(_ptype5, c_white, $00A651);
part_type_alpha3(_ptype5, 1, 1, 0);

global.particleTypeHealthTrail = _ptype5;


// Health Bar loss Particles

var _ptype6 = part_type_create();

part_type_shape(_ptype6, pt_shape_pixel)
part_type_life(_ptype6, 40, 60);
part_type_speed(_ptype6, 1, 3, 0, 0);
part_type_direction(_ptype6, 0, 180, 0, 0)
part_type_gravity(_ptype6, 0.1, 270);
part_type_size(_ptype6, 1, 2, -0.05, 0.001);
part_type_colour2(_ptype6, c_red, c_maroon);
part_type_alpha3(_ptype6, 1, 1, 0);

global.particleTypeHealthLoss = _ptype6;


#endregion