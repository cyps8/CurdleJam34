extends CanvasLayer

func StartPressed():
	Root.ins.ChangeScene(Root.Scene.GAME)

func OptionsPressed():
	Root.ins.OpenOptionsMenu()

func ExitPressed():
	get_tree().quit()
