extends Label

func _ready():
	var tween: Tween = create_tween().set_loops()
	tween.tween_callback(func(): text = "LOADING")
	tween.tween_interval(0.3)
	tween.tween_callback(func(): text = "LOADING.")
	tween.tween_interval(0.3)
	tween.tween_callback(func(): text = "LOADING..")
	tween.tween_interval(0.3)
	tween.tween_callback(func(): text = "LOADING...")
	tween.tween_interval(0.3)
	
