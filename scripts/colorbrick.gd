extends StaticBody2D


@export var color_type = 1

func _ready():
	if !Engine.is_editor_hint():
		set_collision_layer_value(color_type + 3, true)
	modulate = Globals.shell_colors[color_type]
