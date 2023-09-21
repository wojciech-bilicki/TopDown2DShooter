extends CharacterBody2D


var movement_direction = Vector2.ZERO
@export var walking_speed = 100
@export var rotation_speed = 5

var angle

func _physics_process(delta):
	velocity =  movement_direction * walking_speed
	
	move_and_slide()
	if angle:
		global_rotation = lerp_angle(global_rotation, angle, delta * rotation_speed)
	


func _input(event):
	if Input.is_action_pressed("move_backwards"):
		movement_direction = Vector2.DOWN
	elif Input.is_action_pressed("move_forwards"):
		movement_direction = Vector2.UP
	elif Input.is_action_pressed("move_left"):
		movement_direction = Vector2.LEFT
	elif Input.is_action_pressed("move_right"):
		movement_direction = Vector2.RIGHT
	else: 
		movement_direction = Vector2.ZERO
	
	var mouse_position = get_viewport().get_mouse_position()
	var look_direction = (mouse_position - position).normalized()


	angle = (get_global_mouse_position() - self.global_position).angle()



