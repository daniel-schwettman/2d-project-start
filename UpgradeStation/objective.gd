extends StaticBody2D

@onready var player = get_node("/root/Game/Player")

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		$UpgradeLabel.visible = true
		var upgradeCost = "%.2f" % player.upgradeCost
		%UpgradeLabel.text = "Upgrade pistol - Lvl. " + str(player.currentPistolLevel + 1) +  " - "  + upgradeCost
		
		if body.canPurchase:
			$UpgradeLabel.modulate = Color("00FF00")
		else:
			%UpgradeLabel.modulate = Color("FF0000")

func _on_area_2d_body_exited(body):
	if body.name == "Player":
		$UpgradeLabel.visible = false

func _input(_event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) && player.canPurchase && $UpgradeLabel.visible:
		player._upgradePistol()
		Purchase.play()
		
		var upgradeCost = "%.2f" % player.upgradeCost
		%UpgradeLabel.text = "Upgrade pistol - Lvl. " + str(player.currentPistolLevel + 1) +  " - "  + upgradeCost
		
		if player.canPurchase:
			%UpgradeLabel.modulate = Color("00FF00")
			player.canPurchase = true
		else:
			player.canPurchase = false
			%UpgradeLabel.modulate = Color("FF0000")
