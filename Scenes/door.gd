extends RigidBody2D

@export var degrees_rotation_when_open = 180
@export var is_closed = true

var starting_rotation 
func _ready():
	starting_rotation = rotation_degrees

func _process(delta):
	if is_closed && rotation_degrees != starting_rotation:
		var current_rotation = deg_to_rad(rotation_degrees)
		var starting_degrees = deg_to_rad(starting_rotation)
		rotation_degrees = rad_to_deg(lerp_angle(current_rotation, starting_degrees, .5))
	elif !is_closed && rotation_degrees != degrees_rotation_when_open:
		var current_rotation = deg_to_rad(rotation_degrees)
		var degrees_when_open = deg_to_rad(degrees_rotation_when_open)
		rotation_degrees = rad_to_deg(lerp_angle(current_rotation, degrees_when_open, .1))

func interact():	
	is_closed =! is_closed
