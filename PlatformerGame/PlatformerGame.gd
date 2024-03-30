class_name PlatformerGame
extends Node2D

static var alalimones_path = "res://alalimones/"
var alalimones: Array[PackedScene]

@onready var level_scene: PackedScene = preload ("res://Level/Level.tscn")

@onready var sun := $Sun
@onready var next_game_container := $CurrentGameContainer

var current_level: Level
var next_level: Level
var current_game_idx := 0
var current_game: Node2D
var screen_width = 1152

func _ready():
	alalimones = load_alalimones()
	print("Alalimones loaded: ", alalimones)
	setup_next_game()

func _process(_delta):
	sun.position.x += _delta * current_level.level_speed / 2
	if sun.position.x > screen_width:
		sun.position.x = 0
	if current_level.position.x > - screen_width:
		return
	setup_next_game()

func setup_next_game():
	if next_level == null:
		next_level = setup_next_level(0)
	if current_level != null:
		current_level.queue_free()
	current_level = next_level
	current_level.name = "CurrentLevel"
	if current_game != null:
		current_game.queue_free()
	var new_game = alalimones[current_game_idx].instantiate()
	current_game_idx = (current_game_idx + 1) % alalimones.size()
	next_game_container.add_child(new_game)
	new_game.setup(current_level.start_node.position)
	current_game = new_game
	current_game.name = "CurrentGame"
	next_level = setup_next_level()

func setup_next_level(offset: float=screen_width):
	var level = level_scene.instantiate()
	level.name = "NextLevel"
	level.position.x = offset
	print("Next level position: ", level.position)
	add_child(level)
	level.end_level.connect("body_entered", _on_end_node_body_entered)
	return level

func _on_end_node_body_entered(body: Node2D):
	if body.name != "Player": return
	print("End node entered by ", body)
	current_game.player.visible = false
	current_game.process_mode = Node.PROCESS_MODE_DISABLED

func load_alalimones() -> Array[PackedScene]:
	var games: Array[PackedScene] = []
	var directories = DirAccess.get_directories_at(alalimones_path)
	print("Directories: ", directories)
	
	for jammer_dir in directories:
		jammer_dir += "/"
		var explore_dir = DirAccess.open(alalimones_path + jammer_dir)
		# get all directories in explore_dir
		explore_dir.list_dir_begin()
		var next_file = explore_dir.get_next()
		while next_file != "":
			# trim needed because on builds resource files are suffixed with .remap, see here https://github.com/godotengine/godot/issues/66014
			if !next_file.ends_with(".tscn"):
				next_file = explore_dir.get_next()
				continue
			var file_path = alalimones_path + jammer_dir + next_file
			var level = ResourceLoader.load(file_path)
			print("Found alalimones file: ", file_path, ", level: ", level)
			games.append(level)
			next_file = explore_dir.get_next()
	print("Loaded alalimones: ", games)
	return games
