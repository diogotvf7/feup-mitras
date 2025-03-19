class_name Player
extends CharacterBody2D

signal dead

@export var speed = 100
var input := Vector2.ZERO

@onready var sprite : Sprite2D = $Sprite2D
@onready var shoot_animation : AnimatedSprite2D = $ShootAnimation
@onready var timer: Timer = $Timer

const laser_scene = preload("res://scenes/laser.tscn")
const cooldown_time = 3.0

var max_ammo = 3
var ammo = max_ammo
var autoreload = false
var hp = 2
var invincibility = false

func _ready() -> void:
	hide()
	
func respawn() -> void:
	var x = -30
	var y = get_viewport().content_scale_size.y / 2
	position = Vector2(x, y)
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(x + 100, y), 0.5 )
	
	ammo = max_ammo
	set_invincibility()	
	

func reset_stats():
	autoreload = false
	hp = 3
	max_ammo = 3
	
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
	if input.y > 0: 
		sprite.frame = 1 + (3 if invincibility else 0)
	elif input.y < 0:
		sprite.frame = 2 + (3 if invincibility else 0)
	else:
		sprite.frame = 0 + (3 if invincibility else 0)
		

func limit_position():
	position.x = clamp(position.x, 0, get_viewport().content_scale_size.x)
	position.y = clamp(position.y, 0, get_viewport().content_scale_size.y)

func shoot():
	if ammo > 0:
		shoot_animation.play("flash")
		var laser = laser_scene.instantiate()
		get_parent().add_child(laser)
		laser.position = position + Vector2(30, 0)
		ammo -= 1
		
		if ammo == 0:
			timer.start()

func _on_timer_timeout() -> void:
	if autoreload:
		ammo = mini(ammo+1, max_ammo)
	elif ammo == 0:
		ammo = max_ammo

func spawn_explosion():
	var explosion = preload("res://scenes/explosion.tscn").instantiate()
	explosion.position = position
	get_parent().add_child(explosion)
	
func kill_player():
	if (invincibility): return
	spawn_explosion()
	respawn()
	hp -= 1
	if hp == 0:
		dead.emit()

func set_invincibility():
	$InvincibilityTimer.start()
	invincibility = true
	
func _on_invincibility_timer_timeout() -> void:
	invincibility = false

func apply_power(powerup_type) -> void:
	if powerup_type == "auto-reload":
		autoreload = true
		$Timer.wait_time -= 0.2
	if powerup_type == "invincibility":
		set_invincibility()
	if powerup_type == "plus-ammo":
		max_ammo += 1
		ammo = max_ammo
	if powerup_type == "plus-hp":
		hp += 1
		
	
