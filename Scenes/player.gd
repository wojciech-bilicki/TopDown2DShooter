extends CharacterBody2D

class_name Player

@export var walking_speed = 300
@export var rotation_speed = 5
@export var linked_position_node: Node2D
@export var player_ui: PlayerUI

@export var damage_per_bullet = 5
@onready var health_system = $HealthSystem as HealtSystem	
@onready var shooting_system = $ShootingSystem as ShootingSystem

@onready var shot_stream_player = $ShotStreamPlayer as AudioStreamPlayer2D
@onready var reload_stream_player = $ReloadStreamPlayer as AudioStreamPlayer2D


var movement_direction = Vector2.ZERO
var angle
var has_key = false

func _ready():
	health_system.died.connect(on_died)
	player_ui.set_life_bar_max_value(health_system.base_health)
	player_ui.set_max_ammo(shooting_system.magazine_size)
	player_ui.set_ammo_left(shooting_system.total_ammo)
	shooting_system.shot.connect(on_shot)
	shooting_system.gun_reload.connect(on_gun_reload)
	shooting_system.ammo_added.connect(on_ammo_added)

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


func take_damage(damage: int):

	health_system.take_damage(damage)
	player_ui.update_life_bar_value(health_system.current_health)

func on_shot(ammo_in_magazine: int):
	if !shot_stream_player.playing:
		shot_stream_player.play()
	
	player_ui.bullet_shot(ammo_in_magazine)

func on_gun_reload(ammo_in_magazine: int, ammo_left: int):
	reload_stream_player.play()
	player_ui.gun_reloaded(ammo_in_magazine, ammo_left)
	
func on_ammo_pickup():
	shooting_system.on_ammo_pickup()

func on_ammo_added(total_ammo: int):
	player_ui.set_ammo_left(total_ammo)
	
func on_health_pickup(health_restored_ammount: int):
	health_system.on_health_pickup(health_restored_ammount)
	player_ui.life_bar.value += health_restored_ammount

func on_key_pickup():
	has_key = true
	player_ui.on_key_pickup()
	
func update_extract_timer(time_left: float):
	player_ui.update_extract_timer(time_left)

func hide_extract_countdown():
	player_ui.hide_extract_countdown()
	
func extract():
	player_ui.on_game_over(false)
	queue_free()

func on_died():
	player_ui.on_game_over(true)
	queue_free()
