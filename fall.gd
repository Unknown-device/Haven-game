extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 4
	body_entered.connect(_on_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
@export var speed := 300.0

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var dir := Input.get_axis("ui_left", "ui_right")
	state.linear_velocity.x = dir * speed

func _on_body_entered(body: Node) -> void:
	print(body.get_path())
	var sprite: AnimatedSprite2D = $AnimatedSprite2D
	if body == $"../Pluspol":
		sprite.play("rot")
		self.gravity_scale = -1
	if body == $"../Minuspol":
		self.gravity_scale = 1
		sprite.play("blau")
