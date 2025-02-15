extends Camera2D

@export var target : NodePath

@onready var screensize := get_viewport_rect().size

#var target_pos = Vector2(128, 100)


func _process(delta):
	position = round((get_node(target).position+screensize/2)/screensize) * screensize - screensize/2
	#position.x = move_toward(position.x, target_pos.x, delta*500)
	#position.y = move_toward(position.y, target_pos.y, delta*500)
	if position.y == -300 and position.x < 1152:
		position.x = clamp(get_node(target).position.x, 128, 896)
