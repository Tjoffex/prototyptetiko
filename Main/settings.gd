extends Node

#set up variables with default values
@export_category("Player Settings")
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var speed = 6
var jump_speed = 5
var mouse_sensitivity = 0.005
var target
var health = 100
var test = "rätt"

func _ready() -> void:
	pass
	
