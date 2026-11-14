extends CanvasLayer

signal resume_requested
signal main_menu_requested
signal quit_requested

@onready var resume_button: Button = $Overlay/CenterContainer/VBoxContainer/ResumeButton
@onready var main_menu_button: Button = $Overlay/CenterContainer/VBoxContainer/MainMenuButton
@onready var quit_button: Button = $Overlay/CenterContainer/VBoxContainer/QuitButton


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	visible = false
	resume_button.pressed.connect(resume_requested.emit)
	main_menu_button.pressed.connect(main_menu_requested.emit)
	quit_button.pressed.connect(quit_requested.emit)


func show_menu() -> void:
	visible = true
	resume_button.grab_focus()


func hide_menu() -> void:
	visible = false


func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return

	if event.is_action_pressed("ui_cancel"):
		resume_requested.emit()
		get_viewport().set_input_as_handled()
