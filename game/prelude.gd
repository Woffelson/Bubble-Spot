extends ColorRect

var time: float = 4.0
var hnngh: bool = false
@onready var timer: Timer = Timer.new()

signal start()

func _ready() -> void:
	add_child(timer)
	await get_tree().create_timer(8.0).timeout
	hnngh = true
	timer.start(time)
	timer.timeout.connect(yoo)

func _process(_delta: float) -> void:
	if hnngh: $Society.modulate.a = timer.wait_time / time - timer.time_left / time
	if Input.is_action_just_pressed("ui_accept"):
		yoo()

func yoo():
	start.emit()
	queue_free()
