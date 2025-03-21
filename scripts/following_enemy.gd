class_name FollowingEnemy
extends Area2D

signal dead(points)

var speed
var player
var has_died = false
var hp: float

@export var max_hp: float = 2.5
@export var player_scene: PackedScene

func _ready() -> void:
	speed = 20 * randi_range(1, 3)
	player = get_tree().get_first_node_in_group("player")  
	hp = max_hp
	$Node2D/TextureProgressBar.min_value = 0.0
	$Node2D/TextureProgressBar.max_value = max_hp
	$Node2D/TextureProgressBar.step = 0.5
	$Node2D/TextureProgressBar.value = hp

func set_level(level):
	max_hp *= pow(level, 2)
	hp = max_hp
	$Node2D/TextureProgressBar.max_value = max_hp
	$Node2D/TextureProgressBar.value = hp

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
		
func hit(damage: float):
	hp -= damage
	$Node2D/TextureProgressBar.value = hp
	if hp <= 0:
		destroy()
	
func destroy():
	if has_died: return
	$CollisionShape2D.set_deferred("disabled", true)
	has_died = true
	$AnimatedSprite2D.animation = "destruction"
	$AnimatedSprite2D.play()
	emit_signal("dead", 150)
	
	await $AnimatedSprite2D.animation_finished
	queue_free()
