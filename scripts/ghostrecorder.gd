extends Node
@onready var file_dialog = $FileDialog
@onready var canvas_layer = $CanvasLayer
@onready var color_picker = $CanvasLayer/ColorChoose/ColorPicker

const STEP = 1.0/60
@onready var player = get_tree().get_first_node_in_group("player")
var ghost_data = "Time,X,Y,frame,flip_h\n"
var curr_step = 0
var finished = false

func _ready():
	if !Globals.record:
		queue_free()
	GlobalTimer.recordfinish.connect(ghost_color_choose)

func _process(delta):
	if !finished:
		while GlobalTimer.time > curr_step:
			ghost_data = ghost_data + "%s,%s,%s,%s,%s\n" % [
				GlobalTimer.time,
				int(player.position.x),
				int(player.position.y),
				player.sprite.frame,
				int(player.sprite.flip_h)
				]
			curr_step += STEP
		if curr_step > 300:
			queue_free()

func ghost_color_choose():
	finished = true
	get_tree().paused = true
	canvas_layer.show()

func save_file():
	ghost_data = str(color_picker.color.to_html(), "\n") + ghost_data
	#player.curr_state = player.states.FREEZE
	canvas_layer.hide()
	file_dialog.show()


func _on_file_dialog_file_selected(path):
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(ghost_data)
