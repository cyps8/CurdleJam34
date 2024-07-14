extends Node

class_name GameManager
static var ins: GameManager

var paused = false

var pauseMenuRef: CanvasLayer

var dialogueWinRef: CanvasLayer

var dialogueOpen: bool = false

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
    DialogueWindow.ins.PlayDialogue("BOSS", "Hey! Delivery boy! what are you doing sitting around on your lazy butt! Go do some deliveries!!!", null, self.StartGame, "On it!")

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
    CloseDialogueWindow()

func OpenDialogueWindow():
    dialogueOpen = true
    get_tree().paused = true
    add_child(dialogueWinRef)

func CloseDialogueWindow():
    dialogueOpen = false
    get_tree().paused = false
    remove_child(dialogueWinRef)