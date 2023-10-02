extends Node

class_name HealtSystem

signal died
signal damage_taken(current_health)

@export var base_health = 15
var current_health

func _ready():
	current_health = base_health

func take_damage(damage: int):
	current_health -= damage
	damage_taken.emit(current_health)
	if current_health <= 0:
		died.emit()

func on_health_pickup(health_amount_restored: int):
	current_health += health_amount_restored
