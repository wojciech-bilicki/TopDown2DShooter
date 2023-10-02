extends Area2D

var health_restored_amount = 3

func _on_body_entered(body):
	(body as Player).on_health_pickup(health_restored_amount)
	var pickup_stream_player = get_tree().get_first_node_in_group("pickup_player") as AudioStreamPlayer2D
	pickup_stream_player.global_position = global_position
	pickup_stream_player.play()
	queue_free()
