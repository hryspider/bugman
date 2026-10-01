extends StaticBody2D

@export var respawn := false
@export var color_type = 1

func _ready():
	if !Engine.is_editor_hint():
		set_collision_layer_value(color_type + 3, true)
	modulate = Globals.shell_colors[color_type]

func break_brick():
	var particles = load("res://objects/brickparticle.tscn").instantiate()
	particles.position = position
	particles.modulate = modulate
	get_parent().add_child(particles)
	
	queue_free()
