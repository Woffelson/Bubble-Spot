class_name Bot extends Node

var id: int = 0
var resu: Gatherer
var exploring: bool = false
var decision: Global.Alternatives
var amount: int = 0
var end: bool = false

@onready var timer: Timer = Timer.new()

func _ready() -> void:
	#print(timer)
	add_child(timer)
	timer.timeout.connect(free_time)
	timer.one_shot = true
	await get_tree().create_timer(12.0).timeout
	exploration_decision()

func exploration_decision() -> void:
	if !exploring && !end:
		decision = Global.Alternatives.values().pick_random()
		match decision:
			Global.Alternatives.NEAR:
				timer.wait_time = 2.0
			Global.Alternatives.MID:
				timer.wait_time = 4.0
			Global.Alternatives.FAR:
				timer.wait_time = 6.0
		amount = randi_range(0,int(timer.wait_time))
		exploring = true
		timer.start(timer.wait_time)

func free_time() -> void:
	exploring = false
	if resu:
		resu.resources[0] += amount
		print([resu.nimi, resu.resources[0]])
	await get_tree().create_timer(randf_range(1.0,10.0)).timeout
	exploration_decision()
