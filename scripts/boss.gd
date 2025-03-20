class_name Boss
extends Area2D

@export var max_hp = 100
@export var speed = 100
var screen_size

var hp = 100
signal shot
signal dead(points)

@export var torpedo_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	position.x = screen_size.x
	position.y = screen_size.y / 2
	$ShootTimer.start()
	rotation -= PI/2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if position.x / screen_size.x > 0.8:
		position.x -= speed * delta

func hit() -> void:
	hp -= 5 
	shot.emit(hp)
	if hp <= 0:
		dead.emit(1000)
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.kill_player()

func shoot():
	var torpedo = torpedo_scene.instantiate()
	var player = get_tree().get_first_node_in_group("player")  
	torpedo.set_target(player)
	torpedo.position = position + Vector2(-30, 0)
	torpedo.scale = Vector2(2,2)
	get_parent().add_child(torpedo)

func _on_shoot_timer_timeout() -> void:
	shoot()
