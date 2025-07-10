extends CharacterBody3D
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var health = 100
@onready var healthbar = $SubViewport/HealthBar

func _physics_process(delta: float) -> void:
	velocity.y += -gravity * delta
	
	move_and_slide()

func hit(damage):
	health -= damage
	#TODO compare to start health to count percentage
	healthbar.value = health
	if health < 1:
		queue_free()
