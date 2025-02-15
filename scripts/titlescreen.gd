extends Control
@onready var logo = $Logo
@onready var controls = $Controls

var timer = 0

func _on_new_game_pressed():
	get_tree().change_scene_to_file("res://rooms/mainarea.tscn")


func quit():
	get_tree().quit()

func _process(delta):
	timer += delta
	logo.position = Vector2(58 + 5*cos(timer), 3*sin(timer))
	logo.rotation = sin(timer+2)/50


func _on_controls_return_pressed():
	controls.hide()


func _on_controls_pressed():
	controls.show()


func _on_settings_pressed():
	get_tree().change_scene_to_file("res://rooms/settings.tscn")
