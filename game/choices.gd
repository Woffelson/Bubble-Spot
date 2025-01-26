class_name Choices extends Control

var amount: int = 0

@onready var duration: ProgressBar = %Duration
@onready var options: HBoxContainer = %Options
@onready var button1: Button = %Button1
@onready var button2: Button = %Button2
@onready var button3: Button = %Button3
@onready var timer: Timer = %Timer
@onready var donatello: Button = %Button

signal random(resu)
signal for_society_p()

func _ready() -> void:
	donatello.text = "Donate 1 " + Global.resource_name + " for greater good" #🥺️
	donatello.pressed.connect(for_society_p.emit)
	button1.pressed.connect(time_begin.bind(2.0, Global.Alternatives.NEAR))
	button2.pressed.connect(time_begin.bind(4.0, Global.Alternatives.MID))
	button3.pressed.connect(time_begin.bind(6.0, Global.Alternatives.FAR))

func _process(_delta: float) -> void:
	duration.value = duration.max_value - timer.time_left

func time_begin(time: float, alt: Global.Alternatives):
	timer.wait_time = time
	duration.max_value = timer.wait_time
	amount = randi_range(0,time)
	print(amount)
	timer.start(time)
	duration.show()
	options.hide()

func _on_timer_timeout() -> void:
	button1.grab_focus()
	options.show()
	duration.hide()
	random.emit(amount)
