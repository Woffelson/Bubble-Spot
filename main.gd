extends Node

@export var game_pack: PackedScene = preload("res://game/Game.tscn")

var world_size: Vector2i = Vector2i(16,16)
var game: Node2D
var gatherers: Array

@onready var main_menu: Control = %MainMenu
@onready var start: Button = %Start
@onready var quit: Button = %NotStart

func _ready() -> void:
	for x: int in world_size.x:
		for y: int in world_size.y:
			pass
	var gs: int = 20
	for g: int in gs:
		pass
	start.grab_focus()
	start.pressed.connect(start_game)
	quit.pressed.connect(get_tree().quit)

func _process(_delta: float) -> void:
	pass

func start_game() -> void:
	main_menu.hide()
	game = game_pack.instantiate()
	add_child(game)
	game.to_main.connect(end_game)

func end_game() -> void:
	game.to_main.disconnect(end_game)
	remove_child(game)
	game.queue_free()
	main_menu.show()
