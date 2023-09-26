extends Node

class_name StateMachine

signal transitioned(state_name)


@export var initial_state: NodePath

@onready var state: State = get_node(initial_state)

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		child.state_machine = self
	
	state.enter()

func _process(delta):
	if state.has_method("update"):
		state.update(delta)

func _physics_process(delta):
	if state.has_method("physics_update"):
		state.physics_update(delta)

func transition_to(target_state_name: String, msg: Dictionary = {}):
	if not has_node(target_state_name):
		return
	
	if state.has_method("exit"):
		state.exit()
	state = get_node(target_state_name)
	state.enter(msg)
	emit_signal("transitioned", state.name)
