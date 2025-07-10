extends CharacterBody3D
#controls PC

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var speed = 5
var jump_speed = 5
var mouse_sensitivity = 0.005
var target
@onready var aim = $Camera3D/RayCast3D
#ska INTE bo här permanent!
var damage = 20

signal weapon_fired()
signal trigger_pulled()
signal trigger_released()



func _physics_process(delta: float) -> void:
	velocity.y += -gravity * delta
	var input = Input.get_vector("Left", "Right", "Forward", "Back")
	var movement_dir = transform.basis * Vector3(input.x, 0, input.y)
	velocity.x = movement_dir.x * speed
	velocity.z = movement_dir.z * speed
	
	move_and_slide()
	if is_on_floor() and Input.is_action_just_pressed("Jump"):
		velocity.y = jump_speed 
		
	
		

#
func _input(event: InputEvent) -> void:
	#handles player rotation and camera tilt
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(70), deg_to_rad(70))
		
	
	if Input.is_action_pressed("Weapon_fired"):
		weapon_fired.emit()
		trigger_pulled.emit()
	
	if Input.is_action_just_released("Weapon_fired"):
		trigger_released.emit()
		if aim.is_colliding():
			target = aim.get_collider()
			print(target.name)
			if target.has_method("hit"):
				target.hit(damage) 
	
