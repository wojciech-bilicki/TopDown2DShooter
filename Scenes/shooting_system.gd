extends Marker2D

class_name ShootingSystem

signal shot
signal gun_reload(ammo_in_magazine: int, ammo_left: int)
signal ammo_added(total_ammo: int)

@export var max_ammo = 40
@export var total_ammo = 40 
@export var magazine_size = 10

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
		shoot()
		
	if Input.is_action_just_pressed("reload"):
		reload()

func reload():
	if total_ammo <= 0:
		return
	var bullets_missing = magazine_size - ammo_in_magazine
	var reloaded_ammount = bullets_missing if bullets_missing < total_ammo else total_ammo
	total_ammo -= reloaded_ammount
	ammo_in_magazine += reloaded_ammount
	print(ammo_in_magazine)
	print(total_ammo)
	gun_reload.emit(ammo_in_magazine, total_ammo)

func shoot():
	if ammo_in_magazine > 0 :
		var bullet = bullet_scene.instantiate() as Bullet
		bullet.damage_per_bullet = owner.damage_per_bullet
		get_tree().root.add_child(bullet)
	#		
		var move_direction = (get_global_mouse_position() - self.global_position).normalized()
		bullet.move_direction = move_direction
		bullet.global_position = self.global_position
		bullet.rotation = move_direction.angle()
		
		ammo_in_magazine -= 1
		shot.emit(ammo_in_magazine)
	else:
		
		pass


func on_ammo_pickup():
	var ammo_to_add =  max_ammo - total_ammo if total_ammo + magazine_size > max_ammo else magazine_size
	total_ammo += ammo_to_add
	ammo_added.emit(total_ammo)
