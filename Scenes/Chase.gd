extends State

@onready var navigation_agent_2d = $"../../NavigationAgent2D" as NavigationAgent2D
@onready var random_target_chase_update_timer = $RandomTargetChaseUpdateTimer as RandomTimer
@onready var sprite_2d = $"../../Sprite2D" as Sprite2D
@onready var zombie_sounds = $"../../ZombieSounds"


var texture_chase = preload("res://Assets/zombie_walking.png")
var texture_default = preload("res://Assets/zombie_standing.png")

var chance_to_stop_chase: float = .5
var distance_to_stop_chasing = 250

func enter(msg = {}) -> void:
	
	if owner.is_queued_for_deletion():
		return
	
	var random_stream_player = zombie_sounds.get_children().pick_random()
	random_stream_player.play()
	
	_on_random_target_chase_update_timer_timeout()
	
	sprite_2d.texture = texture_chase
	owner.current_speed = owner.chasing_speed

func physics_update(delta: float):
	
	if navigation_agent_2d.is_navigation_finished():
		if try_to_stop_chasing():
			return
		
		var player = get_tree().get_first_node_in_group("player")
		if player == null:
			return
		var player_position = get_tree().get_first_node_in_group("player").global_position
		var navigation_point = NavigationServer2D.map_get_closest_point(navigation_agent_2d.get_navigation_map(), player_position)
		navigation_agent_2d.target_position = player_position
			
	var next_position = navigation_agent_2d.get_next_path_position()
	(owner as Zombie).move_to_position(next_position)
	
	
func _on_random_target_chase_update_timer_timeout():
	if try_to_stop_chasing():
		return
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	var player_position = player.global_position
	var navigation_point = NavigationServer2D.map_get_closest_point(navigation_agent_2d.get_navigation_map(), player_position)
	navigation_agent_2d.target_position = navigation_point
	random_target_chase_update_timer.setup()

func try_to_stop_chasing() -> bool:
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return false
	var player_position = player.global_position
	var distance_to_player = (owner as Zombie).global_position.distance_to(player_position)
	if distance_to_player > distance_to_stop_chasing && randf() > chance_to_stop_chase:
		return stop_chasing()
	return false
		
func stop_chasing() -> bool:
	
	var new_state = ["Idle", "Wandering"].pick_random()
	state_machine.transition_to(new_state)
	return true

func exit():
	random_target_chase_update_timer.stop()
	sprite_2d.texture = texture_default
	owner.current_speed = owner.wandering_speed

func _on_attack_area_body_entered(body):
	state_machine.transition_to("Attack")
