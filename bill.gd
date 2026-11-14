extends CharacterBody2D

@export var speed: float = 200.0

func _physics_process(delta):
	velocity.x = speed
	velocity.y = 0

	move_and_slide()
	
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("ball"):
		get_tree().call_group("game", "game_over")
