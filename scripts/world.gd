extends Node2D

@export var powerup_scene: PackedScene
@export var enemy_scene: PackedScene
@onready var obstacle_timer: Timer = $ObstacleSpawner
@onready var enemy_timer: Timer = $EnemySpawner
@onready var score_timer: Timer = $ScoreTimer
@onready var phase_timer: Timer = $PhaseTimer
const boss_scene = preload("res://scenes/boss.tscn")

@export var powerup_odd := 0.8
var score
var game_stage
	
func _on_phase_timer_timeout() -> void:
	if game_stage == 0:
		enemy_timer.start()
	if game_stage == 1:
		obstacle_timer.start()
	if game_stage == 2:
		$HUD.display_boss_hp()
		var boss = boss_scene.instantiate()
		boss.connect("shot", $HUD.update_boss_hp)
		boss.dead.connect(_on_enemy_dead)
		get_parent().add_child(boss)
	
	game_stage += 1
		
func _ready() -> void:
	$Player.hide()
	
func _on_hud_start_game() -> void:
	$Player.show()
	$Player.reset_stats()
	$Player.respawn()
	score_timer.start()
	phase_timer.start()
	score = 0
	game_stage = 0
	get_tree().call_group("enemies", "queue_free")
	get_tree().call_group("obstacles", "queue_free")
	get_tree().call_group("bosses", "queue_free")
	
	_on_phase_timer_timeout()
	
func _process(delta: float) -> void:
	$HUD.update_ammo($Player.ammo)
	$HUD.update_hp($Player.hp)
	
func spawn_obstacle()->void:
	var obstacle = preload("res://scenes/obstacle.tscn").instantiate()
	obstacle.position = get_random_position()
	obstacle.connect("shot", _on_obstacle_exploded)
	add_child(obstacle)

func spawn_small_obstacle(pos, size):
	var obstacle = preload("res://scenes/obstacle.tscn").instantiate()
	obstacle.position = pos
	obstacle.size = size
	obstacle.dir = 1 if randi() % 2 == 0 else -1
	obstacle.connect("shot", _on_obstacle_exploded)
	
	call_deferred("add_child", obstacle)
	
func get_random_position()->Vector2:
	var x = get_viewport().content_scale_size.x
	# Get a random y position
	var y = get_viewport().content_scale_size.y * randf()
	# Dont spawn enemies too close to vertical limits of the screen
	y = clamp(y, 50, get_viewport().content_scale_size.y - 10)
	return Vector2(x,y)

func _on_obstacle_spawner_timeout() -> void:
	if randf() < 0.2:
		spawn_obstacle()
		
func spawn_explosion(pos):
	var explosion = preload("res://scenes/explosion.tscn").instantiate()
	explosion.position = pos
	get_parent().add_child(explosion)
	
func _on_obstacle_exploded(pos, size):
	var rand = randf()
	
	match size:
		Obstacle.ObstacleSize.LARGE:
			score += 50
			if rand <= powerup_odd:
				spawn_powerup(pos)
			else:
				for i in range(2):
					var offset = Vector2(randf_range(-10, 10), randf_range(-10, 10))
					spawn_small_obstacle(pos + offset, Obstacle.ObstacleSize.SMALL)
		Obstacle.ObstacleSize.SMALL:
			score += 25
			spawn_explosion(pos)
	$HUD.update_score(score)
			

func _on_enemy_spawner_timeout() -> void:
	var enemy = enemy_scene.instantiate()
	var enemy_spawn_location = $EnemyPath/EnemySpawnLocation
	enemy_spawn_location.progress_ratio = randf()
	enemy.position = enemy_spawn_location.position
	var direction = enemy_spawn_location.rotation + PI / 2
	enemy.rotation = direction
	enemy.dead.connect(_on_enemy_dead)
	
	add_child(enemy)

func _on_enemy_dead(points) -> void:
	score += points
	$HUD.update_score(score)

func spawn_powerup(pos) -> void:
	var powerup = powerup_scene.instantiate()
	powerup.position = pos
	
	add_child(powerup)
	
func _on_score_timer_timeout() -> void:
	score += 5
	$HUD.update_score(score)

func _on_player_dead() -> void:
	$HUD.show_game_over(score)
	$Player.ammo = 9999
	$Player.invincibility = true
	
