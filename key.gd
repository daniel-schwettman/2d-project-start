extends RigidBody2D

@onready var player = get_node("/root/Game/Player")
var travelled_distance = 0;
var thrown = false
var direction

func _physics_process(delta):
	if thrown:	
		if travelled_distance < 10000:
			global_position += direction * player.bulletSpeed * delta
			travelled_distance += player.bulletSpeed * delta
		else:
			travelled_distance = 0
			thrown = false
			
func _on_body_entered(body):
	if body.name == "Player" and Input.is_action_pressed("Pickup"):
		if !player.isHoldingItem:
			position = body.global_position
			player.isHoldingItem = true
			
func _throw(dir):
	thrown = true
	direction = dir
