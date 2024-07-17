extends CanvasLayer

class_name DialogueWindow
static var ins: DialogueWindow

func _init():
	ins = self

var nameText: Label
var dialogueText: Label
var headIcon: TextureRect

var option1Button: Button
var option2Button: Button
var option1Text: Label
var option2Text: Label

var call1: Callable
var call2: Callable

@export var icons: Array[Texture2D]

func _ready():
	nameText = %Name
	dialogueText = %Dialogue
	headIcon = %HeadIcon

	nameText.text = ""
	dialogueText.text = ""

	option1Button = %Option1Button
	option2Button = %Option2Button
	option1Text = option1Button.get_node("Label")
	option2Text = option2Button.get_node("Label")

func PlayDialogue(characterName: String, dialogue: String, icon: int = -1, option1: Callable = Callable(), option1String: String = "", option2: Callable = Callable(), option2String: String = ""):
	nameText.text = characterName
	dialogueText.text = dialogue
	if icon != -1:
		headIcon.texture = icons[icon]
	option1Button.visible = option1.is_valid()
	option2Button.visible = option2.is_valid()
	option1Text.text = option1String
	option2Text.text = option2String
	call1 = option1
	call2 = option2

	nameText.visible_ratio = 0
	dialogueText.visible_ratio = 0

var timer: float = 0

func _process(_dt):
	timer += _dt
	if timer > 0.05:
		timer -= 0.05
		if nameText.visible_characters < nameText.text.length():
			nameText.visible_characters += 1
			dialogueText.visible_characters = 0
		elif dialogueText.visible_characters < dialogueText.text.length():
			dialogueText.visible_characters += 1

func OptionPressed(num: int):
	if num == 1:
		call1.call()
	if num == 2:
		call2.call()
