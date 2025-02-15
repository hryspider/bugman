extends HBoxContainer




func _on_button_pressed():
	Globals.ghosts.erase($Label.text)
	queue_free()
