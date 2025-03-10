extends Area2D

var movement_vector := Vector2(0, -1)
var speed := 50

enum ObstacleSize{LARGE, SMALL}
@export var size := ObstacleSize.LARGE

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	rotation = randf_range(0, 2 * PI)
	
	match size:
		ObstacleSize.LARGE:
			speed = randf_range(30, 50)
			sprite.texture = preload("res://assets/sprites/obstacle/obstacle.png")
			collision_shape.shape = preload("res://shapes/obstacle-big.tres")
		ObstacleSize.SMALL:
			speed = randf_range(50, 70)
			sprite.texture = preload("res://assets/sprites/obstacle/obstacle-small.png")
			collision_shape.shape = preload("res://shapes/obstacle-small.tres")
	
func _physics_process(delta: float) -> void:
	global_position += movement_vector.rotated(rotation) * speed * delta
