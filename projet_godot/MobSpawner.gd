extends Node

const MAX_BASE_ENEMY = 200
const MAX_SHOOTING_ENEMY = 75
const MAX_CHARGING_ENEMY = 100

const STARTING_SPAWN_RATE = 10
const STEPS_UNTIL_MINIMUM_SPAWN_RATE = 10
const DECREASE_BY = STARTING_SPAWN_RATE/STEPS_UNTIL_MINIMUM_SPAWN_RATE
const MINIMUM_SPAWN_RATE = 2

var countdown_until_spawn = STARTING_SPAWN_RATE
var spawn_rate = STARTING_SPAWN_RATE

var base_enemy_count = 0
var shooting_enemy_count = 0
var charging_enemy_count = 0

@onready var all_spawners : Array[Node] = self.get_children()
@onready var number_of_spawners = all_spawners.size()

# Called when the node enters the scene tree for the first time.
func _ready():
	print(all_spawners)
	# https://stackoverflow.com/questions/72242732/how-do-i-create-a-timer-in-godot
	add_child(get_timer())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	pass

func get_timer() -> Timer:
	var timer := Timer.new()
	timer.wait_time = 1.0 # 1 second
	timer.autostart = true # start timer when added to a scene
	var timeout_callback = Callable(self, "_on_timer_timeout")
	timer.connect("timeout", timeout_callback)
	return timer

func select_enemy_type():
	var all_valid_types = []
	if base_enemy_count < MAX_BASE_ENEMY:
		all_valid_types.append('base')
	if shooting_enemy_count < MAX_SHOOTING_ENEMY:
		all_valid_types.append('shooting')
	if charging_enemy_count < MAX_CHARGING_ENEMY:
		all_valid_types.append('charging')
		
	if all_valid_types.size() == 0:
		return ""

	else:
		return all_valid_types[randi_range(0, all_valid_types.size()-1)]

func spawn():
	# spawn a new enemy
	var chosen_spawner : int = randi_range(1, number_of_spawners-1)
	print("INDEX SELECTED : " + str(chosen_spawner))
	var spawner = all_spawners[chosen_spawner]
	var type_of_monster : String = select_enemy_type()
	if type_of_monster == "":
		print("Can't spawn new entities !")
		return

	for entry in spawner.get_method_list():
		if "spawn" in str(entry):
			print(entry)

	if type_of_monster == 'base':
		base_enemy_count += 1
		if spawner.has_method("spawn_zombie"):
			spawner.spawn_zombie()
		else:
			print("COULD NOT FIND THE METHOD 1 !")
			print(spawner)
	elif type_of_monster == 'shooting':
		shooting_enemy_count += 1
		
		if spawner.has_method("spawn_shooting_zombie"):
			spawner.spawn_shooting_zombie()
		else:
			print("COULD NOT FIND THE METHOD 2 !")
			print(spawner)
	elif type_of_monster == 'charging':
		charging_enemy_count += 1
		
		if spawner.has_method("spawn_charging_zombie"):
			spawner.spawn_charging_zombie()
		else:
			print("COULD NOT FIND THE METHOD 3 !")
			print(spawner)

	

func _on_timer_timeout():
	if spawn_rate < MINIMUM_SPAWN_RATE:
		spawn_rate = MINIMUM_SPAWN_RATE
	
	if countdown_until_spawn > 0:
		countdown_until_spawn -= 1
		return
	print("Spawning !")
	print(all_spawners)
	spawn()
	countdown_until_spawn = spawn_rate
	spawn_rate -= DECREASE_BY
	print('new mob spawned')
