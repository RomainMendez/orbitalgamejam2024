extends StaticBody3D

var burning: bool = false
@onready var sprite = $Sprite
@onready var player : CharacterBody3D = get_tree().get_first_node_in_group("player")

var health_points = 1000
const burn_tick = 1
const heavy_burn_tick = 50
const texture_folder = "res://"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if burning:
		if health_points > 0:
			health_points -= burn_tick
			player.score += 1
				
		#print(str('burning...', health_points))

func burn():
	if burning == false:
		print('player is burning more trees, nice')
		sprite.play("burning")
		
	burning = true
	
	if health_points > 0:
		# player burns so we allow the player to burn trees faster
		health_points -= heavy_burn_tick
		player.score += 10
