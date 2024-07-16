@icon("res://Assets/Art/Objects/ship.png")
extends CharacterBody2D

class_name Player
static var ins: Player

func _init():
	ins = self

var angularVelocity = 0
var direction: float = 0.0

var drifting = false

@export var predPointIns: PackedScene

var playerSprite: Sprite2D

var predPoints: Array = []
var predCount: int = 10

var smoke: CPUParticles2D
var fire: CPUParticles2D

func _ready():
	playerSprite = $PlayerSprite 
	smoke = $PlayerSprite/Smoke
	fire = $PlayerSprite/Fire
	playerSprite.scale = Vector2.ONE

	for _i in range(predCount):
		var predPoint = predPointIns.instantiate()
		predPoint.position = Vector2.ZERO
		predPoints.append(predPoint)
		playerSprite.add_child(predPoint)
		predPoint.z_index = -1
		predPoint.modulate = Color(1, 1, 1, (predCount - _i) as float / predCount as float)

	remove_child(playerSprite)
	SubView.ins.add_child(playerSprite)
	$RemotePlayer.remotePaths.append(playerSprite.get_path())

func _physics_process(_dt):
	var input = Input.get_vector("Left", "Right", "Up", "Down")
	
	if input.x != 0:
		angularVelocity = input.x * 1.3
	else:
		angularVelocity *= 0.9
	rotation += angularVelocity * _dt

	if input.y < 0:
		smoke.emitting = true
		fire.emitting = true
		playerSprite.scale = Vector2(0.92, 1.08)
	else:
		smoke.emitting = false
		fire.emitting = false
		playerSprite.scale = Vector2(1.0, 1.0)

	var rotatedDirection = velocity.normalized().rotated(PI/2)
	var directionDot = Vector2(0, -1).rotated(rotation).dot(rotatedDirection)
	direction = signf(directionDot)

	drifting = false
	if input.y > 0:
		if velocity.length() > 0:
			var rotationDot = velocity.normalized().dot(Vector2(0, input.y).rotated(rotation))
			if rotationDot < -0.259:
				velocity *= 0.99
				velocity += Vector2(0, input.y * _dt * 10.0).rotated(rotation)
			elif velocity.length() > 50.0:
				drifting = true
				var drift = 0
				var velocityMult = velocity.length() - 50 / 150.0
				if velocityMult > 1.0:
					velocityMult = 1.0
				var angleMult = 1.0
				var slowMult = 1.0
				if rotationDot > 0.259:
					angleMult = 1.0 + ((rotationDot - 0.259) * 2.0)
					slowMult = 1.0 + ((rotationDot - 0.259) * 1000.0)
				drift = direction * ((rotationDot * 3) + 1.0) * _dt * velocityMult * angleMult
				rotation += drift
				velocity = velocity.rotated(drift) * (1.0 - (0.0001 * slowMult))  
	elif input.y < 0:
		velocity += Vector2(0, input.y * _dt * 35.0).rotated(rotation)

	velocity += GetGravity(global_position)

	Prediction()

	move_and_slide()

	get_tree().get_first_node_in_group("Velocity").text = "Velocity: " + str(snapped(velocity.length(), 0.1)) + "m/s"

func GetGravity(atPos: Vector2) -> Vector2:
	var compound: Vector2 = Vector2.ZERO
	for gravity in GravityMan.ins.points:
		var distance = atPos.distance_to(gravity.global_position)
		if distance < gravity.radius:
			var gravDirection = atPos.direction_to(gravity.global_position)
			compound += gravDirection * gravity.strenthMult * 5.0 * (1 - (distance / gravity.radius))
	return compound

func Prediction():
	var nextPoint: Vector2 = global_position
	var nextVel: Vector2 = velocity
	for point in predPoints:
		for prediction in range(15):
			nextPoint += nextVel * (1.0/60.0)
			nextVel += GetGravity(nextPoint)
		point.global_position = nextPoint / 4