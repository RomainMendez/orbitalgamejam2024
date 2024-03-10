extends CharacterBody3D


const SPEED = 8.0
@export var remaining_distance = 450.0
@export var initial_direction = Vector3(0, 0, 0);


func _ready():
	pass

func _physics_process(delta):
	velocity = initial_direction * SPEED
	if remaining_distance > 0:
		remaining_distance -= SPEED * delta
	else:
		queue_free()


	var collision = move_and_collide(velocity * delta)
	if collision:
		print("Collision !")
		remaining_distance = 0;
		
		var hit = collision.get_collider()
		if hit.has_method("hurt"):
			print("Damaged player !")
			hit.hurt(10)
		else:
			print("Hit something else !")
		
		queue_free()


