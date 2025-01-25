extends Node2D

var menu_stuff: PackedScene = preload("res://game/choices.tscn")
var its_on: bool = true
var tmp_resource: int = 0

@onready var world_timer: Timer = %WorldTimer
@onready var time_label: Label = %TimeLabel
@onready var to_main_menu: Button = %ToMainMenu
@onready var res_label: Label = %ResLabel
@onready var choice_menu: CenterContainer = %ChoiceMenu

signal to_main()

func _ready() -> void:
	var choices = menu_stuff.instantiate()
	choice_menu.add_child(choices)
	choices.random.connect(more_resu)
	world_timer.wait_time = 60*2
	world_timer.start()
	world_timer.timeout.connect(end_game)
	to_main_menu.pressed.connect(to_main.emit)

func _process(_delta: float) -> void:
	if its_on:
		time_label.text = "Time: " + str(int(world_timer.time_left))
	res_label.text = "Current resources: " + str(tmp_resource)

func end_game():
	its_on = false
	time_label.text = "It haz ended"

func more_resu(amt: int):
	tmp_resource += amt
