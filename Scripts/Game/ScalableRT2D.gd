@icon("res://Assets/Art/Other/theGOAT.png")
extends Node2D

class_name ScalableRT2D

@export var remotePaths: Array[NodePath] = []

@export var updatePosition: bool = true

@export var updateRotation: bool = true

@export var scaled: float = 1.0

func _process(_dt):
	for path in remotePaths:
		if updatePosition:
			get_node(path).global_position = global_position * scaled
		if updateRotation:
			get_node(path).global_rotation = global_rotation

func _exit_tree():
	for path in remotePaths:
		get_node(path).queue_free()
