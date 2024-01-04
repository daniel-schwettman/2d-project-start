extends CharacterBody2D

var direction
var health = 10
var knockbackPower  = 1000

@onready var player = get_node("/root/Game/Player")
@onready var briefcase = get_node("/root/Game/Briefcase")
@onready var enemiesKilled = get_node("/root/Game/GameOver/ColorRect/EnemiesKilled")
var knockedback = false
var knockbackDirection = 1

func _ready():
	%Slime.play_walk()

func _physics_process(_delta):
	if briefcase.awakened:
		direction = global_position.direction_to(briefcase.global_position)
	else:
		direction = global_position.direction_to(player.global_position)
		
	velocity = direction * 250.0
	
	#if knockedback:
		#velocity = Vector2.ZERO
		#position *=  Vector2(-1,-1) * knockbackDirection
		#knockedback = false
	move_and_slide()
	
func knockback(playerVelocity):
	var knockbackDirection = (playerVelocity - velocity).normalized() * knockbackPower
	velocity = knockbackDirection
	move_and_slide()
	
func take_damage(dmg):	
	knockback(player.velocity)
	health -= dmg
	Damage.play()
	%Slime.play_hurt()
	if health <= 0:
		player.enemiesKilled += 1
		player.money += .25
		enemiesKilled.text = "Enemies Killed: " + str(player.enemiesKilled)
		
		if player.money >= player.upgradeCost:
			player.canPurchase = true
		else:
			player.canPurchase = false
		
		Money.play()
		queue_free()
		Death.play()
		const SMOKE_SCENE = preload("res://smoke_explosion/smoke_explosion.tscn")
		var smoke = SMOKE_SCENE.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position
