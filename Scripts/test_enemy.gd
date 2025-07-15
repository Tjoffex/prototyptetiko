extends CharacterBody3D
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var health = 100
var speed = 3
@onready var nav_agent = $NavigationAgent3D


#clean up!
@onready var healthbar = $SubViewport/HealthBar
@onready var player = %PlayerCharacter

const green = preload("res://Assets/enemy_green.tres")
const red = preload("res://Assets/enemy_red.tres")
const yellow = preload("res://Assets/enemy_yellow.tres")

var has_los = false
var chasing = false

func _physics_process(delta: float) -> void:
	
	velocity.y += -gravity * delta
	move_and_slide()
	
	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(global_transform.origin, player.global_transform.origin)
	query.collide_with_areas = true
	var los = space.intersect_ray(query)
	if los.collider == player:
		$MeshInstance3D.material_override = red
		chasing = true
	else:
		$MeshInstance3D.material_override = green
		chasing = false
		
	if chasing:
		nav_agent.set_target_position(player.global_position)
		var next_nav_point = nav_agent.get_next_path_position()
		velocity = (next_nav_point - self.global_position).normalized() * speed
		print("chase")


func hit(damage):
	health -= damage
	
	#TODO compare to start health to count percentage
	healthbar.value = health
	if health < 1:
		queue_free()
