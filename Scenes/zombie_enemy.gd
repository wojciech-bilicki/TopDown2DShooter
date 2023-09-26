extends CharacterBody2D

class_name Zombie
 
@export var wandering_speed = 20
@export var navigation_position: Node2D
@onready var navigation_agent_2d = $NavigationAgent2D

func move_to_position(target_position: Vector2):
	#print(target_position)
	var motion = position.direction_to(target_position ) * wandering_speed
	navigation_agent_2d.set_velocity(motion)
	velocity = motion
	move_and_slide()

