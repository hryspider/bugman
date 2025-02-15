extends Area2D



func _on_body_entered(body):
	for i in get_tree().get_nodes_in_group("checkpoint"):
		i.modulate = Color.DARK_BLUE
	modulate = Color.GREEN
	if body.checkpoint != position:
		$AudioStreamPlayer.play()
		body.checkpoint = position
