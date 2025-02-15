extends CanvasLayer

var checkpoint_button = preload("res://objects/checkpoint_button.tscn")
var checkpoints
@onready var grid_container = $ColorRect/GridContainer
var name_to_id = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	var inst
	var x = 0
	for i in checkpoints:
		inst = checkpoint_button.instantiate()
		inst.text = i.name
		name_to_id[i.name] = x
		inst.pressed.connect(button_press.bind(inst))
		grid_container.add_child(inst)
		x+=1

func button_press(button):
	Globals.spawnpoint = checkpoints[name_to_id[button.text]].position
	get_tree().get_first_node_in_group("player").position = Globals.spawnpoint


func _on_checkpoint_button_pressed():
	Globals.spawnpoint = null
	get_tree().reload_current_scene()
