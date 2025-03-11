extends Node2D

@onready var timer: Timer = $ObstacleSpawner


func _ready() -> void:
	#spawn_obstacle()
	timer.start()
	
	
func spawn_obstacle()->void:
	var obstacle = preload("res://scenes/obstacle.tscn").instantiate()
	obstacle.position = get_random_position()
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
