class_name J1Game
extends BaseJammerGame

@onready var player := $Player

var speed = 500
var direction: Vector2

func setup(start_position: Vector2):
	player.global_position = start_position

func _physics_process(delta):

	direction = Vector2(0, 0)
	if Input.is_action_pressed("ui_right"):
		direction = Vector2(1, 0)
	elif Input.is_action_pressed("ui_left"):
		direction = Vector2( - 1, 0)
	
	if Input.is_action_pressed("ui_up"):
		direction += Vector2(0, -1)

	player.move_and_collide(delta * speed * direction)
