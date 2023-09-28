extends Node

class_name HealtSystem

signal player_died

@export var base_health = 15

func take_damage(damage: int):
	base_health -= damage
	print(base_health)
	if base_health <= 0:
		print("died")
		player_died.emit()
