extends Node

@export var game_pack: PackedScene = preload("res://game/Game.tscn")
var time_range: int = 10:
	set(value):
		time_range = clampi(value,10,3600)
	get():
		return time_range

var game: Node2D

@onready var round_time: Label = %Round
@onready var main_menu: Control = %MainMenu
@onready var start: Button = %Start
@onready var quit: Button = %NotStart
@onready var start_sound: AudioStreamPlayer = %StartSound

func _ready() -> void:
	start.grab_focus()
	start.pressed.connect(start_game)
	quit.pressed.connect(get_tree().quit)

func _process(_delta: float) -> void:
	round_time.text = "Round time " + str(time_range) + " sec"

func start_game() -> void:
	main_menu.hide()
	game = game_pack.instantiate()
	add_child(game)
	game.world_timer.wait_time = time_range
	game.to_main.connect(end_game)
	start_sound.stop()

func end_game() -> void:
	game.to_main.disconnect(end_game)
	remove_child(game)
	game.queue_free()
	main_menu.show()

func _on_lower_pressed() -> void:
	time_range -= 1

func _on_higher_pressed() -> void:
	time_range += 1
