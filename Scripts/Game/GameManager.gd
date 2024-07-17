extends Node

class_name GameManager
static var ins: GameManager

var paused = false

var pauseMenuRef: CanvasLayer

var dialogueWinRef: CanvasLayer

var dialogueOpen: bool = false

@export var objective: PackedScene

enum Customer {
	CROC,
	PENGUIN,
	GOAT,
	TRAIN,
	SQUID,
	FISH
}

var currentCustomer: int = 0

func _init():
	ins = self

func _ready():
	pauseMenuRef = $Pause
	pauseMenuRef.visible = true
	dialogueWinRef = $Dialogue
	dialogueWinRef.visible = true
	remove_child(pauseMenuRef)
	remove_child(dialogueWinRef)
	var delayTween: Tween = create_tween()
	delayTween.tween_callback(Root.ins.HideLoadingScreen).set_delay(0.05)
	OpenDialogueWindow()
	DialogueWindow.ins.PlayDialogue("BOSS", "Hey! Delivery dude! what are you doing sitting around on your lazy butt! Go do some deliveries!!!", 6, self.StartGame, "On it!")

func _process(_dt):
	if Input.is_action_just_pressed("Pause") && !Root.ins.optionsOpen && !dialogueOpen:
		TogglePause()

func TogglePause():
	paused = !paused
	get_tree().paused = paused
	if paused:
		add_child(pauseMenuRef)
	else:
		remove_child(pauseMenuRef)

func StartGame():
	AcceptNewDelivery()

func OpenDialogueWindow():
	dialogueOpen = true
	get_tree().paused = true
	add_child(dialogueWinRef)

func CloseDialogueWindow():
	dialogueOpen = false
	get_tree().paused = false
	remove_child(dialogueWinRef)

func AcceptNewDelivery():
	var pos = $World/Planets.get_child(currentCustomer).global_position
	NewDelivery(pos)
	CloseDialogueWindow()

func GetNewDelivery():
	OpenDialogueWindow()
	currentCustomer = randi_range(0, 5)
	DialogueWindow.ins.PlayDialogue("BOSS", "Here is a new order", 6, self.AcceptNewDelivery, "okie")

func ReturnToBase():
	var newObjective = objective.instantiate()
	$World.add_child(newObjective)
	newObjective.trigger = self.GetNewDelivery
	newObjective.position = Vector2(0, 0)
	CloseDialogueWindow()

func NewDelivery(position: Vector2):
	var newObjective = objective.instantiate()
	$World.add_child(newObjective)
	newObjective.trigger = self.DeliveryCompleted
	newObjective.position = position
	Oven.ins.AddPizza(currentCustomer)

func DeliveryCompleted():
	SFXPlayer.ins.PlaySound(0)
	OpenDialogueWindow()
	match Oven.ins.TakePizza():
		Oven.Stage.RAW:
			DialogueWindow.ins.PlayDialogue("Customer", "ITS RAWWW", currentCustomer, self.ReturnToBase, "oopsie")
		Oven.Stage.UNDER:
			DialogueWindow.ins.PlayDialogue("Customer", "The cheese isn't even melted...", currentCustomer, self.ReturnToBase, "my bad")
		Oven.Stage.GOOD:
			DialogueWindow.ins.PlayDialogue("Customer", "Thank you for the pizza!", currentCustomer, self.ReturnToBase, "yay")
		Oven.Stage.PERFECT:
			DialogueWindow.ins.PlayDialogue("Customer", "This pizza is PERFECT, tysm!", currentCustomer, self.ReturnToBase, "poger")
		Oven.Stage.OVER:
			DialogueWindow.ins.PlayDialogue("Customer", "Its a little too crispy, but still nice", currentCustomer, self.ReturnToBase, "okay")
		Oven.Stage.BURNT:
			DialogueWindow.ins.PlayDialogue("Customer", "Its burnt", currentCustomer, self.ReturnToBase, "uh oh")
	
