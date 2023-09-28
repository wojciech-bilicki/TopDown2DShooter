extends Node

class_name HealtSystem

signal died

@export var base_health = 15
var current_health

func _ready():
	current_health = base_health

func take_damage(damage: int):
	current_health -= damage
	if current_health <= 0:
		died.emit()
