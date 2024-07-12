shader_type canvas_item;

void fragment() {
	if (COLOR.r > 0.9)
	{
		COLOR = vec4(1,1,1,1);
	}
	else
	{
		COLOR = vec4(0,0,0,0);
	}
}