extends CharacterBody3D
#controls PC

#variables from settings
var speed : float
var jump_speed : float
var mouse_sensitivity : float
var health : int


var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var target
@onready var aim = %RayCast3D
@onready var collider = $CollisionShape3D
@onready var hitbox = $Hitbox

#ska INTE bo här permanent!
var damage = 20


signal trigger_pulled()
signal trigger_released()
signal new_health(int)
signal dead()



func _ready() -> void:
	set_values()
	add_to_group("player")


func _physics_process(delta: float) -> void:
	velocity.y += -gravity * delta
	var input = Input.get_vector("Left", "Right", "Forward", "Back")
	var movement_dir = transform.basis * Vector3(input.x, 0, input.y)
	velocity.x = movement_dir.x * speed
	velocity.z = movement_dir.z * speed
	if is_on_floor() and Input.is_action_just_pressed("Jump"):
		velocity.y = jump_speed 
	move_and_slide()
	update_health()
	
	
	
	
func _input(event: InputEvent) -> void:
	#handles player rotation and camera tilt
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(70), deg_to_rad(70))
	#handles weapon fireing
	if Input.is_action_pressed("Weapon_fired"):
		trigger_pulled.emit()
	
	if Input.is_action_just_released("Weapon_fired"):
		trigger_released.emit()
		if aim.is_colliding():
			target = aim.get_collider()
			if target.is_in_group("enemies"):
				target.hit(damage) 

#gets values from global Settings
func set_values():
	speed = Settings.speed
	jump_speed = Settings.jump_speed
	mouse_sensitivity = Settings.mouse_sensitivity
	health = Settings.health
	
func update_health():
	new_health.emit(health)
	if health < 1:
		dead.emit()
	
func take_damage(damage):
	health -= damage
	

	
