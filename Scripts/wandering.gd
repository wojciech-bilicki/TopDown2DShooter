extends State


@onready var navigation_agent_2d = $"../../NavigationAgent2D" as NavigationAgent2D
@export var wandering_radius = 500
@export var should_draw = false

var random_position_in_radius
var skip_first_frame = false
func enter(msg = {}) -> void:
	
	move_to_next_random_wandering_location()
		
func physics_update(delta):
	if !skip_first_frame:
		skip_first_frame = true
		return
	if navigation_agent_2d.target_position != Vector2.ZERO && (navigation_agent_2d.is_navigation_finished() || !navigation_agent_2d.is_target_reachable()):
		state_machine.transition_to("Idle")
		return
	else:
		var next_position = navigation_agent_2d.get_next_path_position()
		(owner as Zombie).move_to_position(next_position)
	
func get_random_position_in_radius(max_radius: float) -> Vector2:
	var global_position = owner.global_position
	var random_angle = randf() * 360.0
	var random_point = Vector2.from_angle(random_angle) * randf_range(1.0,max_radius) + global_position
	var navigation_point = NavigationServer2D.map_get_closest_point(navigation_agent_2d.get_navigation_map(), random_point)
	print(navigation_point)
	return navigation_point

func move_to_next_random_wandering_location():
	#print(owner)
	random_position_in_radius = get_random_position_in_radius(wandering_radius)
	navigation_agent_2d.target_position = random_position_in_radius
	#print_debug(navigation_agent_2d.is_target_reached())
	#print_debug(navigation_agent_2d.get_final_position())
	#print_debug(navigation_agent_2d.is_target_reachable())
	#print_debug(navigation_agent_2d.get_current_navigation_result().path)

