extends CharacterBody2D

@export var speed = 100
var input := Vector2.ZERO

@onready var sprite : Sprite2D = $Sprite2D
@onready var shoot_animation : AnimatedSprite2D = $ShootAnimation

var laser = preload("res://scenes/laser.tscn").instantiate()

func _ready() -> void:
	respawn()
	
func respawn() -> void:
	var x = -30
	var y = get_viewport().content_scale_size.y / 2
	position = Vector2(x, y)
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(x + 100, y), 0.5 )

func _process(delta):
	move(delta)
	update()
	limit_position()
	
	# if space is pressed
	if Input.is_action_just_pressed("ui_accept"):
		shoot()

func move(delta):
	input = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	position += input * speed * delta

# updates the animation
func update():
	# going up
	if input.y > 0: 
		sprite.frame = 1
	
	# going down
	elif input.y < 0:
		sprite.frame = 2
	else:
		sprite.frame = 0
		

func limit_position():
	position.x = clamp(position.x, 0, get_viewport().content_scale_size.x)
	position.y = clamp(position.y, 0, get_viewport().content_scale_size.y)
	
func shoot():
	shoot_animation.play("flash")
	get_parent().add_child(laser)
	laser.position = position + Vector2(30, 0)
