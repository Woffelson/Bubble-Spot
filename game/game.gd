extends Node2D

var its_on: bool = true

@onready var world_timer: Timer = %WorldTimer
@onready var time_label: Label = %TimeLabel

func _ready() -> void:
	world_timer.wait_time = 2 #60*2
	world_timer.start()
	world_timer.timeout.connect(end_game)

func _process(_delta: float) -> void:
	if its_on:
		time_label.text = "Time: " + str(int(world_timer.time_left))

func end_game():
	its_on = false
	time_label.text = "It haz ended"
