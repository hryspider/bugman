extends Control



func _on_button_pressed(extra_arg_0):
	print(extra_arg_0)
	get_tree().change_scene_to_file(extra_arg_0)
