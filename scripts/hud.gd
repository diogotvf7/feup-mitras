extends CanvasLayer

signal start_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ScoreLabel.hide()
	$ExtraAmmoLabel.hide()
	$Ammo.hide()
	$ExtraHPLabel.hide()
	$HP.hide()
	$GameOverLabel.hide()
	$FinalScoreLabel.hide()

func update_score(score):
	$ScoreLabel.text = str(score)

func update_ammo(ammo):
	if (ammo > 3):
		$ExtraAmmoLabel.text = str(ammo) + "✕"
		$Ammo.frame = 1
	else:
		$ExtraAmmoLabel.text = ""
		$Ammo.frame = ammo

func update_hp(hp):
	if (hp > 3):
		$ExtraHPLabel.text = str(hp) + "✕"
		$HP.frame = 3
	elif hp > 0:
		$ExtraHPLabel.text = ""
		$HP.frame = hp-1
		
func show_game_over(score: int):
	$ScoreLabel.hide()
	$ExtraAmmoLabel.hide()
	$Ammo.hide()
	$ExtraHPLabel.hide()
	$HP.hide()
	
	$FinalScoreLabel.text = str(score)
	$StartButton.show()
	$GameOverLabel.show()
	$FinalScoreLabel.show()
	
func _on_start_button_pressed() -> void:
	$StartButton.hide()
	$GameOverLabel.hide()
	$FinalScoreLabel.hide()
	$ScoreLabel.show()
	$ExtraAmmoLabel.show()
	$Ammo.show()
	$ExtraHPLabel.show()
	$HP.show()
	start_game.emit()
	$StartButton.text = "Play Again"
