extends CanvasLayer

signal start_game

var stage = 0
@export var scroll_speed = 10

@onready var score_label = $ScoreLabel
@onready var ammo = $Ammo
@onready var extra_hp_label = $ExtraHPLabel
@onready var hp = $HP
@onready var game_over_label = $GameOverLabel
@onready var final_score_label = $FinalScoreLabel
@onready var start_button = $StartButton
@onready var title = $Title
@onready var crawler = $Crawler
@onready var skip_button = $SkipButton
@onready var a_long_time_ago = $ALongTimeAgo
@onready var timer = $Timer
@onready var expand_title = $ExpandTitle
@onready var crawl = $Crawl
@onready var quit_button: Button = $QuitButton
@onready var audio: AudioStreamPlayer2D = $Intro
@onready var game_song: AudioStreamPlayer2D = $GameSong

func _ready() -> void:
	score_label.hide()
	ammo.hide()
	extra_hp_label.hide()
	hp.hide()
	game_over_label.hide()
	final_score_label.hide()
	start_button.hide()
	quit_button.hide()
	title.hide()
	crawler.hide()
	skip_button.hide()
	a_long_time_ago.show()

func _on_timer_timeout() -> void:
	match stage:
		0:
			a_long_time_ago.show()
		1:
			audio.play()
			a_long_time_ago.hide()
			title.show()
			expand_title.play("expand")
		2:
			timer.stop()
			title.hide()
			crawler.show()
			skip_button.show()
			crawl.play("crawl")
			crawl.animation_finished.connect(_on_crawl_finished)
	stage += 1
	
func _on_crawl_finished(_anim_name: String) -> void:
	crawl.stop()
	skip_button.hide()
	crawler.hide()
	title.show()
	start_button.show()
	quit_button.show()

func update_score(score):
	score_label.text = str(score)

func update_ammo(ammo_count):
	if ammo_count > 0:
		ammo.play("ammo")
		ammo.frame = ammo_count - 1
	else:
		ammo.play("loading")

func update_hp(hp_count):
	if hp_count > 3:
		extra_hp_label.text = str(hp_count) + "✕"
		hp.frame = 3
	elif hp_count > 0:
		extra_hp_label.text = ""
		hp.frame = hp_count - 1

func show_game_over(score: int):
	score_label.hide()
	ammo.hide()
	extra_hp_label.hide()
	hp.hide()
	
	final_score_label.text = str(score)
	start_button.show()
	quit_button.show()
	game_over_label.show()
	final_score_label.show()
	
func _on_start_button_pressed() -> void:
	start_button.hide()
	quit_button.hide()
	game_over_label.hide()
	final_score_label.hide()
	title.hide()
	score_label.show()
	ammo.show()
	extra_hp_label.show()
	hp.show()
	start_game.emit()
	start_button.text = "Play again"
	update_score(0)
	var tween = create_tween()
	tween.tween_property(audio, "volume_db", -40, 2.0)  
	tween.tween_property(game_song, "volume_db", 0, 2.0) 
	if not game_song.playing:
		game_song.play()

func _on_skip_button_button_down() -> void:
	_on_crawl_finished("")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
