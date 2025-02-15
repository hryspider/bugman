extends Node

var checkpoints
@onready var menu = preload("res://objects/checkpoint_select.tscn")
var menu_inst
func _ready():
	checkpoints = get_children()
	menu_inst = menu.instantiate()
	menu_inst.checkpoints = checkpoints
	add_child(menu_inst)
	
	
func _process(delta):
	if Input.is_action_just_pressed("warp"):
		menu_inst.visible = !menu_inst.visible
