extends Node2D

@onready var pause_menu: CanvasLayer = $PauseMenu
@onready var game_over_menu: CanvasLayer = $GameOverMenu

var game_over_active := false


func _ready() -> void:
	add_to_group("game")
	pause_menu.resume_requested.connect(_resume)
	pause_menu.main_menu_requested.connect(_go_to_main_menu)
	pause_menu.quit_requested.connect(_quit_game)
	game_over_menu.retry_requested.connect(_retry)
	game_over_menu.main_menu_requested.connect(_go_to_main_menu)
	game_over_menu.quit_requested.connect(_quit_game)


func _unhandled_input(event: InputEvent) -> void:
	if game_over_active:
		return

	if event.is_action_pressed("ui_cancel"):
		if get_tree().paused:
			_resume()
		else:
			_pause()
		get_viewport().set_input_as_handled()


func _pause() -> void:
	if game_over_active:
		return
	pause_menu.show_menu()
	get_tree().paused = true


func _resume() -> void:
	get_tree().paused = false
	pause_menu.hide_menu()


func game_over() -> void:
	if game_over_active:
		return

	game_over_active = true
	pause_menu.hide_menu()
	get_tree().paused = true
	game_over_menu.show_menu()


func _retry() -> void:
	get_tree().paused = false
	game_over_active = false
	get_tree().reload_current_scene()


func _go_to_main_menu() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")


func _quit_game() -> void:
	get_tree().quit()
