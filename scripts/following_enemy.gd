class_name FollowingEnemy
extends Area2D

signal dead(points)

var speed
var player
var has_died = false

@export var player_scene: PackedScene


func _ready() -> void:
	if !has_died:
		speed = 20 * randi_range(1, 3)
		speed = 1 * speed
		player = get_tree().get_first_node_in_group("player")  


func _process(delta: float) -> void:
	if has_died: return
	if position.x - 20 >= player.position.x:
		var angle = atan2(player.position.y - position.y, player.position.x - position.x)
		position.x -= abs(cos(angle) * speed * delta)
		position.y += sin(angle) * speed * delta
		look_at(player.position)
		rotation -= deg_to_rad(90)
	else:
		position.x -= speed * delta
		
	
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is Player && !has_died:
		body.kill_player()
		queue_free()
		
func destroy():
	if has_died: return
	$CollisionShape2D.set_deferred("disabled", true)
	has_died = true
	$AnimatedSprite2D.animation = "destruction"
	$AnimatedSprite2D.play()
	emit_signal("dead", 150)
	
	await $AnimatedSprite2D.animation_finished
	queue_free()
