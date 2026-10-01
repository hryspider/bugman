@tool
extends Node

var colors = [
	Color.WHITE,
	Color.RED,
	Color.YELLOW,
	Color.MAGENTA,
	Color.BLUE,
	Color.CYAN
	]

var color_type = 0


func _process(delta):
	if get_parent().color_type != color_type and Engine.is_editor_hint():
		color_type = get_parent().color_type
		get_parent().modulate = colors[color_type]
