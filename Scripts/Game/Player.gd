@icon("res://Assets/Art/Objects/ship.png")
extends CharacterBody2D

class_name Player

@export var angular_velocity = 0.0

@export var predPointIns: PackedScene

var playerSprite: Sprite2D

var predPoints: Array = []

var smoke: CPUParticles2D
var fire: CPUParticles2D

func _ready():
	playerSprite = $PlayerSprite 
	smoke = $PlayerSprite/Smoke
	fire = $PlayerSprite/Fire
	playerSprite.scale = Vector2.ONE

	for _i in range(100):
		var predPoint = predPointIns.instantiate()
		predPoint.position = Vector2.ZERO
		predPoints.append(predPoint)
		playerSprite.add_child(predPoint)
		predPoint.z_index = -1
		predPoint.modulate = Color(1, 1, 1, (100.0 - _i) / 100.0)

	remove_child(playerSprite)
	SubView.ins.add_child(playerSprite)
	$RemotePlayer.remotePaths.append(playerSprite.get_path())

func _physics_process(_dt):
	var input = Input.get_vector("Left", "Right", "Up", "Down")
	
	if input.x * angular_velocity < 0:
		angular_velocity *= 0.95
	angular_velocity += input.x * _dt * 0.01

	rotation += angular_velocity

	if input.y < 0:
		smoke.emitting = true
		fire.emitting = true
		playerSprite.scale = Vector2(0.92, 1.08)
	else:
		smoke.emitting = false
		fire.emitting = false
		playerSprite.scale = Vector2(1.0, 1.0)

	if velocity.length() > 0 && velocity.dot(Vector2(0, input.y).rotated(rotation)) < 0:
		velocity *= 0.99
	if input.y > 0:
		velocity += Vector2(0, input.y * _dt * 10.0).rotated(rotation)
	elif input.y < 0:
		velocity += Vector2(0, input.y * _dt * 50.0).rotated(rotation)

	velocity += GetGravity(global_position)

	Prediction()

	move_and_slide()

	get_tree().get_first_node_in_group("Velocity").text = "Velocity: " + str(snapped(velocity.length(), 0.1)) + "m/s"

func GetGravity(atPos: Vector2) -> Vector2:
	var compound: Vector2 = Vector2.ZERO
	for gravity in GravityMan.ins.points:
		var distance = atPos.distance_to(gravity.global_position)
		if distance < gravity.radius:
			var direction = atPos.direction_to(gravity.global_position)
			compound += direction * gravity.strenthMult * 5.0 * (1 - (distance / gravity.radius))
	return compound

func Prediction():
	var nextPoint: Vector2 = global_position
	var nextVel: Vector2 = velocity
	for point in predPoints:
		for prediction in range(15):
			nextPoint += nextVel * (1.0/60.0)
			nextVel += GetGravity(nextPoint)
		point.global_position = nextPoint / 4