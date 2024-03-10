extends CharacterBody3D

const GRAVITY = 20.0

@onready var animated_sprite_3d = $AnimatedSprite3D

@export var move_speed = 1.0
@export var charge_speed = 15.0
@export var attack_range = 2.0	
@export var charge_range = 15.0
@onready var dash_sound = $dashSound
@onready var crash_sound = $crashSound

enum State {
	PREPARE_CHARGE,
	CHARGE,
	STUNNED,
	PATROLLING,
	DEAD
}

@onready var player : CharacterBody3D = get_tree().get_first_node_in_group("player")
@export var current_state : State = State.PATROLLING


var my_timer = 0.0
var dir = Vector3(0.0,0.0,0.0)


# damage per hit
const damage: int = 5

func _physics_process(delta):
	if player == null:
		return
		
	


	match current_state:
		State.DEAD:
			return
		State.PREPARE_CHARGE:
			target_player()
			my_timer -=1 ;
			if(my_timer == 0):
				current_state=State.CHARGE;
				animated_sprite_3d.play("dash");
				dash_sound.play()

		State.CHARGE:
			attempt_to_kill_player()
			velocity.y -= GRAVITY * delta
			var collision = move_and_collide(dir * charge_speed * delta)
			if (collision):
				current_state=State.STUNNED;
				animated_sprite_3d.play("death")
				crash_sound.play()
				my_timer = 1000.0;

		State.STUNNED:
			my_timer -=1;
			if(my_timer == 0):
				current_state=State.PATROLLING;
				animated_sprite_3d.play("idle")

		State.PATROLLING:
			target_player()
			var dist_to_player = global_position.distance_to(player.global_position)

			if dist_to_player < charge_range:
				my_timer = 500.0
				current_state=State.PREPARE_CHARGE
				animated_sprite_3d.play("charge")
				return
			velocity = dir * move_speed

			# Shitty Gravity
			velocity.y -= GRAVITY * delta
			move_and_slide()

func target_player():
	dir = player.global_position - global_position
	dir.y = 0.0
	dir = dir.normalized()

func attempt_to_kill_player():
	var dist_to_player = global_position.distance_to(player.global_position)
	if dist_to_player > attack_range:
		return
	
	var eye_line = Vector3.UP * 1.5
	var query = PhysicsRayQueryParameters3D.create(global_position+eye_line, player.global_position+eye_line, 1)
	var result = get_world_3d().direct_space_state.intersect_ray(query)
	if result.is_empty():
		player.hurt(damage)

func kill():
	current_state=State.DEAD
	$DeathSound.play()
	animated_sprite_3d.play("death")
	$CollisionShape3D.disabled = true
