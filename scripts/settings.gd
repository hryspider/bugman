extends Control
@onready var file_dialog = $FileDialog
@onready var dead_shells = $"HBoxContainer/VBoxContainer/Dead Shells"
@onready var timer = $HBoxContainer/VBoxContainer/Timer
@onready var ghost_list = $HBoxContainer/GhostList
@onready var record_ghost = $"HBoxContainer/VBoxContainer/Record Ghost"

@onready var ghost_icon = preload("res://objects/ghost_icon.tscn")

func _ready():
	dead_shells.button_pressed = GlobalTimer.visible
	dead_shells.button_pressed = Globals.dead_shells
	record_ghost.button_pressed = Globals.record
	display_ghosts()
		

func display_ghosts():
	for i in get_tree().get_nodes_in_group("ghosticons"):
		i.queue_free()
	for i in Globals.ghosts:
		var ghost_inst = ghost_icon.instantiate()
		ghost_inst.get_node("Label").modulate = Globals.ghosts[i]["Color"]
		ghost_inst.get_node("Label").text = i
		ghost_inst.get_node("Time").text = GlobalTimer.format_time(int(Globals.ghosts[i]["Data"]["Time"][-1]))
		ghost_list.add_child(ghost_inst)

func _on_timer_toggled(toggled_on):
	GlobalTimer.visible = toggled_on


func _on_return_pressed():
	get_tree().change_scene_to_file("res://rooms/titlescreen.tscn")


func _on_dead_shells_toggled(toggled_on):
	Globals.dead_shells = toggled_on


func _on_load_ghost_pressed():
	file_dialog.show()


func _on_file_dialog_files_selected(paths):
	var attributes = {
		"Time": -1,
		"X": -1,
		"Y": -1,
		"frame": -1,
		"flip_h": -1
		}
	for p in paths:
		var file = FileAccess.open(p, FileAccess.READ)
		var color = file.get_csv_line()[0]
		var header = file.get_csv_line()
		var ghost_data = {}
		var used_attributes = {}
		for i in attributes:
			attributes[i] = header.find(i)
			if attributes[i] != -1:
				used_attributes[i] = attributes[i]
				ghost_data[i] = []
		if (
			used_attributes.has("Time") and
			used_attributes.has("X") and
			used_attributes.has("Y")
		):
			var line
			line = file.get_csv_line()
			while !file.eof_reached():
				
				for i in used_attributes:
					ghost_data[i].append(line[used_attributes[i]])
					#await get_tree().create_timer(0.1).timeout
				line = file.get_csv_line()
			var ghostname = p.split("/")[-1].replace(".csv", "")
			Globals.ghosts[ghostname] = {"Color": color, "Data": ghost_data}
		else:
			print("error!")
		file.close()
	display_ghosts()


func _on_record_ghost_toggled(toggled_on):
	Globals.record = toggled_on
