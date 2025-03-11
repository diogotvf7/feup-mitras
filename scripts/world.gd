extends Node2D

@onready var timer: Timer = $ObstacleSpawner


func _ready() -> void:
	spawn_obstacle() # for testing purposes
	timer.start()
	
	
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
	
	add_child(obstacle)
	
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

func _on_obstacle_exploded(pos, size):
	for i in range(2):
		match size:
			Obstacle.ObstacleSize.LARGE:
				var offset = Vector2(randf_range(-10, 10), randf_range(-10, 10))
				spawn_small_obstacle(pos + offset, Obstacle.ObstacleSize.SMALL)
			Obstacle.ObstacleSize.SMALL:
				pass
			
