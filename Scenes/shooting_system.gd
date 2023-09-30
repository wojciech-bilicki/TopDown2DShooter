extends Marker2D

class_name ShootingSystem

@export var total_ammo = 40 
@export var magazine_size = 10

@onready var shooting_point = $"../ShootingPoint" as Marker2D

var ammo_in_magazine = 0

var crosshair = preload("res://Assets/crosshair_white-export.png")
@onready var bullet_scene = preload("res://Scenes/bullet.tscn")

func _ready():
	#set cursor 
	Input.set_custom_mouse_cursor(crosshair)
	ammo_in_magazine = magazine_size
	total_ammo -= magazine_size

func _input(event):
	
	if Input.is_action_just_pressed("shoot"):
		
		var bullet = bullet_scene.instantiate() as Bullet
		bullet.damage_per_bullet = owner.damage_per_bullet
		get_tree().root.add_child(bullet)
		
		var mouse_position = event.global_position as Vector2
#		
		var move_direction = (get_global_mouse_position() - shooting_point.global_position).normalized()
		bullet.move_direction = move_direction
		bullet.global_position = shooting_point.global_position
		bullet.rotation = move_direction.angle()

func reload():
	if total_ammo <= 0:
		return
	var reloaded_ammount = total_ammo if total_ammo < magazine_size else magazine_size
	total_ammo -= reloaded_ammount
	ammo_in_magazine += reloaded_ammount


