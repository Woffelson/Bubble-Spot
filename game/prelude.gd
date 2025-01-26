extends ColorRect

var time: float = 4.0
var hnngh: bool = false
@onready var timer: Timer = Timer.new()

func _ready() -> void:
	add_child(timer)
	await get_tree().create_timer(8.0).timeout
	hnngh = true
	timer.start(time)
	timer.timeout.connect(queue_free)

func _process(_delta: float) -> void:
	if hnngh: $Society.modulate.a = timer.wait_time / time - timer.time_left / time
