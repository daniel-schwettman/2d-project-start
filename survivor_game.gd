extends Node2D

@onready var upgradeLabel = get_node("/root/Game/UpgradeStation/UpgradeLabel")
const PINE_TREE = preload("res://pine_tree.tscn")
var maxTreeCount = 25
var numberofLevels

func _ready():
	BackGroundMusic.play()
	get_tree().paused = true
	#createTrees()

func createTrees():
	for i in range(10):
		var new_tree = PINE_TREE.instantiate()
		new_tree.add_to_group("Trees")
		new_tree.global_position.x = randf_range(0, 3400)
		new_tree.global_position.y = randf_range(0, 3400)
		add_child(new_tree)

func _process(_delta):
	var playerMoney = "%.2f" % %Player.money
	%MoneyCount.text = "Money: $" + str(playerMoney)
	if $Player.canPurchase:
		upgradeLabel.modulate = Color("00FF00")
		$Player.canPurchase = true
	else:
		$Player.canPurchase = false
		upgradeLabel.modulate = Color("FF0000")
	
	if !BackGroundMusic.playing:
		BackGroundMusic.play()

func _on_player_health_depleted():
	%GameOver.visible = true
	BackGroundMusic.stop()
	MenuMusic.play()
	get_tree().paused = true;


func _on_briefcase_health_depleted():
	%Label.text = "You let them destroy the briefcase..."
	%GameOver.visible = true
	BackGroundMusic.stop()
	MenuMusic.play()
	get_tree().paused = true;
