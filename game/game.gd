extends Node2D

@export var images: Array[Texture2D]

var menu_stuff: PackedScene = preload("res://game/choices.tscn")
var its_on: bool = true
#var tmp_resource: int = 0
var world_size: Vector2i = Vector2i(16,16)
var gatherers: Array[Gatherer]
var society: int = 0
var choices: Choices

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
@onready var prelude: ColorRect = %Prelude
@onready var bg: TextureRect = %BG

signal to_main()

func _ready() -> void:
	prelude.start.connect(start_already)
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
	choices = menu_stuff.instantiate() #var
	choice_menu.add_child(choices)
	choices.for_society_p.connect(dona.bind(true))
	choices.random.connect(more_resu)
	#world_timer.wait_time = 60*2
	world_timer.timeout.connect(end_game)
	to_main_menu.pressed.connect(to_main.emit)
	#await get_tree().create_timer(12.0).timeout
	
func start_already():
	if choices: choices.button1.grab_focus()
	world_timer.start()
	for b: Bot in bots_node.get_children():
		b.exploration_decision()

func _process(_delta: float) -> void:
	if its_on:
		time_label.text = "Time: " + str(int(world_timer.time_left))
	res_label.text = "Current resources: " + str(gatherers[0].resources[0])

func create_bot(gatherer: Gatherer):
	gatherer.nimi = namegen.name_chooser(namegen.available_languages.pick_random())
	var bot: Bot = Bot.new()
	bot.resu = gatherer
	bot.resu.altruism = randf()
	bots_node.add_child(bot)
	bot.for_society.connect(dona)

func end_game():
	%P.hide()
	scrolli.hide()
	choice_menu.hide()
	its_on = false
	time_label.text = "It haz ended"
	var end_list: Array[Gatherer]
	end_list.append(gatherers[0]) #player
	var soc = Gatherer.new()
	soc.resources[0] = society
	soc.nimi = "SOCIETY"
	end_list.append(soc)
	for bot: Bot in bots_node.get_children():
		bot.end = true
		end_list.append(bot.resu)
	end_list.sort_custom(func(a: Gatherer, b: Gatherer): return a.resources[0] > b.resources[0])
	for index: int in end_list.size():
		var lbl: Label = Label.new()
		lbl.text = end_list[index].nimi + ": " + str(end_list[index].resources[0])
		results.add_child(lbl)
	for index: int in end_list.size():
		if end_list[index].nimi == "SOCIETY":
			if index < 3:
				bg.texture = images[0]
				$Golden.play()
				break
			if index > 15:
				bg.texture = images[2]
				$Stone.play()
				break
			else:
				bg.texture = images[1]
				$Normal.play()
				break

func more_resu(amt: int):
	#scrolli.follow_focus
	var resname: String = " " + Global.resource_name
	if amt > 1: resname += "s"
	gatherers[0].resources[0] += amt
	ress.text += "\nYou found " + str(amt) + resname
	await get_tree().create_timer(.01).timeout
	var sc = scrolli.get_v_scroll_bar()
	sc.value = sc.max_value
	#gatherers[0].resources[0] = tmp_resource
	
func dona(p: bool = false):
	if p && gatherers[0].resources[0] > 0:
		gatherers[0].resources[0] -= 1
		society += 1
	else: society += 1
