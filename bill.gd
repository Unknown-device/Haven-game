extends CharacterBody2D

@export var speed: float = 100.0
@export var acceleration: float = 5.0
@export var max_speed: float = 500.0

func _physics_process(delta):
	# Gradually increase speed
	speed = min(speed + acceleration * delta, max_speed)

	velocity.x = speed
	velocity.y = 0

	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	print(body.get_path())

	if body.is_in_group("ball"):
		get_tree().call_group("game", "game_over")
