extends AnimatedSprite2D
var hit_something = false
var speed = 200
@onready var pipe_area = $PipeArea 



var shell_type = 0:
	set(value):
		modulate = Globals.shell_colors[value]
		shell_type = value
		$BrickArea.set_collision_mask_value(value + 3, true)
				

func _ready():
	play("default")

func _process(delta):
	position += speed * Vector2(-sin(rotation), cos(rotation)) * delta


func _on_ground_area_body_entered(body):
	queue_free()


func _on_brick_area_body_entered(body):
	if !hit_something:
		body.break_brick()
		hit_something = true
		queue_free()


func _on_pipe_area_area_entered(area):
	var dir_difference = fposmod(rotation - (area.get_parent().rotation+PI/2), 2*PI)
	
	if abs(dir_difference-PI) > 2:
		set_detecting(false)
		hide()
		area.get_parent().shell_enter(self)
	
func set_detecting(value):
	$BrickArea.monitoring = value
	$GroundArea.monitoring = value
	
