extends Area2D

class_name Planet

@export var radius: float = 100.0

@export var isHot: bool = true

func _ready():
	var scalableRemote: ScalableRT2D = $Remote
	var sprite: Sprite2D = $Sprite
	var gravityPoint: Gravity = $Gravity
	var gravityOutline: GravityOutline = $GravityOutline

	sprite.scale = Vector2.ONE
	gravityOutline.scale = Vector2.ONE

	remove_child(sprite)
	remove_child(gravityOutline)

	SubView.ins.add_child(sprite)
	SubView.ins.add_child(gravityOutline)

	scalableRemote.remotePaths.append(sprite.get_path())
	scalableRemote.remotePaths.append(gravityOutline.get_path())

	gravityOutline.SetRadius(radius)
	gravityPoint.radius = radius * 4

	body_entered.connect(BodyEntered)
	body_exited.connect(BodyExited)
	
	sprite.material.set_shader_parameter("rotation", randf_range(0.0, 6.28))
	sprite.material.set_shader_parameter("seed", randf_range(0.0, 6.28))

func BodyEntered(body: PhysicsBody2D):
	if (body is Player):
		if isHot:
			body.heat += 1

func BodyExited(body: PhysicsBody2D):
	if (body is Player):
		if isHot:
			body.heat -= 1
