extends Node

class_name ShootingSystem

@export var total_ammo = 40 
@export var magazine_size = 10
var ammo_in_magazine = 0


func _ready():
	ammo_in_magazine = magazine_size
	total_ammo -= ,magazine_size

func _input(event):
	if Input.is_action_just_pressed("shoot"):
		print("Shoot")

