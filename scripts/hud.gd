extends CanvasLayer

signal start_game

var stage = 0
@export var scroll_speed = 10

func _ready() -> void:
	$ScoreLabel.hide()
	$ExtraAmmoLabel.hide()
	$Ammo.hide()
	$ExtraHPLabel.hide()
	$HP.hide()
	$GameOverLabel.hide()
	$FinalScoreLabel.hide()
	$ProgressBar.hide()
	$BossLabel.hide()
	$StartButton.hide()
	$Title.hide()
	$Crawler.hide()
	$SkipButton.hide()
	$ALongTimeAgo.show()

func _on_timer_timeout() -> void:
	match stage:
		0:
			$ALongTimeAgo.show()
		1:
			$ALongTimeAgo.hide()
			$Title.show()
			$ExpandTitle.play("expand")
		2:
			$Timer.stop()
			$Title.hide()
			$Crawler.show()
			$SkipButton.show()
			$Crawl.play("crawl")
			$Crawl.animation_finished.connect(_on_crawl_finished)
	stage += 1
	
func _on_crawl_finished(_anim_name: String) -> void:
	$Crawl.stop()
	$SkipButton.hide()
	$Crawler.hide()
	$Title.show()
	$StartButton.show()

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
	$ProgressBar.hide()
	$BossLabel.hide()
	
	$FinalScoreLabel.text = str(score)
	$StartButton.show()
	$GameOverLabel.show()
	$FinalScoreLabel.show()
	
func _on_start_button_pressed() -> void:
	$StartButton.hide()
	$GameOverLabel.hide()
	$FinalScoreLabel.hide()
	$Title.hide()
	$ScoreLabel.show()
	$ExtraAmmoLabel.show()
	$Ammo.show()
	$ExtraHPLabel.show()
	$HP.show()
	start_game.emit()
	$StartButton.text = "Play Again"
	update_score(0)
	
func display_boss_hp():
	$ProgressBar.value = 100
	$ProgressBar.show()
	$BossLabel.show()
	
func update_boss_hp(hp):
	$ProgressBar.value = hp
	if hp <= 0: 
		$ProgressBar.hide()
		$BossLabel.hide()

func _on_skip_button_button_down() -> void:
		_on_crawl_finished("")
