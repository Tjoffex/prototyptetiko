extends Node3D

@export var enemy : PackedScene

@onready var timer = $Spawntimer

#add enum with spawn coords

func _on_spawntimer_timeout() -> void:
	spawn()
	
	
func spawn():
	var new_enemy = enemy.instantiate()
	get_parent().add_child(new_enemy)
	new_enemy.global_position = global_position

#returns random spawn coordinates from enum
func get_spawn_point():
	pass
	
