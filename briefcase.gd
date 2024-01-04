extends Area2D

signal health_depleted

@onready var timer = get_node("/root/Game/Timer")
@onready var player = get_node("/root/Game/Player")
@onready var followPath = get_node("/root/Game/Player/Path2D/PathFollow2D")
@onready var progressBar = get_node("/root/Game/Briefcase/BriefcaseHealth")
var pickedUp = false
var travelled_distance = 0
var inRange = false
var thrown = false
var awakened = false
var health = 1000
const STARTINGHEALTH = 1000.0

func _physics_process(delta):
	if travelled_distance < player.throwDistance and thrown:
		var direction = Vector2.RIGHT.rotated(rotation)
		position += direction * player.bulletSpeed * delta
		travelled_distance += player.bulletSpeed * delta	
	elif thrown:
		pickedUp = false
		thrown = false
		travelled_distance = 0
		
	const DAMAGE_RATE = 100.0
	var overlapping_mobs = %BriefcaseHurtBox.get_overlapping_bodies()
	
	if overlapping_mobs.size() > 0:
		health -= DAMAGE_RATE * overlapping_mobs.size() * delta
		progressBar.value = health
		
		if health >= STARTINGHEALTH / 2:
			var sb = progressBar.get_theme_stylebox("fill")
			sb.bg_color =  Color("008000")
			
		if health <= STARTINGHEALTH / 2: 
			var sb = progressBar.get_theme_stylebox("fill")
			sb.bg_color =  Color("ffff00")
			
		if health <= STARTINGHEALTH / 4: 
			var sb = progressBar.get_theme_stylebox("fill")
			sb.bg_color =  Color("ff0000")
			
		if health <= 0:
			health_depleted.emit()
			GameOver.play()
		
func _ready():
	var sb = StyleBoxFlat.new()
	%BriefcaseHealth.value = health;
	%BriefcaseHealth.add_theme_stylebox_override("fill", sb)
	sb.bg_color = Color("008000")


func _on_body_entered(body):
	if body.name == "Player" and !pickedUp:
		inRange = true

func _on_body_exited(body):	
	if body.name == "Player" and !pickedUp:
		inRange = false

func _input(_event):
	if Input.is_action_pressed("pickUp") and inRange:
		pickedUp = true
		awakened = true
		position = player.position


func spawn_mob():
	var new_mob = preload("res://mob.tscn").instantiate()
	followPath.progress_ratio = randf()
	new_mob.global_position = followPath.global_position
	new_mob.add_to_group("Enemies")
	get_node("/root").add_child(new_mob)

func _on_timer_timeout():
	if awakened:
		spawn_mob()
		if timer.wait_time > 1.0:
			timer.wait_time -= 0.001
