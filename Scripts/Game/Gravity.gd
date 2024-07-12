extends Node2D

class_name Gravity

var radius: float = 100.0

@export var strenthMult: float = 1.0

func _enter_tree():
	GravityMan.ins.points.append(self)

func _exit_tree():
	GravityMan.ins.points.erase(self)