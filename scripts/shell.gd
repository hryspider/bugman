extends Area2D

@export var color_type = 0
@onready var animation_player = $AnimationPlayer

func _ready():
	modulate = Globals.shell_colors[color_type]
	monitoring = true
	if color_type == 0:
		$Sprite2D.texture = preload("res://sprites/shellstop.png")
		animation_player.speed_scale = 6
		$AudioStreamPlayer.stream = load("res://sfx/loseshell.wav")


func _on_body_entered(body):
	if (color_type == 0 or body.shell == 0) and (body.can_get_shell or Globals.dead_shells):
		body.shell = color_type
		body.sprite.material.set_shader_parameter("ShellColor", Globals.shell_colors[color_type])
		animation_player.stop()
		animation_player.play("collect")
		animation_player.play()
