class_name Enemy
extends Area2D

var speed
var stage = 0
var screen_size

const azeite_scene = preload("res://scenes/azeite.tscn")

func _ready() -> void:
	screen_size = get_viewport_rect().size
	speed = 20 * randi_range(1, 3)
	$StageTimer.start()
	$ShootTimer.start()

func _process(delta: float) -> void:
	if stage == 1 || position.x / screen_size.x > 0.8:
		position.x -= speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.kill_player()
		queue_free()
		
func destroy():
	queue_free()

func _on_stage_timer_timeout() -> void:
	stage = 1
	$ShootTimer.stop()

func shoot():
	var azeite = azeite_scene.instantiate()
	get_parent().add_child(azeite)
	azeite.position = position + Vector2(-30, 0)


func _on_shoot_timer_timeout() -> void:
	if stage == 0:
		shoot()
