extends Node2D

@onready var ghost_replayer = preload("res://objects/ghostreplayer.tscn")

func _ready():
	GlobalTimer.color_rect.show()
	GlobalTimer.time = 0
	GlobalTimer.running = true
	for i in Globals.ghosts:
		var ghostinst = ghost_replayer.instantiate()
		ghostinst.ghost_data = Globals.ghosts[i]
		add_child(ghostinst)

func _process(delta):
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("title"):
		get_tree().change_scene_to_file("res://rooms/titlescreen.tscn")
		GlobalTimer.color_rect.hide()
		GlobalTimer.running = false



func level_complete(body):
	GlobalTimer.game_done()
