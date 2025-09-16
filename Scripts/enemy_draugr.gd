extends CharacterBody3D
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var max_health = 100
var health = max_health
var speed = 1
var damage_min = 7
var damage_max = 14

#Currently in hit-animation
var is_hit = false
#Currently in attack-animation
var on_target = false

var chasing = false


@onready var nav_agent = $NavigationAgent3D
@onready var player = get_node("../PlayerCharacter")
@onready var healthbar = $HealthBarSprite/HealthBarViewport/HealthBar
@onready var animation = $draugr/AnimationPlayer
#@onready var attack_zone = $AttackZone
#@onready var swordhitbox = $draugr_asset/rig/Skeleton3D/sword/sword/StaticBody3D/SwordHitbox

# states
enum States {
	IDLE,
	RUN,
	ATTACK,
	HIT,
	DEAD,
}
var state : States

func _ready() -> void:
	add_to_group("enemies")
	healthbar.max_value = max_health

	#initial state
	change_state(States.IDLE)
	
func _physics_process(delta: float) -> void:
	velocity.y += -gravity * delta
	look_at(player.global_position)
	move_and_slide()
	look_for_player()
	set_state()
	check_state(state)

#Changes state
func change_state(new_state):
	if state != new_state:
		state = new_state


#Checks what state should be run
func set_state():
	if health < 1:
		change_state(States.DEAD)
	elif is_hit:
		change_state(States.HIT)
	elif on_target:
		change_state(States.ATTACK)
	elif chasing:
		change_state(States.RUN)
	else:
		change_state(States.IDLE)


func check_state(curr_state):
	match curr_state:
			States.DEAD:
				stay()
				animation.play("Death")
				var time = animation.current_animation_length
				await get_tree().create_timer(time).timeout
				queue_free()
			States.HIT:
				stay()
				animation.play("Hit")
				var time = animation.current_animation_length
				await get_tree().create_timer(time).timeout
				is_hit = false
			States.ATTACK:
				stay()
				animation.play("Attack")
				var time = animation.current_animation_length
				await get_tree().create_timer(time).timeout
			States.RUN:
				animation.play("AttackRun")
				chase()
			States.IDLE:
				stay()
				animation.play("Idlestand")


#Manages damage taking
func hit(damage):
	is_hit = true
	health -= damage
	healthbar.value = health

#Checks line of sight and sets chase bool
func look_for_player():
	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(global_transform.origin, player.global_transform.origin)
	query.collide_with_areas = true
	var los = space.intersect_ray(query)
	if los.collider.is_in_group("player"):
		chasing = true
	else:
		chasing = false

#calls movement funcs
func move():
	if chasing and state == States.IDLE:
		chase()
	else:
		stay()

#chase movement
func chase():
	nav_agent.set_target_position(player.global_position)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - self.global_position).normalized() * speed

#standing still
func stay():
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - self.global_position).normalized() * 0


func _on_attack_zone_body_entered(body: Node3D) -> void:
	if body == player:
		on_target = true


func _on_attack_zone_body_exited(body: Node3D) -> void:
	if body == player:
		on_target = false
