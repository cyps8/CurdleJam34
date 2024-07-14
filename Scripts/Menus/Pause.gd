extends CanvasLayer

func ResumePressed():
	GameManager.ins.TogglePause()

func OptionsPressed():
	Root.ins.OpenOptionsMenu()

func RestartPressed():
	GameManager.ins.TogglePause()
	Root.ins.ChangeScene(Root.Scene.GAME)

func MainMenuPressed():
	GameManager.ins.TogglePause()
	Root.ins.ChangeScene(Root.Scene.MAINMENU)