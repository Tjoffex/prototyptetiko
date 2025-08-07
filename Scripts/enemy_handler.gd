extends Node3D

@export var enemy : PackedScene

@onready var timer = $Spawntimer


func _on_spawntimer_timeout() -> void:
	print("ping")
	spawn()
	
	
func spawn():
	var new_enemy = enemy.instantiate()
	get_parent().add_child(new_enemy)
	new_enemy.global_position = global_position
