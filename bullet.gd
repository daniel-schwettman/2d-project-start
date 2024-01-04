extends Area2D

@onready var player = get_node("/root/Game/Player")
var travelled_distance = 0;

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * player.bulletSpeed * delta
	
	travelled_distance += player.bulletSpeed * delta
	
	if travelled_distance > player.bulletRange:
		queue_free()

func _on_body_entered(body):
	queue_free()
	if body.has_method("take_damage"):
		body.take_damage(player.bulletDamage)

