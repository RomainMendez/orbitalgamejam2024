extends Node



# Called when the node enters the scene tree for the first time.
func _ready():
	# https://stackoverflow.com/questions/72242732/how-do-i-create-a-timer-in-godot
	add_child(get_timer())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	pass

func get_timer() -> Timer:
	var timer := Timer.new()
	timer.wait_time = 2.0 # 1 second
	timer.autostart = true # start timer when added to a scene
	var timeout_callback = Callable(self, "_on_timer_timeout")
	timer.connect("timeout", timeout_callback)
	return timer

func _on_timer_timeout():
	print('new mob spawned')
	add_child(get_timer())


