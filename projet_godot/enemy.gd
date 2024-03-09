extends CharacterBody3D

@onready var animated_sprite_3d = $AnimatedSprite3D
@onready var deathsound = $DeathSound

@export var move_speed = 2.0
@export var attack_range = 2.0
var dead = false

@onready var player : CharacterBody3D = get_tree().get_first_node_in_group("Player")

func kill():
	dead = true
	deathsound.play()
	animated_sprite_3d.play("death")
	$CollisionShape3D.disabled = true

func attempt_to_kill_player():
	var dist_to_player: int = global_position.distance_to(player.global_position)
	if dist_to_player > attack_range:
		return
	
	var eye_line = Vector3.UP * 1.5
	var query = PhysicsRayQueryParameters3D.create(global_position + eye_line, player.global_position + eye_line, 1)
	var result = get_world_3d().direct_space_state.intersect_ray(query)
	if result.is_empty():
		player.kill()

func _physics_process(delta):
	if dead:
		return
	if player == null:
		return
	
	# Computing the direction of the user and the associated logic !
	var dir = player.global_position - global_position
	dir.y = 0.0
	dir = dir.normalized()
	
	velocity = dir * move_speed
	
	move_and_slide()
	attempt_to_kill_player()
