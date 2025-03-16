extends Area2D

var powerup_type

@export var dir := -1
@export var speed: Vector2 = Vector2(10,40)
@onready var window_size: Vector2  = get_viewport_rect().size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	var powerup = randi_range(1, 4)
	if powerup == 1:
		powerup_type = "auto-reload"
	elif powerup == 2:
		powerup_type = "invincibility"
	elif powerup == 3:
		powerup_type = "plus-ammo"
	elif powerup == 4:
		powerup_type = "plus-hp"
	
	print(powerup, " ", powerup_type)
	$AnimatedSprite2D.animation = powerup_type
	$AnimatedSprite2D.play()
	
	speed.x = randf_range(15, 25)
	speed.y = randf_range(45, 60)

func _physics_process(delta: float) -> void:
	position.x -= speed.x * delta
	position.y -= speed.y * delta * dir
	
	if position.y > window_size.y  or position.y < 0:
		dir *= -1

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		$PowerUpSound.play()
		body.apply_power(powerup_type)
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
