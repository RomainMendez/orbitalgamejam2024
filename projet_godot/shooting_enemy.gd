extends CharacterBody3D

@export var SPEED = 2.0;

const GRAVITY = 20.0

# The enemy isn't a gatling gun
@export var DELAY_BETWEEN_SHOOT = 3.0;
var until_next_shoot = DELAY_BETWEEN_SHOOT

# When the projectile will be deleted
@export var WEAPON_RANGE = 50.0;

# At which range does the enemy fire
@export var RANGE_TO_FIRE_FROM = 25.0;

@onready var animations : AnimatedSprite3D = $AnimatedSprite3D

var dead = false;

@onready var player: CharacterBody3D = get_tree().get_first_node_in_group("player")

func _ready():
	animations.connect("animation_finished", Callable(self, "playNextAnim").bind(animations))

func playNextAnim(animations_local: AnimatedSprite3D):
	print("Caught you !")
	if animations_local.get_animation() == "shooting":
		animations_local.play("idle")

func can_shoot_again():
	return until_next_shoot < 0

func shoot():
	animations.play("shooting")
	# Case if there's no player
	if player == null:
		return
	# If dead, can't shoot !
	if dead:
		return
	
	print("Shooting !")
	var scene = load("res://shooting_enemy_projectile.tscn")
	var scene_instance = scene.instantiate()
	scene_instance.set_name("pewpew")
	scene_instance.initial_direction = (player.global_position + Vector3(0, 1.5, 0)  - global_position).normalized()
	scene_instance.velocity = (player.global_position + Vector3(0, 1.5, 0) - global_position).normalized()
	
	scene_instance.remaining_distance = WEAPON_RANGE
	add_child(scene_instance)
	
func attempt_fire(delta: float):
	if dead:
		return
	var dist_to_player = global_position.distance_to(player.global_position)
	if until_next_shoot > 0:
		until_next_shoot -= delta
	if dist_to_player < RANGE_TO_FIRE_FROM:
		if can_shoot_again():
			shoot()
			until_next_shoot = DELAY_BETWEEN_SHOOT

func _physics_process(delta):
	
	
	# Shitty Gravity
	velocity.y += GRAVITY * delta
	
	if dead:
		return
	attempt_fire(delta)

func kill():
	dead = true
	$AnimatedSprite3D.play("hurt")
	player.score += 1
