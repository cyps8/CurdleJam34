extends Node

class_name GameManager
static var ins: GameManager

var paused = false

var pauseMenuRef: CanvasLayer

var dialogueWinRef: CanvasLayer

var dialogueOpen: bool = false

@export var objective: PackedScene

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
    DialogueWindow.ins.PlayDialogue("BOSS", "Hey! Delivery dude! what are you doing sitting around on your lazy butt! Go do some deliveries!!!", null, self.StartGame, "On it!")

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
    var pos = Vector2(randi_range(-2500, 2500), randi_range(-2500, 2500))
    while pos.length() < 500:
        pos = Vector2(randi_range(-2500, 2500), randi_range(-2500, 2500))
    NewDelivery(pos)
    CloseDialogueWindow()

func GetNewDelivery():
    OpenDialogueWindow()
    DialogueWindow.ins.PlayDialogue("BOSS", "Here is a new order", null, self.AcceptNewDelivery, "okie")

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

func DeliveryCompleted():
    OpenDialogueWindow()
    DialogueWindow.ins.PlayDialogue("Customer", "Ty :3", null, self.ReturnToBase, "yw :3")