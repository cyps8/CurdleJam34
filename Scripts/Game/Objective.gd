extends Area2D

class_name Objective

@export var radius: float = 100.0

var trigger: Callable

func _ready():
	var scalableRemote: ScalableRT2D = $Remote
	var sprite: Sprite2D = $Sprite

	sprite.scale = Vector2.ONE

	remove_child(sprite)

	SubView.ins.add_child(sprite)

	scalableRemote.remotePaths.append(sprite.get_path())

	body_entered.connect(BodyEntered)

	$Shape.shape.radius = radius

func BodyEntered(body: PhysicsBody2D):
	if (body is Player):
		trigger.call()
		queue_free()