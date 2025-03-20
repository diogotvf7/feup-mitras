class_name Bullet
extends Area2D

@export var xspeed = 80

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play()
	rotation -= deg_to_rad(90)

func _physics_process(delta: float) -> void:
	position.x -= xspeed * delta

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var player = body
		player.kill_player()
		queue_free()

func _on_area_entered(area):
	if area is Player:
		var player = area
		player.kill_player()
		queue_free()
