extends Node2D

@export var texture: Texture2D = null

@export var alwaysShow: bool = false

var sprite: Sprite2D

func _ready():
	sprite = Sprite2D.new()
	sprite.texture = texture
	get_tree().get_first_node_in_group("MapPlayer").add_child(sprite)

func _process(_dt):
	sprite.visible = true
	var distance = (global_position - Player.ins.global_position).length()
	if (alwaysShow && distance > 3400):
		sprite.position = ((global_position - Player.ins.global_position).normalized() * 3400).rotated(-Player.ins.rotation) * 0.005
	elif (distance < 4500):
		sprite.position = (global_position - Player.ins.global_position).rotated(-Player.ins.rotation) * 0.005
	else:
		sprite.visible = false

func _exit_tree():
	sprite.queue_free()