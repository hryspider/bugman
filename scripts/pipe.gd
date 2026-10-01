extends StaticBody2D
class_name Pipe
@onready var animation_player = $AnimationPlayer


@export var target : Pipe

func shell_enter(shell):
	animation_player.play("squash")
	shell.speed = 0
	await get_tree().create_timer(0.5).timeout
	shell.set_detecting(true)
	shell.show()
	
	target.animation_player.play("exit")
	
	var rot = target.rotation
	shell.position = target.position + 10*Vector2(cos(rot), sin(rot))
	shell.rotation = rot - PI/2
	shell.speed = 200
	
	
