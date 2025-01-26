extends Node2D

var resource_name: String = "mushroom"
var menu_stuff: PackedScene = preload("res://game/choices.tscn")
var its_on: bool = true
var tmp_resource: int = 0

@onready var world_timer: Timer = %WorldTimer
@onready var time_label: Label = %TimeLabel
@onready var to_main_menu: Button = %ToMainMenu
@onready var res_label: Label = %ResLabel
@onready var choice_menu: CenterContainer = %ChoiceMenu
@onready var ress: Label = %Ress
@onready var scrolli: ScrollContainer = %Scrolli

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
	#scrolli.follow_focus
	var resname: String = " " + resource_name
	if amt > 1: resname += "s"
	tmp_resource += amt
	ress.text += "\nYou found " + str(amt) + resname
	await get_tree().create_timer(.01).timeout
	var sc = scrolli.get_v_scroll_bar()
	sc.value = sc.max_value
