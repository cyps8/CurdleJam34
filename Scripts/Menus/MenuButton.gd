extends Button

@export var silentButton: bool = false
@export var disableForWeb: bool = false
@export var backButton: bool = false

var defaultPos: Vector2

@export var focusMove: Vector2

func _ready():
	if OS.get_name() == "Web" && disableForWeb:
		disabled = true

	mouse_entered.connect(Callable(Focused))
	mouse_exited.connect(Callable(Unfocused))
	focus_entered.connect(Callable(Focused))
	focus_exited.connect(Callable(Unfocused))
	pressed.connect(Callable(Pressed))

	defaultPos = position

	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

func Focused():
	position = defaultPos + focusMove
	if disabled:
		return
	if !focus_mode == FOCUS_NONE && !has_focus():
		grab_focus()

func Pressed():
	pass

func Unfocused():
	position = defaultPos
