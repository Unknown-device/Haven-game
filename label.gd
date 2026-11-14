extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var elapsed := 0.0

func _process(delta: float) -> void:
	elapsed += delta
	text = "%.1f s" % elapsed
