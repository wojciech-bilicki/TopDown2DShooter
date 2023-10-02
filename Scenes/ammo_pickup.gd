extends Area2D

func _on_body_entered(body):
	(body as Player).on_ammo_pickup()
	var pickup_stream_player = get_tree().get_first_node_in_group("pickup_player") as AudioStreamPlayer2D
	pickup_stream_player.global_position = global_position
	pickup_stream_player.play()
	queue_free()


	
