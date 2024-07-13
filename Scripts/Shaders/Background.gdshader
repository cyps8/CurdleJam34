shader_type canvas_item;

uniform vec4 starColor: source_color;

void fragment() {
	if (COLOR.r > 0.95)
	{
		COLOR = starColor;
	}
	else
	{
		COLOR = vec4(0,0,0,0);
	}
}