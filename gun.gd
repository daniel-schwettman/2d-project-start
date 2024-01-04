extends Area2D

@onready var player = get_node("/root/Game/Player")
@onready var briefcase = get_node("/root/Game/Briefcase")
var isShooting = false
var frameCount = 30
var isThrowing = false

func _physics_process(_delta):
	look_at(get_global_mouse_position())
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		isShooting = true
	else:
		isShooting = false
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		isThrowing = true
	else:
		isThrowing = false
	
	frameCount += 1

func shoot():
	if frameCount >= player.frameCount:
		const BULLET = preload("res://bullet.tscn")
		var new_bullet = BULLET.instantiate()
		new_bullet.global_position = %ShootingPoint.global_position
		new_bullet.global_rotation = %ShootingPoint.global_rotation
		%ShootingPoint.add_child(new_bullet)
		GunshotSfx.play()
		frameCount = 0

func throw():
	if frameCount >= player.frameCount and briefcase.pickedUp:
		briefcase.global_position = %ShootingPoint.global_position
		briefcase.global_rotation = player.global_rotation
		briefcase.thrown = true
		briefcase.inRange = false
		GunshotSfx.play()
		frameCount = 0
		
func _on_timer_timeout():
	if isShooting:
		shoot()
	if isThrowing:
		throw()
