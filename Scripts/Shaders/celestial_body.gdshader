shader_type canvas_item;
render_mode unshaded;

uniform float rotation : hint_range(0.0, 6.28) = 0.0;
uniform float time_speed : hint_range(0.0, 1.0) = 0.2;
uniform vec4 colors[6] : source_color;
uniform float size = 50.0;
uniform int OCTAVES : hint_range(0, 20, 1);
uniform float seed: hint_range(1, 10);

float rand(vec2 coord) {
	// land has to be tiled
	// tiling only works for integer values, thus the rounding
	// it would probably be better to only allow integer sizes
	// multiply by vec2(2,1) to simulate planet having another side
	coord = mod(coord, vec2(2.0,1.0)*round(size));
	return fract(sin(dot(coord.xy ,vec2(12.9898,78.233))) * 43758.5453 * seed);
}

float noise(vec2 coord){
	vec2 i = floor(coord);
	vec2 f = fract(coord);
	
	float a = rand(i);
	float b = rand(i + vec2(1.0, 0.0));
	float c = rand(i + vec2(0.0, 1.0));
	float d = rand(i + vec2(1.0, 1.0));

	vec2 cubic = f * f * (3.0 - 2.0 * f);

	return mix(a, b, cubic.x) + (c - a) * cubic.y * (1.0 - cubic.x) + (d - b) * cubic.x * cubic.y;
}

float fbm(vec2 coord){
	float value = 0.0;
	float scale = 0.5;

	for(int i = 0; i < OCTAVES ; i++){
		value += noise(coord) * scale;
		coord *= 2.0;
		scale *= 0.5;
	}
	return value;
}

vec2 rotate(vec2 coord, float angle){
	coord -= 0.5;
	coord *= mat2(vec2(cos(angle),-sin(angle)),vec2(sin(angle),cos(angle)));
	return coord + 0.5;
}

vec2 spherify(vec2 uv) {
	vec2 centered= uv *2.0-1.0;
	float z = sqrt(1.0 - dot(centered.xy, centered.xy));
	vec2 sphere = centered/(z + 1.0);
	return sphere * 0.5+0.5;
}

float correct(float value) {
	float temp = 2.0 * value * value;
	if (value <= 0.5) {
		return clamp(temp, 0.0, 0.5);
	}
	else {
		return clamp(-temp + 4.0 * value - 1.0, 0.5, 1.0);
	}
}


void fragment() {
	//pixelize uv
	vec2 uv = UV;
	
	// cut out a circle
	float d_circle = distance(uv, vec2(0.5));
	float a = step(d_circle, 0.49999);
	
	uv = spherify(uv);
	
	uv = rotate(uv, rotation);
	
	// noise
	float f = correct(fbm(uv*size+vec2(TIME*time_speed, 0.0)));
	
	vec4 col = colors[clamp(int(f * float(colors.length())), 0, colors.length() - 1)];
	
	COLOR = vec4(col.rgb, a * col.a);
}