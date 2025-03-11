class_name Laser
extends Area2D

const speed = 410

func _physics_process(delta: float) -> void:
	progress(delta)

func progress(delta):
	position.x += speed * delta

func _on_body_entered(body: Node2D) -> void:
	# TODO remove enemy
	queue_free()

func _on_area_entered(area):
	if area is Obstacle:
		var obstacle = area
		obstacle.exploded()
		queue_free()
