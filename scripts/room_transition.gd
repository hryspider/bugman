extends Area2D

@export_file("*.tscn") var destination_scene
@export var spawn_position : Vector2


func _on_body_entered(body):
	var angle = round(Vector2.UP.rotated(rotation))
	print(angle)
	if angle.x == 0:
		Globals.spawn_pos.x = body.position.x
		Globals.spawn_pos.y = (get_viewport_rect().size.y)-position.y
	if angle.y == 0:
		Globals.spawn_pos.y = body.position.y
		Globals.spawn_pos.x = (get_viewport_rect().size.x)-position.x
	#Globals.spawn_pos = spawn_position
	get_tree().change_scene_to_file(destination_scene)
