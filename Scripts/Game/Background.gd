extends Node2D

@export var cam: Camera2D

@export var starIns: PackedScene

var currentCentre: Vector2 = Vector2.ZERO

var stars: Array[Sprite2D] = []

var textureSize = 256.0

func _ready():
	for _i in range(4):
		var star = starIns.instantiate()
		stars.append(star)
		add_child(star)

	stars[0].position = Vector2(-textureSize / 2, -textureSize / 2) # Top left
	stars[1].position = Vector2(textureSize / 2, -textureSize / 2) # Top right
	stars[2].position = Vector2(-textureSize / 2, textureSize / 2) # Bottom left
	stars[3].position = Vector2(textureSize / 2, textureSize / 2) # Bottom right

func _process(_dt):
	while cam.position.y < currentCentre.y - (textureSize / 2):
		MoveUp()

func MoveUp():
	currentCentre.y -= textureSize
	stars[2].position.y -= textureSize * 2
	stars[3].position.y -= textureSize * 2

	var newStars: Array[Sprite2D] = []
	newStars.append(stars[2])
	newStars.append(stars[3])
	newStars.append(stars[0])
	newStars.append(stars[1])
	stars = newStars