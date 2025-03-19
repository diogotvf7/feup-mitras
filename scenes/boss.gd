class_name Boss
extends Area2D

@export var hp = 100
@export var speed = 100
var screen_size

signal shot
signal dead(points)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	position.x = screen_size.x
	position.y = screen_size.y / 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if position.x / screen_size.x > 0.5:
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
		queue_free()
