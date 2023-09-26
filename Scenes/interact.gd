extends Area2D

var object_to_interact 
@onready var interact_label = $"../InteractLabel"

func _on_body_entered(body):
	if (body as RigidBody2D).has_method("interact"):
		object_to_interact = body
		show_interact_label()
		

func _on_body_exited(body):
	if body == object_to_interact:
		object_to_interact = null
		hide_interact_label()

func _input(event):	
	if Input.is_action_just_pressed("interact") && object_to_interact:
		object_to_interact.interact()
		
	
func show_interact_label():
	interact_label.show()
	
func hide_interact_label():
	interact_label.hide()
