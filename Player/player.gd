extends CharacterBody2D

signal health_depleted

@onready var briefcase = get_node("/root/Game/Briefcase")
@export var knockbackPower = 500

const STARTINGHEALTH = 100.0
var health = 100.0
var money = 0
var bulletDamage = 1
var bulletSpeed = 1000
var bulletRange = 1000
var frameCount = 15
var canPurchase = false
var upgradeCost = 1.00
var currentPistolLevel = 1
var throwDistance = 800
var isHoldingItem = false
var enemiesKilled = 0
var dash_speed = 3000
var dash_duration = 0.2
var move_speed = 600

func _ready():
	var sb = StyleBoxFlat.new()
	%ProgressBar.value = health;
	%ProgressBar.add_theme_stylebox_override("fill", sb)
	sb.bg_color = Color("008000")

func _upgradePistol():
	if money >= upgradeCost:
		money -= upgradeCost
		currentPistolLevel += 1
		upgradeCost += 1 * currentPistolLevel
		bulletRange += 10 * currentPistolLevel
		bulletSpeed += 10 * currentPistolLevel
		bulletDamage += 1
		frameCount -= 1
		
	if money < upgradeCost:
		canPurchase = false
	else:
		canPurchase = true

func _input(_event):
	if Input.is_action_pressed("drop") and briefcase.pickedUp:
		briefcase.pickedUp = false
		ItemPickup.play()

func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if Input.is_action_just_pressed("dash") and $Dash.can_dash and !$Dash.is_dashing():
		$Dash.start_dash(dash_duration)
	
	var speed = dash_speed if $Dash.is_dashing() else move_speed	
	
	velocity = direction * speed
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	
	if $Dash.is_dashing():
		set_collision_layer_value(1, false)
		set_collision_layer_value(3, true)
		set_collision_mask_value(2, false)
	else:
		set_collision_layer_value(1, true)
		set_collision_layer_value(3, false)
		set_collision_mask_value(2, true)
	#else:
		#if overlapping_mobs.size() > 0:
			#for n in overlapping_mobs:
				#add_collision_exception_with(overlapping_mobs[n])
				
	move_and_slide()
	
	if briefcase.pickedUp and !briefcase.thrown:
		briefcase.position = $HurtBox.global_position
	
	if velocity.length() > 0.0:
		if $Dash.is_dashing():
			%HappyBoo.play_dodge_animation()
		else:
			%HappyBoo.play_walk_animation()
	else:
		%HappyBoo.play_idle_animation()
	
	const DAMAGE_RATE = 5.0
	
	if overlapping_mobs.size() > 0:
		health -= DAMAGE_RATE * overlapping_mobs.size() * delta
		
		for n in overlapping_mobs:
			n.knockback(velocity)
			knockback(n.velocity)
			
		%ProgressBar.value = health
		
		if health >= STARTINGHEALTH / 2:
			var sb = %ProgressBar.get_theme_stylebox("fill")
			sb.bg_color =  Color("008000")
			
		if health <= STARTINGHEALTH / 2: 
			var sb = %ProgressBar.get_theme_stylebox("fill")
			sb.bg_color =  Color("ffff00")
			
		if health <= STARTINGHEALTH / 4: 
			var sb = %ProgressBar.get_theme_stylebox("fill")
			sb.bg_color =  Color("ff0000")
			
		if health <= 0:
			health_depleted.emit()
			GameOver.play()

func knockback(enemyVelocity):
	var knockbackDirection = (enemyVelocity - velocity).normalized() * knockbackPower
	velocity = knockbackDirection
	move_and_slide()
