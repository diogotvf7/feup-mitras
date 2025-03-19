class_name Azeite
extends Area2D

@export var xspeed = 80
@export var yspeed = 20
@export var rotation_speed = 1.0

var target

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_target(t):
	target = t

func _physics_process(delta: float) -> void:
	position.x -= xspeed * delta
	if target:
		position.y += yspeed * delta * (1 if position.y < target.position.y else -1)
	rotation += rotation_speed * delta

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
