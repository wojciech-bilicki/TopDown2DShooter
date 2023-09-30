extends CharacterBody2D

class_name Zombie
 
@onready var navigation_agent_2d = $NavigationAgent2D
@onready var state_machine = $StateMachine as StateMachine
@onready var health_system = $HealthSystem as HealtSystem

@export var health: float = 25

@export_group("Locomotion")
@export var rotation_speed: float = 2
@export var wandering_speed = 20
@export var navigation_position: Node2D

@export_group("Scanning for player")
@export var angle_cone_of_vision := 90
@export var max_vision_distance = 250
@export var angle_between_rays = 30
@onready var vision_ray_cast_2d = $VisionRayCast2D as RayCast2D

# attack variables 
@export_group("Attack variables")
@export_range(0.1, 1) var attack_speed:float = 1
@export_range(1, 10) var attack_damage:float = 2

@export_group("Chasing")
@export var chance_to_stop_chase: float = .5
@export var distance_to_stop_chasing = 250

func _ready():
	var navigation_map = get_tree().get_first_node_in_group("tilemap").get_navigation_map(0)
	NavigationServer2D.agent_set_map(navigation_agent_2d.get_rid(), navigation_map)	
	navigation_agent_2d.set_navigation_map(navigation_map)
	health_system.died.connect(on_died)

func move_to_position(target_position: Vector2):
	var motion = position.direction_to(target_position ) * wandering_speed
	navigation_agent_2d.set_velocity(motion)
	look_at(target_position)
	velocity = motion
	move_and_slide()

func _physics_process(delta):
	search_for_player_with_raycast()

func search_for_player_with_raycast():
	
	if state_machine.state_name != "Idle" and state_machine.state_name != "Wandering":
		return
	
	var cast_count = int(angle_cone_of_vision / angle_between_rays) + 1
	
	for index in cast_count:
		var cast_vector = max_vision_distance * Vector2.UP.rotated(rad_to_deg(angle_between_rays) * (index - cast_count) / 2.0)
		vision_ray_cast_2d.target_position = cast_vector
		vision_ray_cast_2d.force_raycast_update()
		
		
		if vision_ray_cast_2d.is_colliding() && vision_ray_cast_2d.get_collider() is Player:
			state_machine.transition_to("Chase")

func take_damage(damage: int):
	health_system.take_damage(damage)
	
func on_died():
	queue_free()
