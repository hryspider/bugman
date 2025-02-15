extends Node2D

@onready var shells = get_children()


func reset_shells():
	for i in shells:
		i.animation_player.stop()
		i.animation_player.play("respawn")
