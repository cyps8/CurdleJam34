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
	match currentCustomer:
		Customer.CROC:
			match Oven.ins.TakePizza():
				Oven.Stage.RAW:
					DialogueWindow.ins.PlayDialogue("Crocstomer", "ITS RAWWW RAAAARRR GRRRR IM MAD, MOVIE NIGHT RUINED", currentCustomer, self.ReturnToBase, "Sorry sir")
				Oven.Stage.UNDER:
					DialogueWindow.ins.PlayDialogue("Crocstomer", "The cheese isn't even melted... This is not a good pizza, This will be a disappointing movie night", currentCustomer, self.ReturnToBase, "My bad")
				Oven.Stage.GOOD:
					DialogueWindow.ins.PlayDialogue("Crocstomer", "Thank you for the pizza! Can't wait to eat this with the gang at movie night!", currentCustomer, self.ReturnToBase, "Yayyy")
				Oven.Stage.PERFECT:
					DialogueWindow.ins.PlayDialogue("Crocstomer", "This pizza is PERFECT, tysm! This will be the best movie night ever! We would ivite you if you weren't so busy!", currentCustomer, self.ReturnToBase, "Yes!")
				Oven.Stage.OVER:
					DialogueWindow.ins.PlayDialogue("Crocstomer", "Its a little too crispy, but still nice, at least food is not so important for movie night", currentCustomer, self.ReturnToBase, "Apologies")
				Oven.Stage.BURNT:
					DialogueWindow.ins.PlayDialogue("Crocstomer", "Its burnt, I'm gonna burn up soon if you don't leave right now you stu-", currentCustomer, self.ReturnToBase, "leaves")
		Customer.PENGUIN:
			match Oven.ins.TakePizza():
				Oven.Stage.RAW:
					DialogueWindow.ins.PlayDialogue("Pizguin", "This pizza is as cold as my planet, I maybe a penguin but I don't literally eat ice...", currentCustomer, self.ReturnToBase, "Oopsie")
				Oven.Stage.UNDER:
					DialogueWindow.ins.PlayDialogue("Pizguin", "Is this a joke? Even my ancestors didn't eat UNDERCOOKED fish, This pizza is a flop", currentCustomer, self.ReturnToBase, "Im dumb")
				Oven.Stage.GOOD:
					DialogueWindow.ins.PlayDialogue("Pizguin", "Yo this pizza is pretty good, man I love eating fishes, yum yum yum", currentCustomer, self.ReturnToBase, "Fishy")
				Oven.Stage.PERFECT:
					DialogueWindow.ins.PlayDialogue("Pizguin", "OMG I love fish AND I love pizza, this is literally the coolest day of my life", currentCustomer, self.ReturnToBase, "Yipee!")
				Oven.Stage.OVER:
					DialogueWindow.ins.PlayDialogue("Pizguin", "Its a little too crispy, but still nice", currentCustomer, self.ReturnToBase, "okay")
				Oven.Stage.BURNT:
					DialogueWindow.ins.PlayDialogue("Pizguin", "Its burnt", currentCustomer, self.ReturnToBase, "uh oh")
