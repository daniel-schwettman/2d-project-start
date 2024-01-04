extends Area2D

signal vector_created(vector)

var maximum_length := 200
var touch_down := false
var position_start := Vector2.ZERO
var position_end := Vector2.ZERO

var vector := Vector2.ZERO

func _draw():
	draw_line(position_start - global_position, (position_end - global_position), Color.BLUE, 8)
	
	draw_line(position_start - global_position, position_start - global_position + vector, Color.RED, 16)

func _reset():
	position_end = Vector2.ZERO
	position_start = Vector2.ZERO
	vector = Vector2.ZERO
	queue_redraw()

func _input(event):
	if not touch_down:
		return
	if event.is_action_released("ui_touch"):
		touch_down = false
		emit_signal("vector_created", vector)
		_reset()
	if event is InputEventMouseMotion:
		position_end = event.position
		vector = -(position_end - position_start) 
		queue_redraw()

func _on_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("ui_touch"):
		touch_down = true
		position_start = event.position
