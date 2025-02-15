extends StaticBody2D
@onready var animation_player = $AnimationPlayer


@export var target : NodePath

func shell_enter(shell):
	animation_player.play("squash")
	get_node(target).animation_player.play("exit")
	
	var rot = get_node(target).rotation
	shell.position = get_node(target).position + 10*Vector2(cos(rot), sin(rot))
	shell.rotation = rot - PI/2
	shell.speed = 200
	
	
