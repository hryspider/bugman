extends CanvasLayer
@onready var label = $ColorRect/Label
@onready var color_rect = $ColorRect

var time = 0
var running = false

signal recordfinish

func _process(delta):
	if running:
		time += delta
		label.text = format_time(time)

func format_time(input_time):
	return "%02d:%02d:%02d" %[input_time/60, fmod(input_time, 60), fmod(input_time, 1)*100]

func game_done():
	emit_signal("recordfinish")
	running = false
	label.modulate = Color.YELLOW
	get_parent().visible = true
