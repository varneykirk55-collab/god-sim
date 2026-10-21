shader_type spatial;
render_mode specular_schlick_ggx, diffuse_lambert, cull_back;

varying vec3 wpos;
varying vec3 wnorm;

void vertex() {
	wpos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	wnorm = normalize((MODEL_MATRIX * vec4(NORMAL, 0.0)).xyz);
}

void fragment() {
	vec3 col = COLOR.rgb;
	float slope = 1.0 - clamp(wnorm.y, 0.0, 1.0);
	vec3 rock = vec3(0.40, 0.36, 0.32);
	col = mix(col, rock, smoothstep(0.36, 0.74, slope));
	if (wpos.y < 0.62 && wpos.y > -0.08) {
		float sand_f = 1.0 - smoothstep(0.12, 0.62, wpos.y);
		col = mix(col, vec3(0.86, 0.76, 0.52), sand_f * (1.0 - slope * 0.85));
	}
	if (wpos.y > 9.5) {
		float snow = smoothstep(9.5, 13.0, wpos.y);
		col = mix(col, vec3(0.93, 0.95, 0.98), snow * (1.0 - slope * 0.3));
	}
	ALBEDO = col;
	ROUGHNESS = 0.90;
	SPECULAR = 0.08;
	NORMAL_MAP_DEPTH = 0.0;
}
