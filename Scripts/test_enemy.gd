extends CharacterBody3D
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var health = 100
var speed = 1
var state = States.idle

#state machine, not implemented
enum States {
	idle,
	chase,
	hit,
	dead,
}



@onready var nav_agent = $NavigationAgent3D
#brittle nodepaths, not ideal
@onready var player = get_node("../PlayerCharacter")
@onready var healthbar = $HealthBarSprite/HealthBarViewport/HealthBar

var has_los = false
var chasing = false
var dead = false
var taking_damage = false
var attacking = false
var stopped = true


#signals
signal idle_stand_animation
signal idle_walk_animation
signal attack_animation
signal chase_animation
signal hit_animation
signal die_animation


func _ready() -> void:
	add_to_group("enemies")
	idle_stand_animation.emit()
	

func _physics_process(delta: float) -> void:
	velocity.y += -gravity * delta
	look_at(player.global_position)
	move_and_slide()
	look_for_player()
	check_attack()
	
	#refactor!
	if taking_damage and not dead:
		stay()
		hit_animation.emit()
		await get_tree().create_timer(1.25).timeout
		taking_damage = false
	elif chasing and not dead and not attacking:
		stopped = false
		chase_animation.emit()
		nav_agent.set_target_position(player.global_position)
		var next_nav_point = nav_agent.get_next_path_position()
		velocity = (next_nav_point - self.global_position).normalized() * speed
	elif attacking and not dead:
		attack_animation.emit()
		await get_tree().create_timer(1.25).timeout
		attacking = false
	elif dead:
		stay()
		die_animation.emit()
		await get_tree().create_timer(1.25).timeout
		queue_free()
	else:
		idle_stand_animation.emit()
		stay()

#checks LOS, sets chasing bool
func look_for_player():
	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(global_transform.origin, player.global_transform.origin)
	query.collide_with_areas = true
	var los = space.intersect_ray(query)
	
	if los.collider == player:
		chasing = true
	else:
		chasing = false

func hit(damage):
	health -= damage
	taking_damage = true
	healthbar.value = health
	#TODO compare to start health to count percentage
	if health < 1:
		
		dead = true
		
func check_attack():
	if nav_agent.distance_to_target() < 2 and !stopped:
		attacking = true
	else:
		attacking = false

func state_machine():
	pass

func stay():
	stopped = true
	nav_agent.set_target_position(self.global_position)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - self.global_position).normalized() * speed
	
func wander():
	pass
