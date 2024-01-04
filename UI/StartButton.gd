extends Button


func _on_pressed():
	%GameStart.visible = false
	get_tree().paused = false
	GunshotSfx.play()
