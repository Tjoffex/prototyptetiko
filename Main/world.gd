extends Node3D

signal exit()

@onready var resume_button = $GUI/CanvasLayer/CenterContainer/Control/MainMenu/MarginContainer/VBoxContainer/ResumeButton
@onready var restart_button = $GUI/CanvasLayer/CenterContainer/Control/MainMenu/MarginContainer/VBoxContainer/RestartButton
@onready var go_label = $GUI/CanvasLayer/CenterContainer/Control/MainMenu/MarginContainer/VBoxContainer/GOLabel
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	resume_button.disabled = false
	go_label.visible = false
	get_tree().paused = true
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("exit"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = true
		exit.emit()

#accepted signals
func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()


func _on_player_character_dead() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	resume_button.disabled = true
	go_label.visible = true
	get_tree().paused = true
	exit.emit()
