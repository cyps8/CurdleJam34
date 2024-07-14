shader_type canvas_item;

uniform float time;

uniform float radius = 16.0;

uniform vec4 color: source_color;

void fragment() {
	// diff is centre - point
	vec2 point = vec2(UV.x * radius * 2.0, UV.y * radius * 2.0);
	vec2 diff = vec2(radius, radius) - point;
	float dist = (diff.x * diff.x) + (diff.y * diff.y);
	// Ranges
	vec2 r1 = vec2(0.0+mod(time, 4.0)*2.5, 1.0+mod(time, 4.0)*2.5);
	vec2 r2 = vec2(10.0+mod(time, 4.0)*2.5, 11.0+mod(time, 4.0)*2.5);
	vec2 r3 = vec2(20.0+mod(time, 4.0)*2.5, 21.0+mod(time, 4.0)*2.5);
	if (
		dist < (radius-r1.x) * (radius-r1.x) && dist > (radius-r1.y) * (radius-r1.y) ||
		dist < (radius-r2.x) * (radius-r2.x) && dist > (radius-r2.y) * (radius-r2.y) ||
		dist < (radius-r3.x) * (radius-r3.x) && dist > (radius-r3.y) * (radius-r3.y)
		)
	{
		COLOR = color;
		COLOR.a = dist/ (radius*radius);
	}
	else
	{
		COLOR = vec4(0,0,0,0);
	}
}