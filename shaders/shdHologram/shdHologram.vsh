//
// shdHologram.vsh
// Vertex shader: passthrough + a little glitch jitter on X
//

attribute vec3 in_Position;
attribute vec4 in_Colour;
attribute vec2 in_TextureCoord;

varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec2 v_vLocalPos; // 0..1 local position for use in fragment shader

uniform float u_time;
uniform float u_glitchAmount; // 0 = off, try 1.5 - 4.0 (pixels)

void main()
{
    vec4 object_space_pos = vec4(in_Position.x, in_Position.y, in_Position.z, 1.0);

    // Cheap horizontal glitch: only kicks in on some "rows" (based on v coord),
    // driven by a fast pseudo-random wobble over time.
    float rowSeed = fract(sin(in_TextureCoord.y * 91.7 + floor(u_time * 6.0)) * 43758.5453);
    float glitchBand = step(0.93, rowSeed); // most rows = 0, occasional row = 1
    float wobble = sin(u_time * 40.0 + in_TextureCoord.y * 50.0);

    object_space_pos.x += glitchBand * wobble * u_glitchAmount;

    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;

    v_vColour = in_Colour;
    v_vTexcoord = in_TextureCoord;
    v_vLocalPos = in_TextureCoord; // sprites are usually already 0..1 UV
}
