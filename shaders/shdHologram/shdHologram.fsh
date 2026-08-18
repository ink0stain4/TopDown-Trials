//
// shdHologram.fsh
// Fragment shader: fakes fresnel-rim + scanlines + flicker + colour tint
// No normals needed - "fresnel" is approximated from the sprite's own alpha edges.
//

varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec2 v_vLocalPos;

uniform float u_time;
uniform vec3  u_hologramColor;		// e.g. (0.1, 0.9, 1.0) for cyan
uniform float u_rimStrength;		// 0.5 - 3.0, how bright the edge glow is
uniform vec2  u_texelSize;			// 1.0 / sprite_width, 1.0 / sprite_height
uniform float u_scanlineSpeed;		// e.g. 2.0
uniform float u_scanlineDensity; // e.g. 40.0 - 120.0 (higher = thinner lines)
uniform float u_scanlineStrength;	// 0.0 - 1.0
uniform float u_flickerAmount;		// 0.0 - 0.3
uniform float u_baseAlpha;			// overall translucency, e.g. 0.55

float hash(float n)
{
	return fract(sin(n) * 43758.5453123);
}

void main()
{
	vec4 tex = texture2D(gm_BaseTexture, v_vTexcoord);
	float mask = tex.a;

	if (mask <= 0.001)
	{
		discard;
	}

    // --- Fake fresnel / rim glow ---
    // Sample alpha at neighbouring texels; the more alpha changes,
    // the closer we are to a silhouette edge -> brighten like a rim light.
    float aL = texture2D(gm_BaseTexture, v_vTexcoord - vec2(u_texelSize.x, 0.0)).a;
    float aR = texture2D(gm_BaseTexture, v_vTexcoord + vec2(u_texelSize.x, 0.0)).a;
    float aU = texture2D(gm_BaseTexture, v_vTexcoord - vec2(0.0, u_texelSize.y)).a;
    float aD = texture2D(gm_BaseTexture, v_vTexcoord + vec2(0.0, u_texelSize.y)).a;

    float edge = abs(mask - aL) + abs(mask - aR) + abs(mask - aU) + abs(mask - aD);
    float rim = clamp(edge * u_rimStrength, 0.0, 1.5);

    // --- Scanlines (scrolling over time) ---
    float scan = sin(v_vLocalPos.y * u_scanlineDensity - u_time * u_scanlineSpeed);
    scan = pow(scan * 0.5 + 0.5, 3.0);
    float scanFactor = mix(1.0, scan, u_scanlineStrength);

    // --- Flicker ---
    float flickerNoise = hash(floor(u_time * 18.0));
    float flicker = 1.0 - u_flickerAmount * flickerNoise;

    // --- Combine colour ---
    // Base tint replaces most of the original colour (holograms read as flat-lit),
    // but we keep a little of the source luminance so shapes still read.
    float luminance = dot(tex.rgb, vec3(0.299, 0.587, 0.114));
    vec3 baseColor = u_hologramColor * (0.6 + luminance * 0.4);
    vec3 finalColor = baseColor + u_hologramColor * rim;

    float alpha = mask * u_baseAlpha * scanFactor * flicker;
    alpha = clamp(alpha + rim * 0.4, 0.0, 1.0); // rim pokes through a bit brighter/more opaque

    gl_FragColor = vec4(finalColor * v_vColour.rgb, alpha);
}
