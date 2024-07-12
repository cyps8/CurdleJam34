extends Sprite2D

class_name GravityOutline

func SetRadius(value: float):
	material.set_shader_parameter("radius", value)
	texture.width = value * 2
	texture.height = value * 2

func _process(_dt):
	rotation += _dt * 0.1
