extends Area2D

const speed = 410

func _physics_process(delta: float) -> void:
	progress(delta)

func progress(delta):
	position.x += speed * delta

func _on_body_entered(body: Node2D) -> void:
	# TODO remove enemy
	queue_free()
