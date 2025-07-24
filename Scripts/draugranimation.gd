extends Node3D

@onready var animation = $AnimationPlayer


func _on_test_enemy_chase_animation() -> void:
	animation.play("AttackRun")


func _on_test_enemy_idle_stand_animation() -> void:
	animation.play("Idlestand")



func _on_test_enemy_attack_animation() -> void:
	animation.play("Attack")


func _on_test_enemy_die_animation() -> void:
	animation.play("Death")



func _on_test_enemy_hit_animation() -> void:
	animation.play("Hit")
	print("hit")
