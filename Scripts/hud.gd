extends Node2D
@onready var _crosshair = $CanvasLayer/CenterContainer/Control/Crosshair


func _ready() -> void:
	_crosshair.play("default")



func _on_player_character_trigger_pulled() -> void:
	_crosshair.play("trigger_held")

func _on_player_character_trigger_released() -> void:
	_crosshair.play("default")
	#trigger enemy hitcheck

func _on_world_exit() -> void:
	%MainMenu.visible = true
	_crosshair.visible = false

func _on_resume_button_pressed() -> void:
	%MainMenu.visible = false
	_crosshair.visible = true
