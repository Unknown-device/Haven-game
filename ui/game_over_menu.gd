extends CanvasLayer

signal retry_requested
signal main_menu_requested
signal quit_requested

@onready var retry_button: Button = $Overlay/CenterContainer/VBoxContainer/RetryButton
@onready var main_menu_button: Button = $Overlay/CenterContainer/VBoxContainer/MainMenuButton
@onready var quit_button: Button = $Overlay/CenterContainer/VBoxContainer/QuitButton


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	visible = false
	retry_button.pressed.connect(retry_requested.emit)
	main_menu_button.pressed.connect(main_menu_requested.emit)
	quit_button.pressed.connect(quit_requested.emit)


func show_menu() -> void:
	visible = true
	retry_button.grab_focus()


func hide_menu() -> void:
	visible = false
