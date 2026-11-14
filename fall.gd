extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 4
	body_entered.connect(_on_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node) -> void:
	print(body.get_path())
	if body == $"../Pluspol":
		self.gravity_scale = -1
	if body == $"../Minuspol":
		self.gravity_scale = 1
