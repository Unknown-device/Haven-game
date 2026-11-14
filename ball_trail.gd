extends Line2D
## World-space motion trail for the ball.
## Samples the target's global position and leaves a fading, tapering line behind it.

@export var target_path: NodePath = ^".."
@export var max_points := 26
@export var min_distance := 3.0
@export var teleport_distance := 220.0

@export_group("Colors")
@export var falling_color := Color(0.53, 0.48, 1.0, 0.8)
@export var rising_color := Color(1.0, 0.42, 0.66, 0.8)

var _target: Node2D
var _points := PackedVector2Array()
var _gradient: Gradient


func _ready() -> void:
	# Keep the trail in world space so the ball's rotation never drags it around.
	top_level = true
	global_transform = Transform2D.IDENTITY

	_target = get_node_or_null(target_path) as Node2D
	if _target == null and get_parent() is Node2D:
		_target = get_parent()

	_gradient = gradient.duplicate()
	gradient = _gradient

	if _target != null:
		_points.append(_target.global_position)
		points = _points


func _physics_process(_delta: float) -> void:
	if _target == null:
		return

	var p := _target.global_position

	if _points.is_empty():
		_points.append(p)
	elif p.distance_to(_points[_points.size() - 1]) > teleport_distance:
		# The ball was reset or teleported; start a fresh trail instead of
		# drawing a huge line across the level.
		_points.clear()
		_points.append(p)
	elif p.distance_to(_points[_points.size() - 1]) >= min_distance:
		_points.append(p)
	else:
		return

	while _points.size() > max_points:
		_points.remove_at(0)

	points = _points
	_update_colors()


func _update_colors() -> void:
	var c := falling_color
	if _target is RigidBody2D and (_target as RigidBody2D).gravity_scale < 0.0:
		c = rising_color

	for i in _gradient.get_point_count():
		var offset := _gradient.get_offset(i)
		_gradient.set_color(i, Color(c, offset * offset * c.a))
