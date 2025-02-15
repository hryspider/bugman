extends CharacterBody2D


const SPEED = 80.0
const JUMP_VELOCITY = -150.0

enum states {GROUND, AIR, WALL, CEILING, FREEZE}
var curr_state := states.AIR
var can_get_shell = true
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 400
var shell = 0
var can_move := true
var timer = 0.0

var conveyors = []
var conveyor_dir = Vector2.ZERO

@onready var checkpoint = position

@onready var shellbullet = preload("res://objects/shellbullet.tscn")
@onready var deathparticle = preload("res://objects/deathparticles.tscn")


@onready var sprite = $Sprite2D
@onready var main_hbox = $CollisionShape2D

@onready var jumpsound = $Jump
@onready var walljumpsound = $Walljump
@onready var sticksound = $Stick

signal player_die

func _ready():
	if Globals.spawnpoint != null:
		position = Globals.spawnpoint

func _physics_process(delta):
	var jump_input = Input.is_action_just_pressed("jump")
	var move_input = Input.get_axis("ui_left", "ui_right")
	var down_input = Input.is_action_pressed("down")
	match curr_state:
		states.GROUND:
			
			can_move = true
			velocity.x = move_input * SPEED
			set_h_flip(move_input)
			set_frame(0)
			if move_input:
				timer += delta * 5
				set_frame(fmod(round(timer), 2))
			if !is_on_floor():
				curr_state = states.AIR
				return
			if jump_input:
				jumpsound.play()
				velocity.y = JUMP_VELOCITY
				curr_state = states.AIR
				return
		states.AIR:
			if is_on_floor():
				sticksound.play()
				curr_state = states.GROUND
				return
			if is_on_wall():
				sticksound.play()
				set_frame(5)
				set_h_flip(get_wall_normal().x)
				curr_state = states.WALL
				return
			if is_on_ceiling():
				sticksound.play()
				set_frame(6)
				curr_state = states.CEILING
				return
			if can_move:
				set_h_flip(move_input)
				velocity.x = move_input * SPEED
			velocity.y += gravity * delta
			if !Input.is_action_pressed("down"):
				velocity.y = min(-JUMP_VELOCITY, velocity.y)
				
			if jump_input and shell > 0:
				velocity.y = JUMP_VELOCITY
				var mybullet = shellbullet.instantiate()
				mybullet.shell_type = shell
				mybullet.position = position
				get_parent().add_child(mybullet)
				shell = 0
			if velocity.y > 0:
				set_frame(4)
			else:
				if velocity.y > JUMP_VELOCITY/3:
					set_frame(2)
				else:
					set_frame(3)
		states.WALL:
			set_frame(5)
			$LockTimer.stop()
			if !is_on_wall():
				curr_state = states.AIR
				sprite.flip_h = !sprite.flip_h
				velocity.y = max(velocity.y, JUMP_VELOCITY/6)
				if velocity.y > 0:
					velocity.x = 0
					can_move = true
				set_frame(3)
				return
			if is_on_floor():
				can_move = true
				curr_state = states.GROUND
				set_frame(0)
			can_move = false
			velocity.x = get_wall_normal().x * -40
			if conveyor_dir.y == 0:
				velocity.y = min(0, velocity.y + gravity * delta)
				if down_input:
					velocity.y = 100
			else:
				velocity.y = conveyor_dir.y * 50
				if down_input:
					velocity.y += 100
			
			if jump_input:
				walljumpsound.play()
				velocity.x = get_wall_normal().x * SPEED
				velocity.y = JUMP_VELOCITY
				$LockTimer.start()
				curr_state = states.AIR
		states.CEILING:
			set_frame(6)
			can_move = true
			$LockTimer.stop()
			if !is_on_ceiling():
				curr_state = states.AIR
				set_frame(3)
				return
			if move_input:
				set_h_flip(move_input)
			velocity.x = move_input * SPEED
			if conveyor_dir.x != 0:
				velocity.x += conveyor_dir.x * 50
			velocity.y = -40
			if jump_input or down_input:
				if jump_input:
					velocity.y = -JUMP_VELOCITY/1.5
					walljumpsound.play()
				if down_input: velocity.y = 10
				curr_state = states.AIR
				set_frame(3)
	if not curr_state == states.FREEZE:
		move_and_slide()


func set_frame(frame):
	sprite.frame_coords = Vector2(frame, min(shell, 1))

func set_h_flip(move_input):
	if move_input == 0: return
	sprite.flip_h = move_input < 0
		

func _on_lock_timer_timeout():
	can_move = true


func die(area):
	can_get_shell = false
	emit_signal("player_die")
	$Die.play()
	var deathinst = deathparticle.instantiate()
	deathinst.position = position
	get_parent().add_child(deathinst)
	hide()
	curr_state = states.FREEZE
	await get_tree().create_timer(0.2).timeout
	position = checkpoint
	curr_state = states.GROUND
	shell = 0
	velocity = Vector2.ZERO
	show()
	await get_tree().create_timer(0.05).timeout
	can_get_shell = true
	


func conveyor_enter_up(area):
	conveyors.append(area)
	conveyor_dir.y = -1
	
func conveyor_enter_down(area):
	conveyors.append(area)
	conveyor_dir.y = 1

func conveyor_enter_left(area):
	conveyors.append(area)
	conveyor_dir.x = -1
	
func conveyor_enter_right(area):
	conveyors.append(area)
	conveyor_dir.x = 1

func conveyor_exit(area):
	conveyors.pop_at(conveyors.find(area))
	if conveyors.size() == 0:
		conveyor_dir = Vector2.ZERO
