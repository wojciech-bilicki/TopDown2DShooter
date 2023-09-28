extends Node

class_name ShootingSystem


func _input(event):
	if Input.is_action_just_pressed("shoot"):
		print("Shoot")
