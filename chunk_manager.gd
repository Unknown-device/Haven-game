extends Node2D
## Endless chunk spawner with recycling.
## Chunks are spawned ahead of the ball and freed once they fall behind the camera.
##
## Setup:
##   - Place this node at (0, 64) in main.tscn (same y as the old Chunk01).
##   - Assign your chunk scenes to chunk_scenes.
##   - Leave ball_path empty to auto-find the node in the "ball" group.

const CHUNK_WIDTH := 1152.0
const VIEW_HALF := CHUNK_WIDTH / 2.0
const AHEAD := 2    ## Extra chunks kept past the right edge of the screen.
const BEHIND := 1   ## Extra chunks kept behind the left edge of the screen.

@export var chunk_scenes: Array[PackedScene] = []
@export var ball_path: NodePath
@export var start_x := 0.0
@export var avoid_immediate_repeat := true
@export var random_seed := 0

var _ball: Node2D
var _next_x := 0.0
var _active: Array[Node2D] = []
var _last_index := -1


func _ready() -> void:
	if chunk_scenes.is_empty():
		push_error("ChunkManager: assign at least one scene to chunk_scenes.")
		return

	if random_seed != 0:
		seed(random_seed)

	_next_x = start_x

	_ball = get_node_or_null(ball_path) as Node2D
	if _ball == null:
		_ball = get_tree().get_first_node_in_group("ball")
	if _ball == null:
		push_error("ChunkManager: no ball found. Set ball_path or add the ball to the 'ball' group.")
		return

	_ensure_ahead()


func _process(_delta: float) -> void:
	if _ball == null:
		return
	_ensure_ahead()
	_free_behind()


func _ensure_ahead() -> void:
	var target := _ball.global_position.x + VIEW_HALF + CHUNK_WIDTH * AHEAD
	while _next_x < target:
		_spawn_next()


func _spawn_next() -> void:
	var idx := _pick_index()
	if idx < 0:
		return

	var chunk := chunk_scenes[idx].instantiate() as Node2D
	chunk.position = Vector2(_next_x, 0.0)
	add_child(chunk)
	_active.append(chunk)
	_next_x += CHUNK_WIDTH
	_last_index = idx


func _free_behind() -> void:
	var cutoff := _ball.global_position.x - VIEW_HALF - CHUNK_WIDTH * BEHIND
	while not _active.is_empty():
		var oldest := _active[0]
		if oldest.position.x + CHUNK_WIDTH >= cutoff:
			break
		_active.pop_front()
		oldest.queue_free()


func _pick_index() -> int:
	if chunk_scenes.is_empty():
		return -1

	var idx := randi() % chunk_scenes.size()
	if avoid_immediate_repeat and chunk_scenes.size() > 1:
		while idx == _last_index:
			idx = randi() % chunk_scenes.size()
	return idx
