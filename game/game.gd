extends Node2D

var resource_name: String = "mushroom"
var menu_stuff: PackedScene = preload("res://game/choices.tscn")
var its_on: bool = true
#var tmp_resource: int = 0
var world_size: Vector2i = Vector2i(16,16)
var gatherers: Array[Gatherer]

@onready var bots_node: Node = %Bots
@onready var world_timer: Timer = %WorldTimer
@onready var time_label: Label = %TimeLabel
@onready var to_main_menu: Button = %ToMainMenu
@onready var res_label: Label = %ResLabel
@onready var choice_menu: CenterContainer = %ChoiceMenu
@onready var ress: Label = %Ress
@onready var scrolli: ScrollContainer = %Scrolli
@onready var results: VBoxContainer = %Results
@onready var namegen = NameGenerator.new()

signal to_main()

func _ready() -> void:
	for x: int in world_size.x:
		for y: int in world_size.y:
			pass
	var gs: int = 20
	for g: int in gs:
		var gatherer: Gatherer = Gatherer.new()
		if g == 0:
			gatherer.player = true
			gatherer.nimi = "Player (yea, that's you)"
		else:
			create_bot(gatherer)
		gatherers.append(gatherer)
	var choices = menu_stuff.instantiate()
	choice_menu.add_child(choices)
	choices.random.connect(more_resu)
	#world_timer.wait_time = 60*2
	world_timer.timeout.connect(end_game)
	to_main_menu.pressed.connect(to_main.emit)
	await get_tree().create_timer(12.0).timeout
	world_timer.start()

func _process(_delta: float) -> void:
	if its_on:
		time_label.text = "Time: " + str(int(world_timer.time_left))
	res_label.text = "Current resources: " + str(gatherers[0].resources[0])

func create_bot(gatherer: Gatherer):
	gatherer.nimi = namegen.name_chooser(namegen.available_languages.pick_random())
	var bot: Bot = Bot.new()
	bot.resu = gatherer
	bots_node.add_child(bot)

func end_game():
	its_on = false
	time_label.text = "It haz ended"
	var end_list: Array[Gatherer]
	end_list.append(gatherers[0]) #player
	for bot: Bot in bots_node.get_children():
		bot.end = true
		end_list.append(bot.resu)
	end_list.sort_custom(func(a: Gatherer, b: Gatherer): return a.resources[0] > b.resources[0])
	for gg: Gatherer in end_list:
		var lbl: Label = Label.new()
		lbl.text = gg.nimi + ": " + str(gg.resources[0])
		results.add_child(lbl)

func more_resu(amt: int):
	#scrolli.follow_focus
	var resname: String = " " + resource_name
	if amt > 1: resname += "s"
	gatherers[0].resources[0] += amt
	ress.text += "\nYou found " + str(amt) + resname
	await get_tree().create_timer(.01).timeout
	var sc = scrolli.get_v_scroll_bar()
	sc.value = sc.max_value
	#gatherers[0].resources[0] = tmp_resource
	
