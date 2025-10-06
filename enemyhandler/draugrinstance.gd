extends Node3D

signal sword_collision


func _on_hitbox_body_entered(body: Node3D) -> void:
	sword_collision.emit(body)
