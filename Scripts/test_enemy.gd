extends CharacterBody3D
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var health = 100
var speed = 1
var state = States.idle
var damage_min = 7
var damage_max = 14

#state machine, not implemented
enum States {
	idle,
	run,
	attack,
	hit,
	dead,
}



@onready var nav_agent = $NavigationAgent3D
@onready var player = get_node("../PlayerCharacter")
@onready var healthbar = $HealthBarSprite/HealthBarViewport/HealthBar
@onready var hitbox = $Hitbox/HitboxCollider

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
	hitbox.disabled = true
	idle_stand_animation.emit()
	

func _physics_process(delta: float) -> void:
	velocity.y += -gravity * delta
	look_at(player.global_position)
	move_and_slide()
	look_for_player()
	
	state_machine()
	check_attack()

	

#checks LOS, sets chasing bool
func look_for_player():
	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(global_transform.origin, player.global_transform.origin)
	query.collide_with_areas = true
	var los = space.intersect_ray(query)
	if los.collider.is_in_group("player"):
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

#change to not use navagent
func check_attack():
	if nav_agent.distance_to_target() < 2 and !stopped:
		attacking = true
	else:
		attacking = false

#refactor!
func state_machine():
	if taking_damage and not dead:
		stay()
		hit_animation.emit()
		await get_tree().create_timer(1.25).timeout
		taking_damage = false
	elif chasing and not dead and not attacking:
		stopped = false
		chase_animation.emit()
		chase()
	elif attacking and not dead:
		attack_animation.emit()
		await get_tree().create_timer(0.75).timeout
		hitbox.disabled = false
		#gör skada om i zon
		await get_tree().create_timer(0.75).timeout
		hitbox.disabled = true
		
		attacking = false
	elif dead:
		stay()
		die_animation.emit()
		await get_tree().create_timer(1.25).timeout
		queue_free()
	else:
		idle_stand_animation.emit()
		stay()

func stay():
	stopped = true
	nav_agent.set_target_position(self.global_position)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - self.global_position).normalized() * speed
	
func chase():
	nav_agent.set_target_position(player.global_position)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - self.global_position).normalized() * speed

#replace with wander
func wander():
	idle_walk_animation.emit()
	stay()

#hitbox meets player
func _on_hitbox_body_entered(body: Node3D) -> void:
	if body == player:
		body.take_damage(randi_range(damage_min, damage_max))


#func _on_hitbox_body_exited(body: Node3D) -> void:
#	pass # Replace with function body.
