extends Sprite2D

class_name Oven
static var ins: Oven

func _init():
	ins = self

enum Stage { RAW, UNDER, GOOD, PERFECT, OVER, BURNT }

@export var stageTimes: Array[float]

var currentStage: Stage = Stage.RAW

var hasPizza: bool = false
var isHot: bool = false

var stageTime: float = 0
var overallTime: float = 0

@export var pizzas: Array[Texture2D]

func _ready():
	var blinkTween: Tween = create_tween().set_loops()
	blinkTween.tween_method(Callable(Blink), 0.0, 1.0, 0.25)

func AddPizza(customer: int):
	$Pizza.texture = pizzas[customer]
	currentStage = Stage.RAW
	$Pizza.visible = true
	hasPizza = true
	stageTime = stageTimes[0]
	$Pizza.region_rect = Rect2(0, currentStage * 32, 48, 32)
	overallTime = 0

func TakePizza() -> Stage:
	$Pizza.visible = false
	hasPizza = false
	print(currentStage)
	$Pointer.position.x = -19 
	return currentStage

func SetHot(hot: bool):
	$Hot.visible = hot
	isHot = hot

func _process(_dt):
	if hasPizza && isHot:
		stageTime -= _dt
		overallTime += _dt

		$Pointer.position.x = -19 + overallTime * 2
		if $Pointer.position.x > 17:
			$Pointer.position.x = 17

		if stageTime < 0.0:
			currentStage += 1
			stageTime += stageTimes[currentStage]
			$Pizza.region_rect = Rect2(0, currentStage * 32, 48, 32)

func Blink(time: float):
	for sprite in $Blinkers.get_children():
		sprite.visible = false
	if hasPizza:
		if time < 0.5 || !isHot:
			$Blinkers.get_child(currentStage).visible = true