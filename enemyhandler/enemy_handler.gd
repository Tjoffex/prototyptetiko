extends Node3D

@export var enemy : PackedScene

@onready var timer = $Spawntimer
const ENEMY = preload("res://enemyhandler/test_enemy.tscn")

func _on_spawntimer_timeout() -> void:
	print("ping")
	spawn()
func _on_test_enemy_die_animation() -> void:
	print("pong")
	spawn()
func spawn():
	var new_enemy = enemy.instantiate()
	get_parent().add_child(new_enemy)
	new_enemy.global_position = global_position
