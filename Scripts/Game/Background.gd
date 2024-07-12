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
	while cam.position.y > currentCentre.y + (textureSize / 2):
		MoveDown()
	while cam.position.x < currentCentre.x - (textureSize / 2):
		MoveLeft()
	while cam.position.x > currentCentre.x + (textureSize / 2):
		MoveRight()

func FlipV():
	var newStars: Array[Sprite2D] = []
	newStars.append(stars[2])
	newStars.append(stars[3])
	newStars.append(stars[0])
	newStars.append(stars[1])
	stars = newStars

func FlipH():
	var newStars: Array[Sprite2D] = []
	newStars.append(stars[1])
	newStars.append(stars[0])
	newStars.append(stars[3])
	newStars.append(stars[2])
	stars = newStars

func MoveUp():
	currentCentre.y -= textureSize
	stars[2].position.y -= textureSize * 2
	stars[3].position.y -= textureSize * 2
	FlipV()

func MoveDown():
	currentCentre.y += textureSize
	stars[0].position.y += textureSize * 2
	stars[1].position.y += textureSize * 2
	FlipV()

func MoveLeft():
	currentCentre.x -= textureSize
	stars[1].position.x -= textureSize * 2
	stars[3].position.x -= textureSize * 2
	FlipH()

func MoveRight():
	currentCentre.x += textureSize
	stars[0].position.x += textureSize * 2
	stars[2].position.x += textureSize * 2
	FlipH()