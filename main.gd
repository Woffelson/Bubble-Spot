extends Node

@export var game_pack: PackedScene = preload("res://game/Game.tscn")

@onready var world_timer: Timer = %WorldTimer
@onready var main_menu: Control = %MainMenu
@onready var start: Button = %Start
@onready var quit: Button = %NotStart

func _ready() -> void:
	start.pressed.connect(start_game)
	quit.pressed.connect(get_tree().quit)

func _process(_delta: float) -> void:
	pass

func start_game() -> void:
	main_menu.hide()
	var game: Node2D = game_pack.instantiate()
	add_child(game)
