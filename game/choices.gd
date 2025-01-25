extends Control

var amount: int = 0

@onready var duration: ProgressBar = %Duration
@onready var options: HBoxContainer = %Options
@onready var button1: Button = %Button1
@onready var button2: Button = %Button2
@onready var button3: Button = %Button3
@onready var timer: Timer = %Timer

signal random(resu)

func _ready() -> void:
	button1.pressed.connect(time_begin.bind(2.0))
	button2.pressed.connect(time_begin.bind(4.0))
	button3.pressed.connect(time_begin.bind(6.0))

func _process(_delta: float) -> void:
	duration.value = duration.max_value - timer.time_left

func time_begin(time):
	timer.wait_time = time
	duration.max_value = timer.wait_time
	amount = randi_range(0,time)
	print(amount)
	timer.start(time)
	duration.show()
	options.hide()

func _on_timer_timeout() -> void:
	options.show()
	duration.hide()
	random.emit(amount)
