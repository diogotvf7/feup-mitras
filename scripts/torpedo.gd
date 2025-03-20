class_name Torpedo
extends Area2D

@export var speed = 80

var target

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play()
		
func set_target(t):
	target = t
	rotation -= deg_to_rad(90)

func _physics_process(delta: float) -> void:
	if position.x - 20 >= target.position.x:
		var angle = atan2(target.position.y - position.y, target.position.x - position.x)
		position.x -= abs(cos(angle) * speed * delta)
		position.y += sin(angle) * speed * delta
	else:
		position.x -= speed * delta

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

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
