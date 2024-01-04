extends Button

func _on_pressed():
	MenuMusic.stop()
	GunshotSfx.play()
	get_tree().paused = false
	get_tree().reload_current_scene()
