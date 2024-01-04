extends CharacterBody2D

signal health_depleted

@onready var briefcase = get_node("/root/Game/Briefcase")

const STARTINGHEALTH = 100.0
var health = 100.0
var money = 0
var bulletDamage = 1
var bulletSpeed = 1000
var bulletRange = 1000
var frameCount = 30
var canPurchase = false
var upgradeCost = 1.00
var currentPistolLevel = 1
var throwDistance = 800
var isHoldingItem = false
var enemiesKilled = 0

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
		bulletRange += 100 * currentPistolLevel
		bulletSpeed += 50 * currentPistolLevel
		bulletDamage += 1
		frameCount -= 1 * currentPistolLevel
		
	if money < upgradeCost:
		canPurchase = false
	else:
		canPurchase = true

func _input(_event):
	if Input.is_action_pressed("drop") and briefcase.pickedUp:
		briefcase.pickedUp = false

func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * 600
	move_and_slide()
	
	if briefcase.pickedUp and !briefcase.thrown:
		briefcase.position = $HurtBox.global_position
	
	if velocity.length() > 0.0:
		%HappyBoo.play_walk_animation()
	else:
		%HappyBoo.play_idle_animation()
	
	const DAMAGE_RATE = 100.0
	
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	
	if overlapping_mobs.size() > 0:
		health -= DAMAGE_RATE * overlapping_mobs.size() * delta
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
