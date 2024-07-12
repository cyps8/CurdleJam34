shader_type canvas_item;

uniform float radius = 50.0;

uniform float line_thickness = 2.0;

void fragment() {
	// diff is centre - point
	vec2 point = vec2(UV.x * radius * 2.0, UV.y * radius * 2.0);
	vec2 diff = vec2(radius, radius) - point;
	float dist = (diff.x * diff.x) + (diff.y * diff.y);
	float angle = atan(diff.y, diff.x);
	if (dist < (radius * radius) && dist > ((radius-line_thickness) * (radius-line_thickness)) && mod(angle * radius, 15.0) <= 10.0)
	{
		COLOR = vec4(0.3,0.25,0.25,1);
	}
	else
	{
		COLOR = vec4(0,0,0,0);
	}
}