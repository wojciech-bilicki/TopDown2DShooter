extends State


@onready var navigation_agent_2d = $"../../NavigationAgent2D" as NavigationAgent2D
@export var wandering_radius = 500
@export var should_draw = false

var random_position_in_radius
var navigation_map 
var skip_first_frame = false

func _ready():
	
	navigation_map = get_tree().get_first_node_in_group("tilemap").get_navigation_map(0)
	NavigationServer2D.agent_set_map(navigation_agent_2d.get_rid(), navigation_map)	
	
func enter(msg = {}) -> void:
	navigation_agent_2d.set_navigation_map(navigation_map)
	
	move_to_next_random_wandering_location()
		
		
func _physics_process(delta):
	if !skip_first_frame:
		skip_first_frame = true
		return

	if navigation_agent_2d.target_position != Vector2.ZERO && navigation_agent_2d.is_navigation_finished():
		move_to_next_random_wandering_location()
	else:
		var next_position = navigation_agent_2d.get_next_path_position()
		(owner as Zombie).move_to_position(next_position)
	
func get_random_position_in_radius(radius: float) -> Vector2:
	var global_position = owner.global_position
	var random_angle = randf() * 360.0
	var radius_vector = Vector2.from_angle(random_angle) * radius
	return global_position + radius_vector

func move_to_next_random_wandering_location():
	#print(owner)
	random_position_in_radius = (owner as Zombie).navigation_position.position
	navigation_agent_2d.target_position = random_position_in_radius
	#print_debug(navigation_agent_2d.is_target_reached())
	#print_debug(navigation_agent_2d.get_final_position())
	#print_debug(navigation_agent_2d.is_target_reachable())
	#print_debug(navigation_agent_2d.get_current_navigation_result().path)


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	print(safe_velocity)
