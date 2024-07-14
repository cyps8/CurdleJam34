extends Sprite2D

var time: float = 0.0

func _process(_dt):
	time += _dt
	material.set_shader_parameter("time", time)