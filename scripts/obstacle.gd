class_name Obstacle 
extends Area2D

enum ObstacleSize{LARGE, SMALL}
@export var size := ObstacleSize.LARGE

@onready var window_size: Vector2  = get_viewport_rect().size

@export var speed: Vector2 = Vector2(10,40)

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

@export var dir := -1

var time := 0.0
var pivot_position := Vector2(0, 0)

signal shot
func _ready() -> void:
	pivot_position = position
	rotation = randf_range(0, 2 * PI)
	
	match size:
		ObstacleSize.LARGE:
			speed.x = randf_range(5, 15)
			speed.y = randf_range(30, 45)
			sprite.texture = preload("res://assets/sprites/obstacle/obstacle.png")
			collision_shape.shape = preload("res://shapes/obstacle-big.tres")
		ObstacleSize.SMALL:
			speed.x = randf_range(15, 25)
			speed.y = randf_range(45, 60)
			
			sprite.texture = preload("res://assets/sprites/obstacle/obstacle-small.png")
			collision_shape.shape = preload("res://shapes/obstacle-small.tres")
	
func _physics_process(delta: float) -> void:
	position.x -= speed.x * delta
	position.y -= speed.y * delta * dir
	
	rotation += 0.01
	
	if position.y > window_size.y  or position.y < 0:
		dir *= -1

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

	
func exploded():
	emit_signal("shot", position, size)
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.kill_player()
		queue_free()
