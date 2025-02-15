extends Sprite2D


var ghost_data = {}
var time = 0
var i = 0


func _ready():
	modulate = ghost_data["Color"]
func _process(delta):
	while GlobalTimer.time > time:
		i+=1
		position.x = int(ghost_data["Data"]["X"][i])
		position.y = int(ghost_data["Data"]["Y"][i])
		time = float(ghost_data["Data"]["Time"][i])
		frame = int(ghost_data["Data"]["frame"][i])
		flip_h = int(ghost_data["Data"]["flip_h"][i])
		if i > len(ghost_data["Data"]["Time"]):
			queue_free()
