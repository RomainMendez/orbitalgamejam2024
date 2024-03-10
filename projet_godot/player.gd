extends CharacterBody3D

@onready var animated_sprite_2d = $CanvasLayer/GunBase/AnimatedSprite2D
@onready var ray_cast_3d = $RayCast3D
@onready var ray_cast_3d_left = $RayCast3DLeft
@onready var ray_cast_3d_right = $RayCast3DRight
@onready var flame_from_flamethrower = $fire
@onready var shoot_sound = $ShootSound
@onready var flame_start_sound = $flameStartSound
@onready var flame_loop_sound = $flameLoopSound
@onready var flame_end_sound = $flameEndSound


const SPEED = 5.0
const MOUSE_SENS = 0.5

var can_shoot = true
var dead = false
var shooting = false # for sound engine only

var health_points: int = 100
var score: int = 0

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	animated_sprite_2d.animation_finished.connect(shoot_anim_done)
	$CanvasLayer/DeathScreen/Panel/Button.button_up.connect(restart)
	flame_start_sound.connect("finished", _on_flame_finished);
	flame_loop_sound.connect("finished", _on_flame_finished);

# Custom method called when the sound playback finishes
func _on_flame_finished():
	if shooting:
		flame_loop_sound.play()



func _input(event):
	if dead:
		return
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * MOUSE_SENS
		rotation_degrees.x -= event.relative.y * MOUSE_SENS
		rotation_degrees.x = clamp(rotation_degrees.x, -80, 80)	

func _process(delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	if Input.is_action_just_pressed("restart"):
		restart()
	
	if dead:
		return
	if Input.is_action_just_pressed("shoot") and not shooting:
		if not shooting:
			flame_start_sound.play()
			shooting = true;
		animated_sprite_2d.play("shoot")
		shoot()
		flame_from_flamethrower.get_child(0).emitting = true
	if Input.is_action_pressed("shoot"):
		
		shoot()
		flame_from_flamethrower.get_child(0).emitting = true
	if Input.is_action_just_released("shoot"):
		shooting = false;
		flame_end_sound.play()
		flame_loop_sound.stop()
		animated_sprite_2d.play("idle")
		flame_from_flamethrower.get_child(0).emitting = false

func _physics_process(delta):
	if dead:
		return
	var input_dir = Input.get_vector("move_left", "move_right", "move_forwards", "move_backwards")
	var direction = ((transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized() * Vector3(1,0,1)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()


func restart():
	get_tree().reload_current_scene()

func shoot():
	# TODO loop sound???
	# shoot_sound.play()
	if ray_cast_3d.is_colliding() and ray_cast_3d.get_collider().has_method("kill"):
		ray_cast_3d.get_collider().kill()
	if ray_cast_3d.is_colliding() and ray_cast_3d.get_collider().has_method("burn"):
		ray_cast_3d.get_collider().burn()
	if ray_cast_3d_left.is_colliding() and ray_cast_3d_left.get_collider().has_method("kill"):
		ray_cast_3d_left.get_collider().kill()
	if ray_cast_3d_left.is_colliding() and ray_cast_3d_left.get_collider().has_method("burn"):
		ray_cast_3d_left.get_collider().burn()
	if ray_cast_3d_right.is_colliding() and ray_cast_3d_right.get_collider().has_method("kill"):
		ray_cast_3d_right.get_collider().kill()
	if ray_cast_3d_right.is_colliding() and ray_cast_3d_right.get_collider().has_method("burn"):
		ray_cast_3d_right.get_collider().burn()

func shoot_anim_done():
	can_shoot = true

func kill():
	dead = true
	print('player is dead')
	$CanvasLayer/HealthBar.hide()
	$CanvasLayer/Score.hide()
	$CanvasLayer/DeathScreen.show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func hurt(damage: int):
	# no need to lower anymore
	if health_points <= 0:
		return
	health_points -= damage
	# print('player took damage! health points: ', health_points)
	if health_points <= 0:
		kill()
		
