extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func spawn_zombie():
	var enemy = load("res://enemy.tscn").instantiate()
	enemy.set_name("enemy")
	add_child(enemy)

func spawn_shooting_zombie():
	var enemy = load("res://shooting_enemy.tscn").instantiate()
	enemy.set_name("shooting_enemy")
	add_child(enemy)

func spawn_charging_zombie():
	var enemy = load("res://enemyCharge.tscn").instantiate()
	enemy.set_name("charging_enemy")
	add_child(enemy)
	
	
