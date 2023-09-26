extends State

@onready var idle_timer = $IdleTimer



func enter(msg = {}) -> void:
	owner.velocity = Vector2.ZERO
	idle_timer.start()
		

func _on_idle_timer_timeout():
	state_machine.transition_to("Wandering")
	idle_timer.stop()
