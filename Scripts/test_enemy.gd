extends CharacterBody3D
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var health = 100
var speed = 1
var state = States.idle

enum States {
	idle,
	chase,
	hit,
	dead,
}



@onready var nav_agent = $NavigationAgent3D

#clean up!
@onready var healthbar = $SubViewport/HealthBar
@onready var player = %PlayerCharacter


var has_los = false
var chasing = false

#signals
signal idle_stand_animation
signal idle_walk_animation
signal attack_animation
signal chase_animation
signal hit_animation
signal die_animation

#func _ready() -> void:
	#idle_stand_animation.emit()

func _physics_process(delta: float) -> void:
	
	velocity.y += -gravity * delta
	move_and_slide()
	
	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(global_transform.origin, player.global_transform.origin)
	query.collide_with_areas = true
	var los = space.intersect_ray(query)
	
	if los.collider == player:
		chasing = true
	else:
		chasing = false
	if chasing:
		chase_animation.emit()
		nav_agent.set_target_position(player.global_position)
		var next_nav_point = nav_agent.get_next_path_position()
		look_at(player.global_position)
		velocity = (next_nav_point - self.global_position).normalized() * speed
		
		
	else:
		idle_stand_animation.emit()
		nav_agent.set_target_position(self.global_position)
		var next_nav_point = nav_agent.get_next_path_position()
		velocity = (next_nav_point - self.global_position).normalized() * speed



func hit(damage):
	health -= damage
	hit_animation.emit()
	#TODO compare to start health to count percentage
	healthbar.value = health
	if health < 1:
		die_animation.emit()
		
		queue_free()
