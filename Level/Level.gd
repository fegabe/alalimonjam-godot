class_name Level
extends Node2D

@onready var start_node := $StartNode
@onready var end_level := $EndLevel

var level_speed = 120 * 2

func _process(delta):
	position.x -= delta * level_speed