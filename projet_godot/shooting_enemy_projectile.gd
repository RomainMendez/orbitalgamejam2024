extends CharacterBody3D


const SPEED = 3.0
@export var remaining_distance = 450.0
@export var initial_direction = Vector3(0, 0, 0);

func _ready():
	pass

func _physics_process(delta):
	velocity = initial_direction * SPEED
	print(velocity);
	print(remaining_distance)
	if remaining_distance > 0:
		move_and_slide()
		remaining_distance -= SPEED * delta
	else:
		queue_free()


	var collision = move_and_collide(velocity * delta)
	if collision:
		print("Collision !")
		remaining_distance = 0;
		
		var hit = collision.get_collider()
		if hit.has_method("take_damage"):
			print("Damaged player !")
			hit.take_damage(10)
		else:
			print("Hit something else !")
		
		queue_free()


